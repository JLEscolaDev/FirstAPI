//
//  File.swift
//  
//
//  Created by Jose Luis Escolá García on 17/5/24.
//

import Vapor
import Fluent

struct WebURLOptionsMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(WebURLOption.schema)
            .id()
            .field(WebURLOption.FieldNames.type, .string, .required)
            .field(WebURLOption.FieldNames.url, .string, .required)
            .unique(on: WebURLOption.FieldNames.url)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(WebURLOption.schema).delete()
    }
}
