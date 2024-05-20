//
//  File.swift
//  
//
//  Created by Jose Luis Escolá García on 16/5/24.
//

import Vapor

struct OptionsController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.get("help", use: showAllOptionsAvailableInWeb)
    }
    
    @Sendable func showAllOptionsAvailableInWeb(req: Request) async throws -> String {
        "GET /hello?name=NAME \nGET /hello2?name=NAME \nGET /whatsup/NAME/NUMBER \nPOST /nameQuery {name:String, email:String} \nGET /getCard?name=NAME&email=TEST_EMAIL"
    }
}
