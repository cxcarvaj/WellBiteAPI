//
//  CreateRefreshTokens.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class CreateRefreshTokens: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(RefreshTokens.schema)
            .id()
            .field(.userId, .uuid, .required, .references(Users.schema, .id, onDelete: .cascade))
            .field(.token, .string, .required)
            .field(.expiresAt, .datetime, .required)
            .field(.isRevoked, .bool, .required, .sql(.default(false)))
            .field(.createdAt, .datetime)
            .field(.updatedAt, .datetime)
            .unique(on: .token) // El token debe ser único
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(RefreshTokens.schema).delete()
    }
}
