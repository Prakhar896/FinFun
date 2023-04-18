//
//  Extensions.swift
//  FinFun
//
//  Created by Prakhar Trivedi on 11/4/23.
//

import Foundation
import SwiftUI

extension UserDefaults {
    enum KeyEnumeration: String {
        case currentLessonID = "CurrentLessonID"
    }
    
    static func getKeyString(_ key: KeyEnumeration) -> String {
        return key.rawValue
    }
    
    static func clearAll() {
        let defaults = standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

extension Date {
    func dateStringWith(strFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = strFormat
        return dateFormatter.string(from: self)
    }
}

extension FileManager {
    static func getPlistDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("Your plist directory is at: \(documentsPath)")
    }
    
    static func deletePlistFile(withName name: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let plistURL = documentsDirectory.appendingPathComponent("\(name).plist")
        
        do {
            try FileManager.default.removeItem(at: plistURL)
            print("Successfully deleted plist file: \(name).plist from documents directory.")
        } catch {
            print("Error deleting plist file '\(name).plist': \(error.localizedDescription)")
        }
    }
}

/// An animatable modifier that is used for observing animations for a given animatable value.
struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {

    /// While animating, SwiftUI changes the old input value to the new target value using this property. This value is set to the old value until the animation completes.
    var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }

    /// The target value for which we're observing. This value is directly set once the animation starts. During animation, `animatableData` will hold the oldValue and is only updated to the target value once the animation completes.
    private var targetValue: Value

    /// The completion callback which is called once the animation completes.
    private var completion: () -> Void

    init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        targetValue = observedValue
    }

    /// Verifies whether the current animation is finished and calls the completion callback if true.
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }

        /// Dispatching is needed to take the next runloop for the completion callback.
        /// This prevents errors like "Modifying state during view update, this will cause undefined behavior."
        DispatchQueue.main.async {
            self.completion()
        }
    }

    func body(content: Content) -> some View {
        /// We're not really modifying the view so we can directly return the original input value.
        return content
    }
}

extension View {

    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - completion: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }
}
