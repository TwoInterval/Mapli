//
//  AppleMusicAPI.swift
//  Mapli
//
//  Created by woo0 on 2022/07/30.
//

import Foundation
import StoreKit

class AppleMusicAPI {
	let developerToken = Bundle.main.apiKey
	
	func fetchUserToken() async throws -> String {
		return try await SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken)
	}

	func fetchPlaylists(userToken: String) async throws -> [Playlist] {
		guard let musicURL = URL(string: "https://api.music.apple.com/v1/me/library/playlists") else { throw NetworkError.invalidURL }
		var musicRequest = URLRequest(url: musicURL)
		musicRequest.httpMethod = "GET"
		musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
		musicRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
		
		let (data, _) = try await URLSession.shared.data(for: musicRequest)
		let playlists = try JSONDecoder().decode(PlaylistDatum.self, from: data)
		return playlists.data
	}
	
	func fetchMySongs(userToken: String, id: String) async throws -> [MySong] {
		guard let musicURL = URL(string: "https://api.music.apple.com/v1/me/library/playlists/\(id)/tracks") else { throw NetworkError.invalidURL }
		var musicRequest = URLRequest(url: musicURL)
		musicRequest.httpMethod = "GET"
		musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
		musicRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
		
		let (data, _) = try await URLSession.shared.data(for: musicRequest)
		let songs = try JSONDecoder().decode(SongDatum.self, from: data)
		var mySongs = [MySong]()
		for song in songs.data {
			var imageUrl = song.attributes.artwork.url
			imageUrl = imageUrl.replacingOccurrences(of: "{w}", with: "\(song.attributes.artwork.width)")
			imageUrl = imageUrl.replacingOccurrences(of: "{h}", with: "\(song.attributes.artwork.height)")
			if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
				if let image = UIImage(data: data) {
					mySongs.append(MySong(title: song.attributes.name, image: image, artistName: song.attributes.artistName, id: id, isCheck: false))
				}
			}
		}
		return mySongs
	}
	
	func fetchSongs(userToken: String, id: String) async throws -> [Song] {
		guard let musicURL = URL(string: "https://api.music.apple.com/v1/me/library/playlists/\(id)/tracks") else { throw NetworkError.invalidURL }
		var musicRequest = URLRequest(url: musicURL)
		musicRequest.httpMethod = "GET"
		musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
		musicRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
		
		let (data, _) = try await URLSession.shared.data(for: musicRequest)
		let songs = try JSONDecoder().decode(SongDatum.self, from: data)
		return songs.data
	}
}
