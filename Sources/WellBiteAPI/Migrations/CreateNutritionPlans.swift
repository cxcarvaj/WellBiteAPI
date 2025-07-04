//
//  CreateNutritionPlans.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class CreateNutritionPlans: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(NutritionPlans.schema)
            .id()
            .field(.userId, .uuid, .required, .references(Users.schema, .id, onDelete: .cascade))
            .field(.professionalId, .uuid, .required, .references(Users.schema, .id, onDelete: .cascade))
            .field(.title, .string, .required)
            .field(.startDate, .datetime, .required)
            .field(.endDate, .datetime, .required)
            .field(.createdAt, .datetime)
            .create()

    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(NutritionPlans.schema).delete()
    }
}
