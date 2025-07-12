//
//  APIKeyMiddleware.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 5/7/25.
//

import Vapor

/// Middleware for authenticating requests using an API key header.
///
/// `APIKeyMiddleware` checks for the presence of a valid API key in the `X-API-Key` header of incoming requests.
/// The expected API key is loaded from the environment variable `API_KEY`, allowing secure configuration
/// across different environments. If the API key is missing or incorrect, the request is rejected
/// with an unauthorized error.
///
/// ## Overview
///
/// This middleware is typically used to restrict access to certain endpoints, such as user creation,
/// so that only requests with a valid API key (e.g., from trusted apps or servers) can proceed.
///
/// ## Usage
///
/// Add the middleware to routes that require API key protection:
/// ```swift
/// app.grouped(APIKeyMiddleware()).post("api", "users", use: createUser)
/// ```
///
/// ## Security Note
///
/// - The API key should never be hardcoded in source code.
/// - Store the key securely in environment variables.
/// - Do not commit `.env` files containing real API keys to version control.
///
/// ## Example Request
///
/// ```http
/// POST /api/users HTTP/1.1
/// Host: host
/// X-API-Key: your-secure-key
/// Content-Type: application/json
/// ...
/// ```
final class APIKeyMiddleware: AsyncMiddleware {
    /// Handles the incoming request, enforcing API key authentication.
    ///
    /// - Parameters:
    ///   - request: The incoming HTTP request.
    ///   - next: The next responder in the middleware chain.
    /// - Throws: An `Abort(.unauthorized)` error if the API key header is missing or invalid.
    /// - Returns: The response from the next responder if authentication succeeds.
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        let apiKey = Environment.get("API_KEY")
        guard let header = request.headers["X-API-Key"].first,
              header == apiKey else {
            throw Abort(.unauthorized)
        }
        return try await next.respond(to: request)
    }
}
