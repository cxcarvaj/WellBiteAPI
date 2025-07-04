//
//  CreateMealEntries.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class CreateMealEntries: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let mealType = try await database.enum("meal_type").read()
        
        try await database.schema(MealEntries.schema)
            .id()
            .field(.userId, .uuid, .required, .references(Users.schema, .id, onDelete: .cascade))
            .field(.dailyTrackingId, .uuid, .required, .references(DailyTrackings.schema, .id, onDelete: .cascade))
            .field(.dailyMealTrackingId, .uuid, .references(DailyMealTrackings.schema, .id, onDelete: .setNull))
            .field(.mealType, mealType, .required)
            .field(.photoUrl, .string, .required)
            .field(.mealTime, .datetime, .required)
            .field(.notes, .string)
            .field(.aiKcalEstimate, .int)
            .field(.aiMacrosEstimate, .string)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(MealEntries.schema).delete()
    }
}
