//
//  EmotionalEntriesMigration.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

struct EmotionalEntriesMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let mood = try await database.enum("mood")
            .case("happy")
            .case("satisfied")
            .case("neutral")
            .case("unsatisfied")
            .case("sad")
            .case("anxious")
            .case("guilty")
            .case("frustrated")
            .create()
        
        try await database.schema(EmotionalEntries.schema)
            .id()
            .field(.userId, .uuid, .required, .references(Users.schema, .id, onDelete: .cascade))
            .field(.mealEntryId, .uuid, .references(MealEntries.schema, .id, onDelete: .cascade))
            .field(.mood, mood, .required)
            .field(.description, .string)
            .field(.createdAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(EmotionalEntries.schema).delete()
        try await database.enum("mood").delete()
    }
}
