//
//  PlaylistModel.swift
//  Mapli
//
//  Created by woo0 on 2022/07/30.
//

import Foundation

struct PlaylistDatum: Codable {
	let meta: PlaylistMeta
	let data: [Playlist]
}

struct Playlist: Codable {
	let href, type, id: String
	let attributes: PlaylistAttributes
}

struct PlaylistAttributes: Codable {
	let attributesDescription: Description
	let canEdit, hasCatalog, isPublic: Bool
	let dateAdded, name: String
	let playParams: PlaylistPlayParams

	enum CodingKeys: String, CodingKey {
		case playParams, canEdit, dateAdded, hasCatalog, name
		case attributesDescription = "description"
		case isPublic
	}
}

struct Description: Codable {
	let standard: String
}

struct PlaylistPlayParams: Codable {
	let globalID, kind, id: String
	let isLibrary: Bool

	enum CodingKeys: String, CodingKey {
		case globalID = "globalId"
		case kind, isLibrary, id
	}
}

struct PlaylistMeta: Codable {
	let total: Int
}

enum NetworkError: Error {
	case invalidURL
}
