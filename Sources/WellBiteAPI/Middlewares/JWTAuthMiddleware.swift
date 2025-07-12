//
//  JWTAuthMiddleware.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import JWT

/// Middleware for authenticating requests using JWT access tokens.
///
/// `JWTAuthMiddleware` validates the presence and validity of a JWT access token in the Authorization header.
/// It also verifies that the token has not been revoked and loads the corresponding user into the request context.
///
/// ## Overview
///
/// This middleware performs the following steps:
/// 1. Checks for the existence of a Bearer token in the request's Authorization header.
/// 2. Decodes and verifies the JWT using the `AccessTokenPayload` structure.
/// 3. Optionally checks if the token has been revoked (extensible, e.g., with Redis).
/// 4. Looks up the user specified in the token's payload.
/// 5. Stores the user in the request's authentication context for downstream handlers.
/// 6. Passes the request further down the middleware chain.
///
/// Use this middleware to protect routes that require authenticated access via JWT tokens.
///
/// ## Example Usage
///
/// ```swift
/// let secureJWT = app.grouped(JWTAuthMiddleware())
/// secureJWT.get("protected", use: protectedEndpoint)
/// ```
struct JWTAuthMiddleware: AsyncMiddleware {
    /// Handles the incoming request, performing authentication checks and loading user context.
    ///
    /// - Parameters:
    ///   - request: The incoming HTTP request.
    ///   - next: The next responder in the middleware chain.
    /// - Throws: An `Abort(.unauthorized)` error if authentication fails at any step.
    /// - Returns: The response from the next responder if authentication succeeds.
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        // 1. Verify the existence of the token
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "Authentication token not provided")
        }
        
        // 2. Decode and verify the token
        let payload = try await request.jwt.verify(token, as: AccessTokenPayload.self)
        
        // 3. Optionally check if the token has been revoked
        if try await isTokenRevoked(payload, on: request) {
            throw Abort(.unauthorized, reason: "Token has been revoked")
        }
        
        // 4. Find and load the user (could also use sub.value)
        guard let user = try await Users.find(payload.userId, on: request.db) else {
            throw Abort(.unauthorized, reason: "User not found")
        }
        
        // 5. Store the user in the authentication context
        request.auth.login(user)
        
        // 6. Proceed with the middleware chain
        return try await next.respond(to: request)
    }
    
    /// Checks if the token has been revoked.
    ///
    /// This function can be extended to check a token revocation list or use
    /// an external system (e.g., Redis). Currently, it always returns `false`.
    ///
    /// - Parameters:
    ///   - payload: The decoded JWT payload.
    ///   - req: The incoming HTTP request.
    /// - Returns: `true` if the token is revoked; `false` otherwise.
    /// - Throws: Any error encountered during the revocation check.
    private func isTokenRevoked(_ payload: AccessTokenPayload, on req: Request) async throws -> Bool {
        // TODO: Implement Redis or other revocation logic.
        return false
    }
}
