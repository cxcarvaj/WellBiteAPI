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
    @Enum(key: .userRole) var userRole: UserRole
    @Field(key: .birthday) var birthday: Date
    @Enum(key: .gender) var gender: Gender
    @Field(key: .avatar) var avatar: String?
    @Timestamp(key: .createdAt, on: .create) var createdAt: Date?
    @Timestamp(key: .updatedAt, on: .update) var updatedAt: Date?
    
    // Relationships
    @Children(for: \.$user) var refreshTokens: [RefreshTokens]
    @Children(for: \.$user) var userSettings: [UserSettings]
//    @Children(for: \.$user) var subscriptions: [Subscriptions]
    @Children(for: \.$user) var nutritionPlans: [NutritionPlans]
    @Children(for: \.$user) var dailyTrackings: [DailyTrackings]
    @Children(for: \.$user) var mealEntries: [MealEntries]
    @Children(for: \.$user) var emotionalEntries: [EmotionalEntries]
    
    // Relationships as profesional
//    @Children(for: \.$professional) var professionalNotes: [ProfessionalNotes]
    @Children(for: \.$professional) var createdNutritionPlans: [NutritionPlans]
    
    init() {}
    
    init(id: UUID? = nil,
         email: String,
         password: String,
         firstName: String,
         lastName: String,
         userRole: UserRole,
         birthday: Date,
         gender: Gender,
         avatar: String? = nil,
    ) {
        self.id = id
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.userRole = userRole
        self.birthday = birthday
        self.gender = gender
        self.avatar = avatar
    }
    
}

extension Users: ModelAuthenticatable {
    static var usernameKey: KeyPath<Users, Field<String>> { \.$email }
    static var passwordHashKey: KeyPath<Users, Field<String>> { \.$password }
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
