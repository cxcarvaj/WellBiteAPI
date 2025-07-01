//
//  MealEntriesMigration.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

struct MealEntriesMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(MealEntries.schema)
            .id()
            .field(.userId, .uuid, .required, .references(Users.schema, .id, onDelete: .cascade))
            .field(.photoUrl, .string, .required)
            .field(.mealTime, .datetime, .required)
            .field(.notes, .string)
            .field(.aiKcalEstimate, .int)
            .field(.aiMacrosEstimate, .string)
            .field(.createdAt, .datetime)
            .field(.updatedAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(MealEntries.schema).delete()
    }
}
