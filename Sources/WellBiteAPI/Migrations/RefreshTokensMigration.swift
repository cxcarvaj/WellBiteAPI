//
//  RefreshTokensMigration.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

struct RefreshTokensMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(RefreshTokens.schema)
            .id()
            .field("user_id", .uuid, .required, .references(Users.schema, "id", onDelete: .cascade))
            .field("token", .string, .required)
            .field("expires_at", .datetime, .required)
            .field("is_revoked", .bool, .required, .custom("DEFAULT FALSE"))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "token") // El token debe ser único
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(RefreshTokens.schema).delete()
    }
}
