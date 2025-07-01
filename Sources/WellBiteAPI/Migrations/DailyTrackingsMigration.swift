//
//  DailyTrackingsMigration.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//

import Vapor
import Fluent

struct DailyTrackingsMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(DailyTrackings.schema)
            .id()
            .field(.userId, .uuid, .required, .references(Users.schema, .id, onDelete: .cascade))
            .field(.date, .date, .required)
            .field(.totalKcalGoal, .int)
            .field(.totalKcalConsumed, .int)
            .field(.waterGoalml, .int, .required)
            .field(.waterIntakeml, .int, .required)
            .field(.mealsCompleted, .int, .required)
            .field(.emotionSummary, .string)
            .field(.createdAt, .datetime)
            // Esta restricción garantiza que un usuario solo tenga un registro por día
            .unique(on: .userId, .date)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(DailyTrackings.schema).delete()
    }
}
