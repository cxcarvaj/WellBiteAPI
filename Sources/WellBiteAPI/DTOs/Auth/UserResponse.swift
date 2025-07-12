//
//  UserResponse.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 5/7/25.
//

import Vapor

/// This DTO contains the basic information of the logged-in user.
struct UserResponse: Content {
    let id: UUID
    let email: String
    let fullName: String
    let role: Role
}
