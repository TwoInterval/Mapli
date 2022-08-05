//
//  AppleMusicViewModel.swift
//  Mapli
//
//  Created by woo0 on 2022/08/01.
//

import Combine
import Foundation
import StoreKit

class AppleMusicViewModel: ObservableObject {
	@Published var mySongs = [MySong]()
	@Published var playlists = [Playlist]()
	@Published var songs = [Song]()
	var usetToken = String()

	init() {
		SKCloudServiceController.requestAuthorization { (status) in
			if status == .authorized {
				self.fetchAPI()
			}
		}
	}

	func viewDidLoad() {
		SKCloudServiceController.requestAuthorization { (status) in
			if status == .authorized {
				self.fetchAPI()
			}
		}
	}
}

extension AppleMusicViewModel {
	func fetchAPI() {
		Task {
			do {
				self.usetToken = try await AppleMusicAPI().fetchUserToken()
				self.playlists = try await AppleMusicAPI().fetchPlaylists(userToken: usetToken)
				self.mySongs = try await AppleMusicAPI().fetchMySongs(userToken: usetToken, id: playlists[0].id)
			} catch NetworkError.invalidURL {
				print("Invalid URL ERROR!")
			}
		}
	}
	
	func fetchSongs(playlistId: String) {
		Task {
			do {
				self.songs = try await AppleMusicAPI().fetchSongs(userToken: usetToken, id: playlistId)
			} catch NetworkError.invalidURL {
				print("Invalid URL ERROR!")
			}
		}
	}
}
