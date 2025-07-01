//
//  DailyTrackings.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//

import Vapor
import Fluent

final class DailyTrackings: Model, @unchecked Sendable {
    static let schema: String = "daily_trackings"

    @ID(key: .id) var id: UUID?
    @Parent(key: .userId) var user: Users
    
    @Field(key: .date) var date: Date
    @Field(key: .totalKcalGoal) var totalKcalGoal: Int?
    @Field(key: .totalKcalConsumed) var totalKcalConsumed: Int
    @Field(key: .waterGoalml) var waterGoalml: Int
    @Field(key: .waterIntakeml) var waterIntakeml: Int
    @Field(key: .mealsCompleted) var mealsCompleted: Int
    @Field(key: .emotionSummary) var emotionSummary: String?
    @Timestamp(key: .createdAt, on: .create) var createdAt: Date?
    
    // Relationships
    @Children(for: \.$dailyTracking) var waterIntakes: [WaterIntakeEntries]
    @Children(for: \.$dailyTracking) var meals: [DailyMealTrackings]
    
    init() {}
    
    init(
        id: UUID? = nil,
        userId: Users.IDValue,
        date: Date = Calendar.current.startOfDay(for: .now),
        totalKcalGoal: Int? = nil,
        totalKcalConsumed: Int = 0,
        waterGoalml: Int = 2500,
        waterIntakeml: Int = 0,
        mealsCompleted: Int = 0,
        emotionSummary: String? = nil
    ) {
        self.id = id
        self.$user.id = userId
        self.date = date
        self.totalKcalGoal = totalKcalGoal
        self.totalKcalConsumed = totalKcalConsumed
        self.waterGoalml = waterGoalml
        self.waterIntakeml = waterIntakeml
        self.mealsCompleted = mealsCompleted
        self.emotionSummary = emotionSummary
    }
}
