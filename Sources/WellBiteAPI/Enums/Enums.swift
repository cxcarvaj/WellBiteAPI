//
//  Enums.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

/// Represents the user roles available in the application.
/// Roles determine the permissions and access a user has within the system.
enum Role: String, Codable {
    case admin, professional, client, none
}

/// Represents the user genders available in the application.
enum Gender: String, Codable {
    case male, female, other
}

/// Represents the different meals type that are available in the application.
enum MealType: String, Codable {
    case breakfast, lunch, dinner, snack
}

/// Represents the user subscription plan
enum PlanType: String, Codable {
    case basic, premium
}

/// Represents the user mood
enum Mood: String, Codable {
    case happy, satisfied, neutral, unsatisfied, sad, anxious, guilty, frustrated
}
