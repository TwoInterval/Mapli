//
//  PlaylistModel.swift
//  Mapli
//
//  Created by woo0 on 2022/07/30.
//

import Foundation

struct PlaylistDatum: Codable {
    let data: [Playlist]
    let meta: Meta
}

struct Playlist: Codable {
    let id, type, href: String
    let attributes: Attributes
}

struct Attributes: Codable {
    let playParams: PlayParams
    let hasCatalog, canEdit, isPublic: Bool
    let name, dateAdded: String
}

struct PlayParams: Codable {
    let id, kind: String
    let isLibrary: Bool
}

struct Meta: Codable {
    let total: Int
}

enum NetworkError: Error {
    case invalidURL
}
