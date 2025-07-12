//
//  UserDTO.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//

import Vapor
import Fluent

/// A data transfer object for user information.
///
/// `UserDTO` is used to transfer user data between different parts of the application,
/// particularly for creating new users or updating existing user information. It contains
/// all the essential user fields and supports validation to ensure data integrity.
///
/// ## Overview
///
/// This DTO includes:
/// - Basic personal information (email, name, gender)
/// - Authentication information (password)
/// - Role and profile information
/// - Birth date for age-related features
///
/// The struct conforms to `Content` for easy encoding/decoding in HTTP requests and
/// `Validatable` to ensure data meets requirements before processing.
///
/// ## Example Usage
///
/// ```swift
/// // Creating a UserDTO from request content
/// let userDTO = try req.content.decode(UserDTO.self)
///
/// // Validating the DTO
/// try userDTO.validate()
///
/// // Using the DTO to create or update a user
/// let user = Users(
///     email: userDTO.email,
///     password: try Bcrypt.hash(userDTO.password),
///     firstName: userDTO.firstName,
///     lastName: userDTO.lastName,
///     role: userDTO.role,
///     birthday: userDTO.birthday,
///     gender: userDTO.gender,
///     avatar: userDTO.avatar
/// )
/// ```
struct UserDTO: Content {
    /// The user's email address, used for authentication and communication.
    ///
    /// This field must contain a valid email format and should be unique across all users.
    var email: String
    
    /// The user's password in plain text form.
    ///
    /// This field is used during user creation or password changes. The password should be
    /// hashed before storage in the database. The minimum length is 8 characters.
    var password: String
    
    /// The user's first name.
    ///
    /// Cannot be empty.
    var firstName: String
    
    /// The user's last name.
    ///
    /// Cannot be empty.
    var lastName: String
    
    /// The user's role in the system.
    ///
    /// Determines the user's permissions and access levels within the application.
    var role: Role
    
    /// The user's date of birth.
    ///
    /// Used for age calculation and personalized recommendations.
    /// Must be a valid date in the past.
    var birthday: Date
    
    /// The user's gender.
    ///
    /// Used for personalized recommendations and analytics.
    var gender: Gender
    
    /// Optional URL or reference to the user's profile picture.
    ///
    /// This field is optional and can be nil if the user doesn't have a profile picture.
    var avatar: String?
}

// MARK: - Validation
extension UserDTO: Validatable {
    /// Defines validation rules for UserDTO properties.
    ///
    /// This method sets up the following validations:
    /// - Email must have a valid format
    /// - Password must be at least 8 characters long
    /// - First and last names cannot be empty
    /// - Birthday must be a valid date
    ///
    /// These validations are automatically applied when calling `validate()`
    /// on a UserDTO instance.
    ///
    /// - Parameter validations: The validations collection to add rules to.
    static func validations(_ validations: inout Validations) {
        // Email validation
        validations.add("email", as: String.self, is: .email)
        
        // Password validation (minimum 8 characters)
        validations.add("password", as: String.self, is: .count(8...))
        
        // First and last name validations (non-empty)
        validations.add("firstName", as: String.self, is: !.empty)
        validations.add("lastName", as: String.self, is: !.empty)
        
        // Birthday validation
        validations.add("birthday", as: Date.self, is: .valid)
    }
}
