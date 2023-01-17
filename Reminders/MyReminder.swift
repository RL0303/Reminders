//
//  MyReminder.swift
//  Reminders
//
//  Created by Robert Lin on 2023/1/17.
//

import Foundation

struct MyReminder : Codable {
    let title: String
    let body: String
    let date: Date
    let identifier: String
    
    static func loadModels() -> [MyReminder]? {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.data(forKey: "models") else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([MyReminder].self, from: data)
    }
    
    static func saveModels(_ models: [MyReminder]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(models) else { return }
        UserDefaults.standard.set(data, forKey: "models")
    }
}
