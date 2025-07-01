//
//  CreateUserDTO.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//


struct CreateUserDTO: Content {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var role: UserType
    var birthday: Date
    var gender: Gender
    var avatar: String?
    var showKcal: Bool?
    
    // Validaciones
    var validations: [ValidationsBuilder.Result] {
        [
            Validator<String>.email.validate(email),
            Validator<String>.count(8...).validate(password)
        ]
    }
}