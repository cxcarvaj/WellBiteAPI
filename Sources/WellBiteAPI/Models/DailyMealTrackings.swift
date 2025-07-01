//
//  DailyMealTrackings.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class DailyMealTrackings: Model, @unchecked Sendable {
    static let schema: String = "daily_meal_trackings"

    @ID(key: .id) var id: UUID?
    @Parent(key: .dailyTrackingId) var dailyTracking: DailyTrackings
    @OptionalParent(key: .mealEntryId) var mealEntry: MealEntries? // Relación opcional

    @Enum(key: .mealType) var mealType: MealType
    @Field(key: .isCompleted) var isCompleted: Bool
    @Field(key: .kcalEstimate) var kcalEstimate: Int?
    @Field(key: .plannedKcal) var plannedKcal: Int?
    
    init() {}
    
    init(
        id: UUID? = nil,
        dailyTrackingId: DailyTrackings.IDValue,
        mealEntryId: MealEntries.IDValue? = nil,
        mealType: MealType,
        isCompleted: Bool = false,
        kcalEstimate: Int? = nil,
        plannedKcal: Int? = nil
    ) {
        self.id = id
        self.$dailyTracking.id = dailyTrackingId
        if let mealEntryId = mealEntryId {
            self.$mealEntry.id = mealEntryId
        }
        self.mealType = mealType
        self.isCompleted = isCompleted
        self.kcalEstimate = kcalEstimate
        self.plannedKcal = plannedKcal
    }
}
