//
//  EmotionalEntries.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

enum Mood: String, Codable {
    case happy
    case satisfied
    case neutral
    case unsatisfied
    case sad
    case anxious
    case guilty
    case frustrated
}

final class EmotionalEntries: Model, @unchecked Sendable {
    static let schema = "emotional_entries"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: .userId) var user: Users
    @OptionalParent(key: .mealEntryId) var mealEntry: MealEntries?
    
    @Enum(key: .mood) var mood: Mood
    @Field(key: .description) var description: String?
    @Timestamp(key: .createdAt, on: .create) var createdAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        userId: Users.IDValue,
        mealEntryId: MealEntries.IDValue? = nil,
        mood: Mood,
        description: String? = nil
    ) {
        self.id = id
        self.$user.id = userId
        if let mealEntryId = mealEntryId {
            self.$mealEntry.id = mealEntryId
        }
        self.mood = mood
        self.description = description
    }
}
