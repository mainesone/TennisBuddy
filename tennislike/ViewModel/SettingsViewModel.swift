//
//  SettingsViewModel.swift
//  tennislike
//
//  Created by Maik Nestler on 08.12.20.
//

import UIKit

enum SettingsSections: Int, CaseIterable {
    case name
    case skill
    case age
    case club
    case ageRange
    
    var description: String {
        switch self {
        
        case .name: return "Name"
        case .skill: return "Niveau"
        case .age: return "Alter"
        case .club: return "Verein"
        case .ageRange: return "Spieler in deinem Altersbereich"
        }
    }
}

struct SettingsViewModel {
    private let user: User
    let section: SettingsSections
    
    let placeholderText: String
    
    var value: String?
    
    var shouldHideInputField: Bool {
        return section == .ageRange
    }
    
    var shouldHideSlider: Bool {
        return section != .ageRange
    }
    
    var minAgeSliderValue: Float {
        return Float(user.minSeekingAge)
    }
    
    var maxAgeSliderValue: Float {
        return Float(user.maxSeekingAge)
    }
    
    func minAgeLabelText(forValue value: Float) -> String {
        return "Von: \(Int(value))"
    }
    
    func maxAgeLabelText(forValue value: Float) -> String {
        return "Bis: \(Int(value))"
    }
    
    
    init(user: User, section: SettingsSections) {
        self.user = user
        self.section = section
        
        placeholderText = "Bitte \(section.description) eintragen"
        
        switch section {
        case .name:
            value = user.name
        case .skill:
            value = user.skill
        case .age:
            value = "\(user.age)"
        case .club:
            value = user.club
        case .ageRange:
            break 
        }
    }
}
