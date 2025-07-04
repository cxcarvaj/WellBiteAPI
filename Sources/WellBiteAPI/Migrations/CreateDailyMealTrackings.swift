//
//  CreateDailyMealTrackings.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class CreateDailyMealTrackings: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let mealType = try await database.enum("meal_type").read()
        
        try await database.schema(DailyMealTrackings.schema)
            .id()
            .field(.dailyTrackingId, .uuid, .required, .references(DailyTrackings.schema, .id, onDelete: .cascade))
            .field(.nutritionPlanItemId, .uuid, .references(NutritionPlanItems.schema, .id, onDelete: .setNull))
            .field(.mealType, mealType, .required)
            .field(.isCompleted, .bool, .required, .sql(.default(false)))
            .field(.plannedKcal, .int)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(DailyMealTrackings.schema).delete()
    }
}
