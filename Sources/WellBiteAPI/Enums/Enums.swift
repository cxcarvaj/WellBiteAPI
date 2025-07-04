//
//  Enums.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

enum UserRole: String, Codable {
    case admin, professional, client, none
}

enum Gender: String, Codable {
    case male, female, other
}

enum MealType: String, Codable {
    case breakfast, lunch, dinner, snack
}

enum PlanType: String, Codable {
    case basic, premium
}

enum Mood: String, Codable {
    case happy, satisfied, neutral, unsatisfied, sad, anxious, guilty, frustrated
}
