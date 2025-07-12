//
//  Users.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//

import Vapor
import Fluent

/// A user model representing individuals in the system.
///
/// `Users` represents registered users in the application with their personal information,
/// authentication credentials, and relationships to other entities. This model supports various
/// user roles and maintains connections to user-specific data like nutrition plans and tracking entries.
///
/// ## Overview
///
/// The `Users` model stores essential user information such as:
/// - Personal details (name, email, birthday, gender)
/// - Authentication information (password)
/// - Role-based access control information
/// - Profile customization (avatar)
///
/// It also defines relationships with other entities in the system, both as a regular user
/// and, when applicable, as a professional user who can create content for others.
///
/// ## Relationships
///
/// A user can have many:
/// - Refresh tokens for authentication
/// - User settings for application preferences
/// - Nutrition plans assigned to them
/// - Daily tracking records
/// - Meal entries
/// - Emotional entries
///
/// Additionally, professional users can create:
/// - Nutrition plans for their clients
///
/// ## Authentication
///
/// This model conforms to `ModelAuthenticatable` to support Vapor's authentication system,
/// allowing users to log in with email and password.
final class Users: Model, @unchecked Sendable {
    /// The database schema for the users table.
    static let schema: String = "users"
    
    /// The unique identifier for the user.
    @ID(key: .id) var id: UUID?
    
    /// The user's email address, used as the username for authentication.
    ///
    /// This field should contain a valid email address and must be unique across all users.
    @Field(key: .email) var email: String
    
    /// The user's password, stored as a bcrypt hash.
    ///
    /// This field should never contain plaintext passwords and is used for authentication.
    @Field(key: .password) var password: String
    
    /// The user's first name.
    @Field(key: .firstName) var firstName: String
    
    /// The user's last name.
    @Field(key: .lastName) var lastName: String
    
    /// The user's role in the system.
    ///
    /// Determines the user's permissions and access levels within the application.
    @Enum(key: .role) var role: Role
    
    /// The user's date of birth.
    ///
    /// Used for age calculation and personalized health recommendations.
    @Field(key: .birthday) var birthday: Date
    
    /// The user's gender.
    ///
    /// Used for personalized health recommendations and analytics.
    @Enum(key: .gender) var gender: Gender
    
    /// Optional URL or reference to the user's profile picture.
    @Field(key: .avatar) var avatar: String?
    
    /// Timestamp recording when the user record was created.
    @Timestamp(key: .createdAt, on: .create) var createdAt: Date?
    
    /// Timestamp recording when the user record was last updated.
    @Timestamp(key: .updatedAt, on: .update) var updatedAt: Date?
    
    // MARK: - Relationships
    
    /// Refresh tokens associated with this user's authentication sessions.
    @Children(for: \.$user) var refreshTokens: [RefreshTokens]
    
    /// User-specific application settings and preferences.
    @Children(for: \.$user) var userSettings: [UserSettings]
    
    /// Nutrition plans assigned to this user.
    @Children(for: \.$user) var nutritionPlans: [NutritionPlans]
    
    /// Daily tracking records for monitoring the user's progress.
    @Children(for: \.$user) var dailyTrackings: [DailyTrackings]
    
    /// Meal entries recorded by the user.
    @Children(for: \.$user) var mealEntries: [MealEntries]
    
    /// Emotional state entries recorded by the user.
    @Children(for: \.$user) var emotionalEntries: [EmotionalEntries]
    
    // MARK: - Professional Relationships
    
    /// Nutrition plans created by this user for their clients (when user is a professional).
    @Children(for: \.$professional) var createdNutritionPlans: [NutritionPlans]
    
    /// Creates an empty instance, required by Fluent.
    init() {}
    
    /// Creates a new user with the specified attributes.
    ///
    /// - Parameters:
    ///   - id: Optional unique identifier for the user. If nil, an ID will be generated.
    ///   - email: The user's email address, used for authentication.
    ///   - password: The user's password (should be already hashed).
    ///   - firstName: The user's first name.
    ///   - lastName: The user's last name.
    ///   - role: The user's role in the system.
    ///   - birthday: The user's date of birth.
    ///   - gender: The user's gender.
    ///   - avatar: Optional URL or reference to the user's profile picture.
    init(id: UUID? = nil,
         email: String,
         password: String,
         firstName: String,
         lastName: String,
         role: Role,
         birthday: Date,
         gender: Gender,
         avatar: String? = nil,
    ) {
        self.id = id
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.birthday = birthday
        self.gender = gender
        self.avatar = avatar
    }
}

// MARK: - Authentication
extension Users: ModelAuthenticatable {
    /// The key path to the property that contains the username (email).
    static var usernameKey: KeyPath<Users, Field<String>> { \.$email }
    
    /// The key path to the property that contains the hashed password.
    static var passwordHashKey: KeyPath<Users, Field<String>> { \.$password }
    
    /// Verifies that the provided password matches the stored hash.
    ///
    /// This method uses Bcrypt to compare the provided plaintext password with
    /// the hashed password stored in the database.
    ///
    /// - Parameter password: The plaintext password to verify.
    /// - Returns: True if the password matches, false otherwise.
    /// - Throws: An error if the verification process fails.
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

// MARK: - Data Transfer
extension Users {
    /// Converts the user model to a data transfer object (DTO).
    ///
    /// Creates a UserDTO instance from this user model, omitting the password for security.
    /// This method is typically used when preparing user data for form editing.
    ///
    /// - Returns: A UserDTO containing the user's information.
    func toDTO() -> UserDTO {
        return UserDTO(
            email: self.email,
            password: "",
            firstName: self.firstName,
            lastName: self.lastName,
            role: self.role,
            birthday: self.birthday,
            gender: self.gender,
            avatar: self.avatar
        )
    }
    
    /// Converts the user model to a response object.
    ///
    /// Creates a UserResponse instance containing only the essential user information
    /// that is safe to send to clients. This method is typically used when responding
    /// to API requests.
    ///
    /// - Returns: A UserResponse containing the user's essential information.
    func toResponse() -> UserResponse {
        return UserResponse(
            id: self.id!,
            email: self.email,
            fullName: "\(self.firstName) \(self.lastName)",
            role: self.role
        )
    }
}
