//
//  Extensions.swift
//  FinFun
//
//  Created by Prakhar Trivedi on 11/4/23.
//

import Foundation

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
        print("Your expenses plist is at: \(documentsPath)")
    }
}
