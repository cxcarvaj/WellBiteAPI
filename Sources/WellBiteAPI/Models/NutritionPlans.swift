//
//  NutritionPlans.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//

import Vapor
import Fluent

final class NutritionPlans: Model, @unchecked Sendable {
    static let schema: String = "nutrition_plans"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: .userId) var user: Users
    @Parent(key: .professionalId) var professional: Users
    
    @Field(key: .title) var title: String
    @Field(key: .startDate) var startDate: Date
    @Field(key: .endDate) var endDate: Date
    
    @Timestamp(key: .createdAt, on: .create) var createdAt: Date?
    
    // Relationships
    @Children(for: \.$nutritionPlan) var nutritionPlanItems: [NutritionPlanItems]
    
    init() {}
    
    init(id: UUID? = nil,
         user: Users.IDValue,
         professional: Users.IDValue,
         title: String,
         startDate: Date,
         endDate: Date
    ) {
        self.id = id
        self.$user.id = user
        self.$professional.id = professional
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }


}
