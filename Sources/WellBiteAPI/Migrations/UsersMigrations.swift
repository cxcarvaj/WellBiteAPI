//
//  UsersMigrations.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//

import Vapor
import Fluent

struct UsersMigrations: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let userRole = try await database.enum("user_role")
            .case("admin")
            .case("client")
            .case("professional")
            .case("none")
            .create()
        
        let gender = try await database.enum("gender")
            .case("male")
            .case("female")
            .case("other")
            .create()
        
        try await database.schema(Users.schema)
             .id()
             .field(.email, .string, .required)
             .unique(on: .email)
             .field(.password, .string, .required)
             .field(.firstName, .string, .required)
             .field(.lastName, .string, .required)
             .field(.userRole, userRole, .required, .custom("DEFAULT 'none'"))
             .field(.birthday, .date, .required)
             .field(.gender, gender, .required)
             .field(.avatar, .string)
             .field(.showKcal, .bool, .required, .sql(.default(false)))
             .field(.createdAt, .datetime)
             .field(.updatedAt, .datetime)
             .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(Users.schema).delete()
        try await database.enum("role").delete()
        try await database.enum("gender").delete()
    }
    
    
    
}
