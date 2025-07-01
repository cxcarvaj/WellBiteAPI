//
//  RemoveSharedEnumsMigration.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

struct RemoveSharedEnumsMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
    }
    
    func revert(on database: any Database) async throws {
        try await database.enum("meal_type").delete()
    }
}
