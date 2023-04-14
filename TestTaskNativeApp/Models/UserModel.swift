//
//  UserModel.swift
//  TestTaskNativeApp
//
//  Created by Александр Янчик on 13.04.23.
//

import Foundation


struct UserModel: Codable {
    var userContent: [UserContentModel]
    var page: Int
    var pageSize: Int
    var totalElements: Int
    var totalPages: Int

    enum CodingKeys: String, CodingKey {
        case userContent = "content"
        case page = "page"
        case pageSize = "pageSize"
        case totalElements = "totalElements"
        case totalPages = "totalPages"
    }
}

struct UserContentModel: Codable {
    var id: Int
    var name: String
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image = "image"
    }
}
