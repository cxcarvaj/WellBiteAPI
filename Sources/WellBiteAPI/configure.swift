import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.passwords.use(.bcrypt)
    
    switch app.environment {
        case .testing:
            app.passwords.use(.plaintext)
        default: break
    }

    guard let hostname = Environment.get("DB_HOST"),
          let portString = Environment.get("DB_PORT"),
          let username = Environment.get("DB_USERNAME"),
          let password = Environment.get("DB_PASSWORD"),
          let database = Environment.get("DB_DATABASE"),
          let port = Int(portString) else {
        fatalError("⛔️ Error crítico: No se pudieron obtener todas las variables de entorno necesarias para PostgreSQL. Asegúrate de configurar DB_HOST, DB_PORT, DB_USERNAME, DB_PASSWORD y DB_DATABASE en tu archivo .env")
    }
    
    let psqlConfig = SQLPostgresConfiguration(
        hostname: hostname,
        port: port,
        username: username,
        password: password,
        database: database,
        tls: .disable
    )
    
    app.databases.use(.postgres(configuration: psqlConfig), as: .psql)
    print("💾 PostgreSQL configurado correctamente con host: \(hostname), base de datos: \(database)")

    app.migrations.add(CreateSharedEnums())

    // Users and autenticación
    app.migrations.add(CreateUsers())
    app.migrations.add(CreateRefreshTokens())
    app.migrations.add(CreateUserSettings())
//    app.migrations.add(SubscriptionsMigration())

    // Planes nutricionales
    app.migrations.add(CreateNutritionPlans())
    app.migrations.add(CreateNutritionPlanItems())

    // Seguimiento diario
    app.migrations.add(CreateDailyTrackings())
    app.migrations.add(CreateWaterIntakeEntries())
    app.migrations.add(CreateDailyMealTrackings())
    app.migrations.add(CreateMealEntries())
    app.migrations.add(CreateEmotionalEntries())

    // Notas profesionales
//    app.migrations.add(ProfessionalNotesMigration())

    app.views.use(.leaf)

    // register routes
    try routes(app)
}
