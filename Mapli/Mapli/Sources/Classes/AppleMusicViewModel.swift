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
    /// fetchAPI(), fetchMySong(playlistId: String), collectionView.reloadData() 모든 과정의 진행상황
    @Published var isInitializing = true {
        didSet {
            if isInitializing {
                LoadingIndicator.showLoading()
            } else {
                LoadingIndicator.hideLoading()
            }
        }
    }
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
                self.isInitializing = true
				self.usetToken = try await AppleMusicAPI().fetchUserToken()
				let playlists = try await AppleMusicAPI().fetchPlaylists(userToken: usetToken)
                if playlists.isEmpty {
                    self.isInitializing = false
                }
                self.playlists = playlists
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
