//
//  CreateEmotionalEntries.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class CreateEmotionalEntries: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let moodEnum = try await database.enum("mood").read()
        
        try await database.schema(EmotionalEntries.schema)
            .id()
            .field(.userId, .uuid, .required, .references(Users.schema, .id, onDelete: .cascade))
            .field(.mealEntryId, .uuid, .required, .references(MealEntries.schema, .id, onDelete: .cascade))
            .field(.mood, moodEnum, .required)
            .field(.description, .string)
            .field(.createdAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(EmotionalEntries.schema).delete()
    }
}
