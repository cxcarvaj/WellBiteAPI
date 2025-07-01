//
//  Users.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//

import Vapor
import Fluent

final class Users: Model, @unchecked Sendable {
    static let schema: String = "users"
    
    @ID(key: .id) var id: UUID?
    @Field(key: .email) var email: String
    @Field(key: .password) var password: String
    @Field(key: .firstName) var firstName: String
    @Field(key: .lastName) var lastName: String
    @Enum(key: .role) var role: Role
    @Field(key: .birthday) var birthday: Date
    @Enum(key: .gender) var gender: Gender
    @Field(key: .avatar) var avatar: String?
    @Field(key: .showKcal) var showKcal: Bool
    @Timestamp(key: .createdAt, on: .create) var createdAt: Date?
    @Timestamp(key: .updatedAt, on: .update) var updatedAt: Date?
    
    @Children(for: \.$user) var dailyTrackings: [DailyTrackings]
    
    init() {}
    
    init(id: UUID? = nil,
         email: String,
         password: String,
         firstName: String,
         lastName: String,
         role: Role,
         birthday: Date,
         gender: Gender,
         avatar: String? = nil,
         showKcal: Bool = false)
    {
        self.id = id
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.birthday = birthday
        self.gender = gender
        self.avatar = avatar
        self.showKcal = showKcal
    }
    
}

extension Users: ModelAuthenticatable {
    static var usernameKey: KeyPath<Users, Field<String>> { \.$email }
    static var passwordHashKey: KeyPath<Users, Field<String>> { \.$password }
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
