//
//  AuthController.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 5/7/25.
//

import Vapor
import Fluent

/// A controller that handles authentication-related routes and operations.
///
/// `AuthController` manages user authentication workflows including login, logout, and token refresh.
/// It uses the `TokenService` to generate and manage authentication tokens and sets up the necessary
/// route endpoints with appropriate authentication middleware.
///
/// ## Overview
///
/// This controller provides the following authentication endpoints:
///
/// - **Login**: Authenticates users with email and password, returning access and refresh tokens
/// - **Logout**: Revokes a user's refresh token
/// - **Refresh**: Issues a new access token using a valid refresh token
/// - **Test Connection**: A simple endpoint for testing authenticated connections
///
/// The controller uses various authentication middlewares to protect routes:
/// - Basic username/password authentication for login
/// - JWT authentication for protected API routes
/// - Token authentication for refresh operations
struct AuthController: RouteCollection {
    /// The token service used for generating and managing authentication tokens.
    let tokenService = TokenService()
    
    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("api")
        let authRoutes = api.grouped("auth")

        let secureUserPass = authRoutes.grouped(Users.authenticator(), Users.guardMiddleware())
        secureUserPass.post("login", use: login)
        
        let secureJWT = authRoutes.grouped(
            JWTAuthMiddleware(),
            Users.guardMiddleware(),
        )
        
        secureJWT.get("logout", use: logout)
        secureJWT.post("refresh", use: refresh)
    }
    
    /// Authenticates a user and issues access and refresh tokens.
    ///
    /// This endpoint authenticates a user with email and password credentials. If authentication
    /// is successful, it generates both an access token (JWT) and a refresh token for the user.
    ///
    /// - Parameter req: The incoming HTTP request containing login credentials.
    /// - Returns: A `LoginResponse` containing user information, tokens, and expiration time.
    /// - Throws:
    ///   - `Abort(.unauthorized)`: If the provided credentials are invalid.
    ///   - Other errors that may occur during token generation or database operations.
    func login(_ req: Request) async throws -> LoginResponse {
        let user = try req.auth.require(Users.self)
        guard user.role != .none else { throw Abort(.unauthorized) }

        let (accessToken, refreshToken) = try await tokenService.generateTokens(for: user, on: req.db)
        
        let accessTokenSigned = try await req.jwt.sign(accessToken)

        return LoginResponse(
            user: user.toResponse(),
            accessToken: accessTokenSigned,
            refreshToken: refreshToken.token,
            expiresAt: Date().addingTimeInterval(60 * 60) // 1 hour
        )
    }
    
    /// Issues a new access token using a valid refresh token.
    ///
    /// This endpoint verifies the provided refresh token and, if valid, generates
    /// a new access token for the user.
    ///
    /// - Parameter req: The incoming HTTP request containing the refresh token.
    /// - Returns: A `RefreshResponse` containing the new access token and its expiration time.
    /// - Throws:
    ///   - Errors from token verification if the refresh token is invalid or expired.
    ///   - Other errors that may occur during token generation.
    func refresh(_ req: Request) async throws -> RefreshResponse {
        let user = try req.auth.require(Users.self)
        guard user.role != .none else { throw Abort(.unauthorized) }
        
        let refreshRequest = try req.content.decode(RefreshRequest.self)
        let (_, userFromToken) = try await tokenService.verifyRefreshToken(refreshRequest.refreshToken, on: req.db)
        
        let accessToken = try tokenService.generateAccessToken(for: userFromToken)
        
        let accessTokenSigned = try await req.jwt.sign(accessToken)
        
        return RefreshResponse(
            accessToken: accessTokenSigned,
            expiresAt: Date().addingTimeInterval(60 * 60)
        )
    }
    
    /// Revokes a refresh token, effectively logging out the user.
    ///
    /// This endpoint invalidates a refresh token by marking it as revoked in the database,
    /// which prevents it from being used for future authentication.
    ///
    /// - Parameter req: The incoming HTTP request containing the refresh token to revoke.
    /// - Returns: An HTTP status code indicating success.
    /// - Throws: Errors that may occur during token revocation or database operations.
    func logout(_ req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(Users.self)
        guard user.role != .none else { throw Abort(.unauthorized) }

        let logoutRequest = try req.content.decode(LogoutRequest.self)
        try await tokenService
            .revokeRefreshToken(logoutRequest.refreshToken, on: req.db)
        return .ok
    }
}
