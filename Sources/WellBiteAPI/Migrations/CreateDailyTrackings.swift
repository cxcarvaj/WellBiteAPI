//
//  CreateDailyTrackings.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//

import Vapor
import Fluent

final class CreateDailyTrackings: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(DailyTrackings.schema)
            .id()
            .field(.userId, .uuid, .required, .references(Users.schema, .id, onDelete: .cascade))
            .field(.date, .date, .required)
            .field(.totalKcalGoal, .int, .required)
            .field(.totalKcalConsumed, .int, .required, .sql(.default(0)))
            .field(.waterGoalMl, .int, .required)
            .field(.waterIntakeMl, .int, .required, .sql(.default(0)))
            .field(.mealsCompleted, .int, .required, .sql(.default(0)))
            .field(.emotionSummary, .string)
            .field(.createdAt, .datetime)
            .unique(on: .userId, .date) // Esta restricción garantiza que un usuario solo tenga un registro por día
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(DailyTrackings.schema).delete()
    }
}
