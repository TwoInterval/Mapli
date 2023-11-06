//
//  PlaylistModel.swift
//  Mapli
//
//  Created by woo0 on 2022/07/30.
//

import Foundation

struct PlaylistDatum: Codable {
    let data: [Playlist]
    let meta: Meta?
}

struct Playlist: Codable {
    let id, type, href: String
    let attributes: Attributes
}

struct Attributes: Codable {
    let playParams: PlayParams
	let artwork: PlaylistArtwork?
	let description: PlaylistDescription?
    let hasCatalog, canEdit, isPublic: Bool
    let name, dateAdded: String
}

struct PlaylistArtwork: Codable {
	let width, height: JSONNull?
	let url: String
}

struct PlaylistDescription: Codable {
	let standard: String
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
	case invalidUserToken
}

class JSONNull: Codable, Hashable {

	public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
		return true
	}

	public var hashValue: Int {
		return 0
	}

	public init() {}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if !container.decodeNil() {
			throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encodeNil()
	}
}
