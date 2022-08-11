//
//  SongModel.swift
//  Mapli
//
//  Created by woo0 on 2022/07/30.
//

import Foundation

struct SongDatum: Codable {
	let data: [Song]
	let meta: SongMeta
}

struct Song: Codable {
	let id: String
	let type: TypeEnum
	let attributes: SongAttributes
	let href: String
}

struct SongAttributes: Codable {
	let name, albumName: String
	let genreNames: [String]
	let artwork: Artwork
	let hasLyrics: Bool
	let artistName: String
	let durationInMillis, discNumber: Int
	let playParams: SongPlayParams
	let trackNumber: Int
	let releaseDate: String
	let contentRating: String?
}

struct Artwork: Codable {
	let url: String
	let height, width: Int
}

struct SongPlayParams: Codable {
	let reportingID: String?
	let catalogID, id: String
	let kind: Kind
	let reporting, isLibrary: Bool

	enum CodingKeys: String, CodingKey {
		case reportingID = "reportingId"
		case catalogID = "catalogId"
		case id, kind, reporting, isLibrary
	}
}

enum Kind: String, Codable {
	case song = "song"
}

enum TypeEnum: String, Codable {
	case librarySongs = "library-songs"
}

struct SongMeta: Codable {
	let total: Int
}
