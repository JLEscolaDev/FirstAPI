import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(WebURLOptionsMigration())
    app.migrations.add(CreateTodo())

    // Run migrations without blocking the event loop
    Task {
        do {
            try await app.autoMigrate()
            app.logger.info("Migrations ran successfully")
        } catch {
            app.logger.error("Migrations failed: \(error.localizedDescription)")
            throw error
        }
    }

    // register routes
    try routes(app)
}
