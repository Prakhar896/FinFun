//
//  File.swift
//  
//
//  Created by Prakhar Trivedi on 10/4/23.
//

import Foundation

class AppState: ObservableObject {
    // MARK: Learn Section
    @Published var lessons: [Lesson] {
        didSet {
            AppState.saveLessonsToFile(lessons: lessons)
        }
    }
    @Published var currentLesson: Lesson {
        didSet {
            UserDefaults.standard.set(currentLesson.id, forKey: UserDefaults.getKeyString(.currentLessonID))
        }
    }
    
    var lessonsCompleted: Int {
        var completed = 0
        for lesson in lessons {
            if lesson.completed {
                completed += 1
            }
        }
        
        return completed
    }
    var completedLearnCourse: Bool {
        lessonsCompleted == lessons.count
    }
    
    static func saveLessonsToFile(lessons: [Lesson]) {
        let plistName = "Learn"
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedLessons = try? propertyListEncoder.encode(lessons)
        
        try? encodedLessons?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadLessonsFromFile() -> [Lesson]? {
        let plistName = "Learn"
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist")
        
        let propertyListDecoder = PropertyListDecoder()
        
        guard let retrievedLessonsData = try? Data(contentsOf: archiveURL) else { return nil }
        guard let decodedLessons = try? propertyListDecoder.decode(Array<Lesson>.self, from: retrievedLessonsData) else { return nil }
        return decodedLessons
    }
    
    init() {
        // Try loading lesson data from plist file, otherwise load default lessons
        var localLessonsCopy: [Lesson]? = nil
        if let loadedLessonData = AppState.loadLessonsFromFile() {
            lessons = loadedLessonData
            
            localLessonsCopy = loadedLessonData
        } else {
            lessons = Lesson.loadDefaultLessons()
            
            localLessonsCopy = Lesson.loadDefaultLessons()
        }
        
        if let currentLessonID = UserDefaults.standard.string(forKey: UserDefaults.getKeyString(.currentLessonID)) {
            currentLesson = localLessonsCopy?.filter({ $0.id == currentLessonID }).first ?? Lesson.loadDefaultLessons()[0]
        } else {
            currentLesson = Lesson.loadDefaultLessons()[0]
        }
    }
}
