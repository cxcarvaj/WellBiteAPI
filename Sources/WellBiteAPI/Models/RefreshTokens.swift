//
//  RefreshTokens.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent
import JWT

final class RefreshTokens: Model, Content, @unchecked Sendable {
    static let schema = "refresh_tokens"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: .userId) var user: Users
    @Field(key: .token) var token: String
    @Field(key: .expiresAt) var expiresAt: Date
    @Field(key: .isRevoked) var isRevoked: Bool
    @Timestamp(key: .createdAt, on: .create) var createdAt: Date?
    @Timestamp(key: .updatedAt, on: .update) var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, userID: Users.IDValue, token: String, expiresAt: Date, isRevoked: Bool = false) {
        self.id = id
        self.$user.id = userID
        self.token = token
        self.expiresAt = expiresAt
        self.isRevoked = isRevoked
    }
}

struct AccessTokenPayload: JWTPayload {
    // Claims estándar
    var sub: SubjectClaim //El sujeto del JWT
    var exp: ExpirationClaim
    var iss: IssuerClaim //El que lo generó
    var aud: AudienceClaim //Para quien ha sido generado
    var jti: JWKIdentifier
    
    // Claims personalizados
    var userId: UUID
    var email: String
    var role: UserRole
    
    func verify(using algorithm: some JWTAlgorithm) async throws {
        try exp.verifyNotExpired()
        try aud.verifyIntendedAudience(includes: "com.cxcarvaj.WellBite")
        if iss.value != "WellBiteAPI" {
            throw JWTError.invalidHeaderField(reason: "El issuer no es correcto")
        }
    }
}
