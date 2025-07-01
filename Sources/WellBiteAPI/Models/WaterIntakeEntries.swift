//
//  WaterIntakeEntry.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 30/6/25.
//

import Vapor
import Fluent

final class WaterIntakeEntries: Model, @unchecked Sendable {
    static let schema: String = "water_intake_entries"

    @ID(key: .id) var id: UUID?
    @Parent(key: .dailyTrackingId) var dailyTracking: DailyTrackings
    
    @Field(key: .amountMl) var amountMl: Int
    @Field(key: .timestamp) var timestamp: Date
    
    init() {}
    
    init(
        id: UUID? = nil,
        dailyTrackingId: DailyTrackings.IDValue,
        amountMl: Int,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.$dailyTracking.id = dailyTrackingId
        self.amountMl = amountMl
        self.timestamp = timestamp
    }
}
