//
//  AppleMusicPlaylistViewController.swift
//  Mapli
//
//  Created by 전호정 on 2022/08/04.
//

import Combine
import UIKit

class AppleMusicPlaylistViewController: UIViewController {
    @IBOutlet weak private var collectionView: UICollectionView!
	
	private var cancelBag = Set<AnyCancellable>()
	private var songs = [[MySong]]()
	private var songsImage = [MySong]()
	private var viewModel = AppleMusicViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		setupNavigatoinBar()
        setupCollectionView()
		setupViewModel()
		initRefresh()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SongSelectionSegue" {
			let cell = sender as? AppleMusicPlaylistCollectionViewCell ?? UICollectionViewCell()
			let indexPath = collectionView.indexPath(for: cell)
			if let SongSelectionViewController = segue.destination as? SongSelectionViewController {
				if let indexPath = indexPath {
					SongSelectionViewController.musicList = songs[indexPath.item+1]
				}
			}
			
		}
	}
	
	private func setupNavigatoinBar() {
		let backButton = UIBarButtonItem()
		backButton.title = "이전"
		navigationItem.backBarButtonItem = backButton
		navigationController?.navigationBar.backIndicatorImage = UIImage()
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
		navigationController?.navigationBar.tintColor = .red
        
    }
	
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(DeviceSize.playlistPadding)).isActive = true
		collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(DeviceSize.playlistPadding)).isActive = true
    }
	
	private func initRefresh() {
		let refresh = UIRefreshControl()
		refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
		refresh.attributedTitle = NSAttributedString(string: "RELOAD")
		collectionView.refreshControl = refresh
	}
	
	@objc private func updateUI(refresh: UIRefreshControl) {
		refresh.endRefreshing()
		collectionView.reloadData()
	}
    
    @objc private func accessToExternalApp() {
        let appSchme = "music://geo.itunes.apple.com/kr/"
        let storeUrl = "https://apps.apple.com/kr/app/apple-music/id1108187390"
        
        if let openApp = URL(string: appSchme), UIApplication.shared.canOpenURL(openApp) {
            UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
        }
        else {
            if let openStore = URL(string: storeUrl), UIApplication.shared.canOpenURL(openStore) {
                UIApplication.shared.open(openStore, options: [:], completionHandler: nil)
            }
        }
    }
    
    func resize(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }

}

extension AppleMusicPlaylistViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.playlists.count == 0 {
            DispatchQueue.main.async {
                let buttonTitle = "Apple Music 앱에서\n플레이리스트를 추가해주세요.\n\n\n\n\n\n\n"
                let attributedString = NSMutableAttributedString(string: buttonTitle)
                attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: (buttonTitle as NSString).range(of: "Apple Music 앱"))
                attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: (buttonTitle as NSString).range(of: "에서\n플레이리스트를 추가해주세요.\n\n\n\n\n\n\n"))
                let backgroundButton = UIButton()
                backgroundButton.setTitle("Apple Music 앱에서\n플레이리스트를 추가해주세요.\n\n\n\n\n\n\n", for: .normal)
                backgroundButton.setAttributedTitle(attributedString, for: .normal)
                backgroundButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                backgroundButton.titleLabel?.lineBreakMode = .byWordWrapping
                backgroundButton.titleLabel?.textAlignment = .center
                backgroundButton.addTarget(self, action: #selector(self.accessToExternalApp), for: .touchUpInside)
                collectionView.backgroundView = backgroundButton
            }
        }
        return viewModel.playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppleMusicPlaylistCell", for: indexPath) as? AppleMusicPlaylistCollectionViewCell {
			if songsImage.count == viewModel.playlists.count {
				var url = songsImage[indexPath.item].imageURL
				url = url.replacingOccurrences(of: "{w}", with: "\(songsImage[indexPath.item].width)")
				url = url.replacingOccurrences(of: "{h}", with: "\(songsImage[indexPath.item].height)")

				if URL(string: url) != nil {
					cell.playlistImage.load(url: URL(string: url)!)
					cell.playlistImage.layer.cornerRadius = 20
				}
				
				for playlist in viewModel.playlists {
					if playlist.id == songsImage[indexPath.item].id {
						cell.playlistLabel.text = playlist.attributes.name
					}
				}
			}
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: DeviceSize.playlistImageSize, height: DeviceSize.playlistImageSize+27)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return CGFloat(DeviceSize.playlistSpacing)
	}
}

private extension AppleMusicPlaylistViewController {
	func setupViewModel() {
		viewModel.$playlists
			.receive(on: DispatchQueue.main)
			.sink { [weak self] playlist in
				for list in playlist {
					self?.viewModel.fetchMySong(playlistId: list.id)
				}
				if !playlist.isEmpty {
					self?.collectionView.backgroundView = nil
				}
			}
			.store(in: &cancelBag)
		
		viewModel.$mySongs
			.receive(on: DispatchQueue.main)
			.sink { [weak self] song in
				if !song.isEmpty {
					self?.songsImage.append(MySong(title: song[0].title, imageURL: song[0].imageURL, id: song[0].id, width: song[0].width, height: song[0].height, isCheck: song[0].isCheck))
				}
				self?.songs.append(song)
				self?.collectionView.reloadData()
			}
			.store(in: &cancelBag)
	}
}
