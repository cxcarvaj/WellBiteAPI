//
//  CreateNutritionPlanItems.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class CreateNutritionPlanItems: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let mealType = try await database.enum("meal_type").read()

        try await database.schema(NutritionPlanItems.schema)
            .id()
            .field(.nutritionPlanId, .uuid, .required, .references(NutritionPlans.schema, .id, onDelete: .cascade))
            .field(.dayOfWeek, .int, .required)
            .field(.mealType, mealType, .required)
            .field(.description, .string, .required)
            .field(.imageUrl, .string, .required)
            .field(.kcalTarget, .int, .required)
            .create()

    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(NutritionPlanItems.schema).delete()
    }
}
