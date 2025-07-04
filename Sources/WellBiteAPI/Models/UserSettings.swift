//
//  UserSettings.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 4/7/25.
//

import Vapor
import Fluent

final class UserSettings: Model, @unchecked Sendable {
    static let schema: String = "user_settings"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: .userId) var user: Users
    @Field(key: .showKcal) var showKcal: Bool
    @Timestamp(key: .createdAt, on: .create) var createdAt: Date?
    @Timestamp(key: .updatedAt, on: .update) var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, user: Users, showKcal: Bool = false) {
        self.id = id
        self.user = user
        self.showKcal = showKcal
    }
    
}
