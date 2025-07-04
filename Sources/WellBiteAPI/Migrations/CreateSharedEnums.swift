//
//  CreateSharedEnums.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class CreateSharedEnums: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let _ = try await database.enum("meal_type")
            .case("breakfast")
            .case("lunch")
            .case("dinner")
            .case("snack")
            .create()
            
        let _ = try await database.enum("user_role")
            .case("admin")
            .case("client")
            .case("professional")
            .case("none")
            .create()
            
        let _ = try await database.enum("plan_type")
            .case("basic")
            .case("premium")
            .create()
            
        let _ = try await database.enum("gender")
            .case("male")
            .case("female")
            .case("other")
            .create()
            
        let _ = try await database.enum("mood")
            .case("happy")
            .case("satisfied")
            .case("neutral")
            .case("unsatisfied")
            .case("sad")
            .case("anxious")
            .case("guilty")
            .case("frustrated")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.enum("meal_type").delete()
        try await database.enum("user_role").delete()
        try await database.enum("plan_type").delete()
        try await database.enum("gender").delete()
        try await database.enum("mood").delete()
    }
}
