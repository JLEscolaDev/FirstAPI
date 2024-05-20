import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async throws -> String in
        guard let name = req.query[String.self, at: "name"] else {
            throw Abort(.notFound, reason: "Se necesita la inclusión del parámetro name")
        }
        return "Hello, \(name)!"
    }

    app.get("whatsup", ":name", ":myNumber") { req async throws -> String in
        guard let name = req.parameters.get("name") else {
            throw Abort(.notFound, reason: "La url debe tener también tu /nombre")
        }

        guard let number = req.parameters.get("myNumber", as: Int.self) else {
            throw Abort(.notFound, reason: "La url debe también un /número_entero")
        }
        return "Te llamas \(name) y tu número es el \(number)"
    }

    app.post("nameQuery") { req async throws -> String in
        let test = try req.content.decode(TestData.self)
        return "Eres \(test.name) con el email: \(test.email)"
    }

    app.get("getCard") { req async throws -> TestData in
        guard let name = req.query[String.self, at: "name"],
              let email = req.query[String.self, at: "email"]
        else {
            throw Abort(.notFound, reason: "Te has dejado algún parámetro")
        }
        return TestData(name: name, email: email)
    }

    try app.register(collection: TodoController())
    try app.register(collection: DemoController())
    try app.register(collection: OptionsController())
    try app.register(collection: WebURLOptionsController())
}
