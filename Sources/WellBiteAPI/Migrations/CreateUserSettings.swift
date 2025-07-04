//
//  CreateUserSettings.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 4/7/25.
//

import Vapor
import Fluent

final class CreateUserSettings: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(UserSettings.schema)
            .id()
            .field(.userId, .uuid, .required, .references(Users.schema, .id, onDelete: .cascade))
            .field(.showKcal, .bool, .required, .sql(.default(false)))
            .field(.createdAt, .datetime)
            .field(.updatedAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(UserSettings.schema).delete()
    }
}
