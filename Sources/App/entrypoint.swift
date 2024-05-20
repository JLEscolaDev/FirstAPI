import Vapor
import Logging
import NIOCore
import NIOPosix

@main
enum Entrypoint {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)

        let app = Application(env)

        // Ensure not to use any async functions before setting up NIO executor
        let executorTakeoverSuccess = NIOSingletons.unsafeTryInstallSingletonPosixEventLoopGroupAsConcurrencyGlobalExecutor()
        app.logger.debug("Running with \(executorTakeoverSuccess ? "SwiftNIO" : "standard") Swift Concurrency default executor")

        do {
            try await configure(app)
            try await app.run()
        } catch {
            app.logger.report(error: error)
            try await app.asyncShutdown()
            throw error
        }
    }
}
