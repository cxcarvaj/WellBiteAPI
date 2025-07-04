//
//  MealEntries.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class MealEntries: Model, @unchecked Sendable {
    static let schema = "meal_entries"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: .userId) var user: Users
    @Parent(key: .dailyTrackingId) var dailyTracking: DailyTrackings
    @OptionalParent(key: .dailyMealTrackingId) var dailyMealTracking: DailyMealTrackings?
    
    @Field(key: .photoUrl) var photoUrl: String
    @Field(key: .mealTime) var mealTime: Date
    @Field(key: .notes) var notes: String?
    @Field(key: .aiKcalEstimate) var aiKcalEstimate: Int?
    @Field(key: .aiMacrosEstimate) var aiMacrosEstimate: String? // JSON o formato estructurado
    
    // Relationships
    @OptionalChild(for: \.$mealEntry) var emotionalEntry: EmotionalEntries?

    init() {}
    
    init(
        id: UUID? = nil,
        userId: Users.IDValue,
        dailyTrackingId: DailyTrackings.IDValue,
        dailyMealTrackingId: DailyMealTrackings.IDValue? = nil,
        photoUrl: String,
        mealTime: Date,
        notes: String? = nil,
        aiKcalEstimate: Int? = nil,
        aiMacrosEstimate: String? = nil
    ) {
        self.id = id
        self.$user.id = userId
        self.$dailyTracking.id = dailyTrackingId
        if let trackingId = dailyMealTrackingId {
            self.$dailyMealTracking.id = trackingId
        }
        self.photoUrl = photoUrl
        self.mealTime = mealTime
        self.notes = notes
        self.aiKcalEstimate = aiKcalEstimate
        self.aiMacrosEstimate = aiMacrosEstimate
    }
}
