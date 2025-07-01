//
//  DailyMealTrackingsMigration.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

struct DailyMealTrackingsMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let mealType = try await database.enum("meal_type")
            .case("breakfast")
            .case("lunch")
            .case("dinner")
            .case("snack")
            .create()
        
        try await database.schema(DailyMealTrackings.schema)
            .id()
            .field(.dailyTrackingId, .uuid, .required, .references(DailyTrackings.schema, .id, onDelete: .cascade))
            .field(.mealEntryId, .uuid, .references(MealEntries.schema, .id, onDelete: .cascade))
            .field(.mealType, mealType, .required)
            .field(.isCompleted, .bool, .required, .sql(.default(false)))
            .field(.kcalEstimate, .int)
            .field(.plannedKcal, .int)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(DailyMealTrackings.schema).delete()
        try await database.enum("meal_type").delete()
    }
}
