//
//  File.swift
//  
//
//  Created by Jose Luis Escolá García on 17/5/24.
//

import Vapor
import Fluent

struct WebURLOptionsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("options")
        api.get("", use: queryWebOptions)
        api.post("create", use: createOption)
        api.get("query", use: queryFilterByType)
        api.put("updateById", use: updateWebOption)
        api.delete("deleteById", use: deleteWebOption)
    }

    func createOption(req: Request) async throws -> HTTPStatus {
        let newOption = try req.content.decode(WebURLOption.self)
        try await newOption.create(on: req.db)
        return .created
    }

    func queryWebOptions(req: Request) async throws -> [WebURLOption] {
        try await WebURLOption.query(on: req.db).all()
    }

    func queryFilterByType(req: Request) async throws -> [WebURLOption] {
        guard let type = req.query[String.self, at: "type"] else {
            throw Abort(.badRequest, reason: "No se ha indicado el tipo de petición para filtrar")
        }

        let options = try await WebURLOption.query(on: req.db)
            .filter(\.$type == type)
            .all()

        if options.isEmpty {
            throw Abort(.notFound, reason: "No existen opciones de ese tipo")
        }

        return options
    }
    
    func queryId(id: String, req: Request) async throws -> WebURLOption {
        // Validate and convert the id to UUID
        guard let uuid = UUID(uuidString: id) else {
            throw Abort(.badRequest, reason: "Invalid UUID format for id")
        }

        // Perform the query and fetch the WebURLOption
        guard let option = try await WebURLOption.query(on: req.db)
            .filter(\.$id == uuid)
            .first()
        else {
            throw Abort(.notFound, reason: "No WebURLOption found for the provided id")
        }

        // Return the found option
        return option
    }
    
    func updateWebOption(req: Request) async throws -> HTTPStatus {
        let query = try req.content.decode(WebURLOption.self)
        guard let idString = query.id?.uuidString else { return .notFound}
        let option = try await queryId(id: idString, req: req)
        
        if let type = query.type {
            option.type = type
        }
    
        option.url = query.url
        try await option.update(on: req.db)
        return .accepted
    }
    
    /// ⚠️ This is just a test with 0 sense because we are asking for a whole WebURLOption but we only use the unique id to find and delete
    func deleteWebOption(req: Request) async throws -> HTTPStatus {
        // Decode the incoming request content to WebURLOption
        let query = try req.content.decode(WebURLOption.self)
        
        // Ensure the id is present in the decoded content
        guard let idString = query.id?.uuidString else {
            return .notFound
        }
        
        // Fetch the option by id
        let option = try await queryId(id: idString, req: req)
        
        // Check if the option's id matches the query's id
        if option.id == query.id {
            // Delete the option from the database
            try await option.delete(on: req.db)
            return .accepted
        } else {
            // Throw an error if the option cannot be deleted
            throw Abort(.badRequest, reason: "No se ha podido borrar el dato")
        }
    }
}
