//
//  CreateDailyTrackingsDTO.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 29/6/25.
//

import Vapor
import Fluent

struct CreateDailyTrackingsDTO: Content {
    var userId: UUID
    var totalKcalGoal: Int?
    var totalKcalConsumed: Int?
    var waterGoalml: Int
    var waterIntakeml: Int
    var mealsCompleted: Int
    var emotionSummary: String?
}
