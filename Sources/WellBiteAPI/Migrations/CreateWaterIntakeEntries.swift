//
//  CreateWaterIntakeEntries.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class CreateWaterIntakeEntries: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(WaterIntakeEntries.schema)
            .id()
            .field(.dailyTrackingId, .uuid, .required, .references(DailyTrackings.schema, .id, onDelete: .cascade))
            .field(.amountMl, .int, .required)
            .field(.timestamp, .datetime, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(WaterIntakeEntries.schema).delete()
    }
}

