//
//  FieldKeys.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 28/6/25.
//

import Vapor
import Fluent

extension FieldKey {
    //Common fields
    static let userId = FieldKey("user_id")
    static let dailyTrackingId = FieldKey("daily_tracking_id")
    static let mealEntryId = FieldKey("meal_entry_id")
    static let description = FieldKey("description")
    static let mood = FieldKey("mood")
    static let mealType = FieldKey("meal_type")
    static let endDate = FieldKey("end_date")
    static let createdAt = FieldKey("created_at")
    static let updatedAt = FieldKey("updated_at")
    
    //Table Users fields
    static let firstName = FieldKey("first_name")
    static let lastName = FieldKey("last_name")
    static let userName = FieldKey("user_name")
    static let email = FieldKey("email")
    static let password = FieldKey("password")
    static let userRole = FieldKey("user_role")
    static let birthday = FieldKey("birth_date")
    static let gender = FieldKey("gender")
    static let avatar = FieldKey("avatar")
    static let showKcal = FieldKey("show_kcal")
    
    //Table Refresh Tokens fields
    static let token = FieldKey("token")
    static let expiresAt = FieldKey("expires_at")
    static let isRevoked = FieldKey("is_revoked")
    
    //Table Emotional Entries fields
    static let mealId = FieldKey("meal_id")
    
    //Table Nutrition Plans fields
    static let professionalId = FieldKey("professional_id")
    static let title = FieldKey("title")
    static let startDate = FieldKey("start_date")
    
    //Table Nutrition Plan Items fields
    static let nutritionPlanId = FieldKey("nutrition_plan_id")
    static let nutritionPlanItemId = FieldKey("nutrition_plan_item_id")
    static let dayOfWeek = FieldKey("day_of_week")
    static let imageUrl = FieldKey("image_url")
    static let kcalTarget = FieldKey("kcal_target")
    
    //Table Daily Tracking fields
    static let date = FieldKey("date")
    static let totalKcalGoal = FieldKey("total_kcal_goal")
    static let totalKcalConsumed = FieldKey("total_kcal_consumed")
    static let waterGoalMl = FieldKey("water_goal_ml")
    static let waterIntakeMl = FieldKey("water_intake_ml")
    static let mealsCompleted = FieldKey("meals_completed")
    static let emotionSummary = FieldKey("emotion_summary")
    
    //Table Water Intake Entry fields
    static let amountMl = FieldKey("amount_ml")
    static let timestamp = FieldKey("timestamp")
    
    //Table Daily Meal Tracking fields
    static let dailyMealTrackingId = FieldKey("daily_meal_tracking_id")
    static let isCompleted = FieldKey("is_completed")
    static let kcalEstimate = FieldKey("kcal_estimate")
    static let plannedKcal = FieldKey("planned_kcal")
    
    //Table Meal Entries fields
    static let photoUrl = FieldKey("photo_url")
    static let mealTime = FieldKey("meal_time")
    static let notes = FieldKey("notes")
    static let aiKcalEstimate = FieldKey("ai_kcal_estimate")
    static let aiMacrosEstimate = FieldKey("ai_macros_estimate")

}
