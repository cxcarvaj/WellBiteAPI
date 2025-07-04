//
//  NutritionPlanItems.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class NutritionPlanItems: Model, @unchecked Sendable {
    static let schema: String = "nutrition_plan_items"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: .nutritionPlanId) var nutritionPlan: NutritionPlans
    
    @Field(key: .dayOfWeek) var date: Int
    @Enum(key: .mealType) var mealType: MealType
    @Field(key: .description) var description: String
    @Field(key: .imageUrl) var imageUrl: String
    @Field(key: .kcalTarget) var kcalTarget: Int
    
    // Relationships
    @Children(for: \.$nutritionPlanItem) var dailyMealTrackings: [DailyMealTrackings]
    
    init() {}
    
    init(id: UUID? = nil,
         nutritionPlan: NutritionPlans.IDValue,
         date: Int,
         mealType: MealType,
         description: String,
         imageUrl: String,
         kcalTarget: Int,
    ) {
        self.id = id
        self.$nutritionPlan.id = nutritionPlan
        self.date = date
        self.mealType = mealType
        self.description = description
        self.imageUrl = imageUrl
        self.kcalTarget = kcalTarget
    }

}

