//
//  AppleMusicViewModel.swift
//  Mapli
//
//  Created by woo0 on 2022/08/01.
//

import Combine
import Foundation
import StoreKit

final class AppleMusicViewModel: ObservableObject {
	@Published var mySongs = [MySong]()
	@Published var playlists = [Playlist]()
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

private extension AppleMusicViewModel {
	func fetchAPI() {
		Task {
			do {
				self.usetToken = try await AppleMusicAPI().fetchUserToken()
				self.playlists = try await AppleMusicAPI().fetchPlaylists(userToken: usetToken)
				self.mySongs = try await AppleMusicAPI().fetchSongs(userToken: usetToken, id: playlists[0].id)
                print("완료")
			} catch NetworkError.invalidURL {
				print("Invalid URL ERROR!")
			}
		}
	}
}
