//
//  UsersController.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//

import Vapor
import Fluent

/// Controller for managing user-related API endpoints.
///
/// `UsersController` defines the routes and request handlers for operations involving users,
/// such as creating new user accounts. It applies the `APIKeyMiddleware` to protect the user creation endpoint,
/// ensuring only authorized clients (e.g., trusted apps or backend services) can create users.
///
/// ## Security
///
/// - The `POST /api/users` endpoint requires a valid API key in the `X-API-Key` header.
/// - The controller checks for duplicate emails to prevent duplicate user accounts.
/// - Passwords are hashed before storage.
///
/// ## Error Handling
///
/// - Returns `400 Bad Request` if the email is already registered.
/// - Returns `401 Unauthorized` if the API key is missing or invalid.
///
/// ## Example Request
///
/// ```http
/// POST /api/users HTTP/1.1
/// Host: host
/// X-API-Key: your-secure-key
/// Content-Type: application/json
///
/// {
///     "email": "newuser@example.com",
///     "password": "securePassword123",
///     "firstName": "FirstName",
///     "lastName": "LastName",
///     "role": "user",
///     "birthday": "1990-01-01",
///     "gender": "male",
///     "avatar": null
/// }
/// ```
struct UsersController: RouteCollection {
    /// Registers user-related routes with the provided routes builder.
    ///
    /// - Parameter routes: The application's routes builder.
    /// - Throws: Any error encountered during route registration.
    func boot(routes: any RoutesBuilder) throws {
        let userRoutes = routes.grouped("api", "users")
        let apiKeyMiddleware = userRoutes.grouped(APIKeyMiddleware())

        // Register POST /api/users route with API key protection
        apiKeyMiddleware.post(use: create)
    }
    
    /// Handles user creation requests.
    ///
    /// - Parameter req: The incoming HTTP request.
    /// - Throws: `Abort(.badRequest)` if the email is already registered.
    /// - Returns: `HTTPStatus.created` if the user was created successfully.
    func create(_ req: Request) async throws -> HTTPStatus {
        // Decode the request body into a UserDTO
        let userDTO = try req.content.decode(UserDTO.self)

        // Check for duplicate email
        if let _ = try await Users.query(on: req.db)
            .filter(\.$email == userDTO.email)
            .first() {
            throw Abort(.badRequest, reason: "Email already exists")
        }

        // Hash the user's password
        let hashedPassword = try req.password.hash(userDTO.password)

        // Create a new Users model instance
        let newUser = Users(
            email: userDTO.email,
            password: hashedPassword,
            firstName: userDTO.firstName,
            lastName: userDTO.lastName,
            role: userDTO.role,
            birthday: userDTO.birthday,
            gender: userDTO.gender,
            avatar: userDTO.avatar
        )

        // Save the user to the database
        try await newUser.create(on: req.db)
        return .created
    }
}
