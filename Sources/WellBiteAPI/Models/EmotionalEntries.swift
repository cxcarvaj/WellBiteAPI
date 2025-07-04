//
//  EmotionalEntries.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class EmotionalEntries: Model, @unchecked Sendable {
    static let schema = "emotional_entries"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: .userId) var user: Users
    @Parent(key: .mealEntryId) var mealEntry: MealEntries

    @Enum(key: .mood) var mood: Mood
    @Field(key: .description) var description: String?
    @Timestamp(key: .createdAt, on: .create) var createdAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        userId: Users.IDValue,
        mealEntryId: MealEntries.IDValue,
        mood: Mood,
        description: String? = nil
    ) {
        self.id = id
        self.$user.id = userId
        self.$mealEntry.id = mealEntryId
        self.mood = mood
        self.description = description
    }
}
