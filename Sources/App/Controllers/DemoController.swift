//
//  File.swift
//  
//
//  Created by Jose Luis Escolá García on 16/5/24.
//

import Vapor

struct DemoController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("demo") /// Esto nos facilitará que todas las rutas sean /routes/lo_que_sea
        api.get("hello2", use: hello)
    }
    
    // ⚠️ Importante: Marcamos como Sendable la función por el warning que tira por no estar el get preparado para hacerlo automaticamente igual que lo hace @scaping
    @Sendable func hello(req: Request) async throws -> String {
        guard let name = req.query[String.self, at: "name"] else {
            throw Abort(.notFound, reason: "Se necesita la inclusión del parámetro name")
        }
        return "Hello, \(name)!"
    }

}
