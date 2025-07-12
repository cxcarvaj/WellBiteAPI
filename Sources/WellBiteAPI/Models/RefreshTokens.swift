//
//  RefreshTokens.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent
import JWT

/// A model representing refresh tokens for user authentication.
///
/// `RefreshTokens` stores long-lived tokens that can be used to obtain new access tokens
/// without requiring users to re-authenticate with their credentials. Each refresh token
/// is associated with a specific user, has an expiration date, and can be revoked.
///
/// ## Overview
///
/// Refresh tokens are an important part of the authentication system that:
/// - Allow users to maintain sessions across multiple app launches
/// - Enable secure token refresh without re-entering credentials
/// - Can be revoked individually for security purposes
/// - Have configurable expiration periods
///
/// The model tracks when tokens are created, updated, and whether they have been revoked.
/// It also provides methods to check token validity based on expiration and revocation status.
final class RefreshTokens: Model, Content, @unchecked Sendable {
    /// The database schema name for refresh tokens.
    static let schema = "refresh_tokens"
    
    /// The unique identifier for the refresh token.
    @ID(key: .id) var id: UUID?
    
    /// The user this refresh token belongs to.
    ///
    /// This relationship connects the token to its owner, allowing the system to
    /// identify which user is requesting a new access token.
    @Parent(key: .userId) var user: Users
    
    /// The token string used for authentication.
    ///
    /// This value is typically a cryptographically secure random string that
    /// is provided to clients and must be presented to obtain new access tokens.
    @Field(key: .token) var token: String
    
    /// The date and time when this token expires.
    ///
    /// After this time, the token can no longer be used to obtain new access tokens,
    /// and the user will need to authenticate again with their credentials.
    @Field(key: .expiresAt) var expiresAt: Date
    
    /// Indicates whether this token has been manually revoked.
    ///
    /// Tokens can be revoked before their expiration time, typically when a user
    /// logs out or when a security breach is suspected.
    @Field(key: .isRevoked) var isRevoked: Bool
    
    /// The date and time when this token was created.
    @Timestamp(key: .createdAt, on: .create) var createdAt: Date?
    
    /// The date and time when this token was last updated.
    @Timestamp(key: .updatedAt, on: .update) var updatedAt: Date?
    
    /// Creates an empty instance, required by Fluent.
    init() {}
    
    /// Creates a new refresh token with the specified attributes.
    ///
    /// - Parameters:
    ///   - id: Optional unique identifier for the token. If nil, an ID will be generated.
    ///   - userID: The ID of the user this token belongs to.
    ///   - token: The token string used for authentication.
    ///   - expiresAt: The date and time when this token expires.
    ///   - isRevoked: Whether this token is initially revoked. Defaults to false.
    init(id: UUID? = nil, userID: Users.IDValue, token: String, expiresAt: Date, isRevoked: Bool = false) {
        self.id = id
        self.$user.id = userID
        self.token = token
        self.expiresAt = expiresAt
        self.isRevoked = isRevoked
    }
}

/// A payload for JWT access tokens.
///
/// `AccessTokenPayload` defines the structure and validation rules for JWT access tokens
/// in the application. It contains both standard JWT claims and application-specific claims
/// that identify the user and their role.
///
/// ## Overview
///
/// The payload includes:
/// - Standard JWT claims (subject, expiration, issuer, audience, JWT ID)
/// - User-specific information (ID, email, role)
///
/// It also implements verification logic to ensure tokens are valid, not expired,
/// and intended for this application.
struct AccessTokenPayload: JWTPayload {
    // MARK: - Standard Claims
    
    /// The subject of the JWT, identifying who the token represents.
    var sub: SubjectClaim
    
    /// The expiration time claim, indicating when the token becomes invalid.
    var exp: ExpirationClaim
    
    /// The issuer claim, identifying who generated the token.
    var iss: IssuerClaim
    
    /// The audience claim, identifying the intended recipients of the token.
    var aud: AudienceClaim
    
    /// A unique identifier for this specific JWT.
    var jti: JWKIdentifier
    
    // MARK: - Custom Claims
    
    /// The unique identifier of the user this token represents.
    var userId: UUID
    
    /// The email address of the user.
    var email: String
    
    /// The role of the user in the system.
    var role: Role
    
    /// Verifies that the token meets all validation requirements.
    ///
    /// This method checks that:
    /// - The token has not expired
    /// - The token is intended for this application
    /// - The token was issued by the correct issuer
    ///
    /// - Parameter algorithm: The JWT algorithm used to verify the token.
    /// - Throws: A `JWTError` if any validation check fails.
    func verify(using algorithm: some JWTAlgorithm) async throws {
        try exp.verifyNotExpired()
        try aud.verifyIntendedAudience(includes: "com.cxcarvaj.WellBite")
        if iss.value != "WellBiteAPI" {
            throw JWTError.invalidHeaderField(reason: "El issuer no es correcto")
        }
    }
}

// MARK: - Authentication
extension RefreshTokens: ModelTokenAuthenticatable {
    /// Defines which property contains the token value.
    ///
    /// This key path tells the authentication system which field
    /// contains the actual token string to validate.
    static var valueKey: KeyPath<RefreshTokens, Field<String>> { \.$token }
    
    /// Defines the relationship to the user model.
    ///
    /// This key path tells the authentication system how to find the user
    /// associated with this token.
    static var userKey: KeyPath<RefreshTokens, Parent<Users>> { \.$user }
    
    /// Determines if this token is currently valid.
    ///
    /// A token is valid if it has not been revoked and has not expired.
    /// This property is used by the authentication system to determine if
    /// the token can be used to authenticate requests.
    var isValid: Bool {
        !isRevoked && expiresAt > Date()
    }
}
