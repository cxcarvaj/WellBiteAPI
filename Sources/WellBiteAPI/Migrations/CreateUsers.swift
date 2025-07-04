//
//  CreateUsers.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//

import Vapor
import Fluent

final class CreateUsers: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let userRoleEnum = try await database.enum("user_role").read()
        let genderEnum = try await database.enum("gender").read()
        
        try await database.schema(Users.schema)
             .id()
             .field(.email, .string, .required)
             .field(.password, .string, .required)
             .field(.firstName, .string, .required)
             .field(.lastName, .string, .required)
             .field(.userRole, userRoleEnum, .required, .custom("DEFAULT 'none'"))
             .field(.birthday, .date, .required)
             .field(.gender, genderEnum, .required)
             .field(.avatar, .string)
             .field(.createdAt, .datetime)
             .field(.updatedAt, .datetime)
             .unique(on: .email)
             .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(Users.schema).delete()
    }
}
