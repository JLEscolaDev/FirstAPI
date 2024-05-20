//
//  File.swift
//  
//
//  Created by Jose Luis Escolá García on 17/5/24.
//
import Vapor
import Fluent

enum RestAPICallType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension WebURLOption: @unchecked Sendable {}
final class WebURLOption: MyModel, Content {
    static let schema: String = "web_url_options"

    enum FieldNames {
        static let type = FieldKey("type")
        static let url = FieldKey("url")
    }

    @ID(key: .id) var id: UUID?
    @Field(key: FieldNames.type) var type: String?
    @Field(key: FieldNames.url) var url: String

    init() { }

    init(id: UUID? = nil, type: RestAPICallType? = nil, url: String) {
        self.id = id
        self.type = type?.rawValue
        self.url = url
    }
}
