//
//  SharedEnumsMigration.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

struct SharedEnumsMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let _ = try await database.enum("meal_type")
            .case("breakfast")
            .case("lunch")
            .case("dinner")
            .case("snack")
            .create()
    }
    
    func revert(on database: any Database) async throws {
    }
}
