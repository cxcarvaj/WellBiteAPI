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
    @OptionalParent(key: .nutritionPlanItemId) var nutritionPlanItem: NutritionPlanItems?

    @Enum(key: .mealType) var mealType: MealType
    @Field(key: .isCompleted) var isCompleted: Bool
    @Field(key: .plannedKcal) var plannedKcal: Int?
    
    // Relationships
    @OptionalChild(for: \.$dailyMealTracking) var mealEntry: MealEntries?

    init() {}
    
    init(
        id: UUID? = nil,
        dailyTrackingId: DailyTrackings.IDValue,
        nutritionPlanItemId: NutritionPlanItems.IDValue? = nil,
        mealType: MealType,
        isCompleted: Bool = false,
        plannedKcal: Int? = nil
    ) {
        self.id = id
        self.$dailyTracking.id = dailyTrackingId
        if let itemId = nutritionPlanItemId {
            self.$nutritionPlanItem.id = itemId
        }
        self.mealType = mealType
        self.isCompleted = isCompleted
        self.plannedKcal = plannedKcal
    }
}
