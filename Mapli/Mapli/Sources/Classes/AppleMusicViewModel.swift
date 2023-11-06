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
                LoadingIndicator.showLoading(loadingText: "플레이리스트를 불러옵니다.")
            } else {
                LoadingIndicator.hideLoading()
            }
        }
    }
	private var userToken = String()

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
				LoadingIndicator.showLoading(loadingText: "Apple Music과 연동중입니다.")
				self.userToken = try await AppleMusicAPI().fetchUserToken()
				LoadingIndicator.hideLoading()
				self.isInitializing = true
				if let playlists = try await AppleMusicAPI().fetchPlaylists(userToken: userToken) {
					self.playlists = playlists
				}
				self.isInitializing = false
			} catch NetworkError.invalidURL {
				self.playlists = []
				self.isInitializing = false
				print("Invalid URL ERROR!")
			} catch NetworkError.invalidUserToken {
				self.playlists = []
				self.isInitializing = false
				print("유저 토큰이 없습니다.")
			}
		}
	}
	
	func fetchMySong(playlistId: String) {
		Task {
			do {
				self.mySongs = try await AppleMusicAPI().fetchMySongs(userToken: userToken, id: playlistId)
			} catch NetworkError.invalidURL {
				print("Invalid URL ERROR!")
			}
		}
	}
}
