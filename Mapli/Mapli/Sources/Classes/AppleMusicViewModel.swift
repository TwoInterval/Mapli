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
    @Published var isFetchingAPI = true
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
                self.isFetchingAPI = false
			} catch NetworkError.invalidURL {
				print("Invalid URL ERROR!")
			}
		}
	}
	
	func fetchMySong(playlistId: String) {
		Task {
			do {
				self.mySongs = try await AppleMusicAPI().fetchMySongs(userToken: usetToken, id: playlistId)
			} catch NetworkError.invalidURL {
				print("Invalid URL ERROR!")
			}
		}
	}
}
