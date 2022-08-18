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
	private var appleMusicPlaylist = [AppleMusicPlayList]()
	private var viewModel = AppleMusicViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		setupNavigatoinBar()
        setupCollectionView()
        setupConstraint()
		setupViewModel()
		initRefresh()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SongSelectionSegue" {
            guard let cell = sender as? AppleMusicPlaylistCollectionViewCell else { return }
			let indexPath = collectionView.indexPath(for: cell)
			if let SongSelectionViewController = segue.destination as? SongSelectionViewController {
				if let indexPath = indexPath {
					SongSelectionViewController.appleMusicPlayList = appleMusicPlaylist[indexPath.item]
				}
			}
			
		}
	}
    
    private func setupConstraint() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(DeviceSize.playlistPadding)).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(-(DeviceSize.playlistPadding))).isActive = true
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
        if appleMusicPlaylist.count == 0 {
			collectionView.backgroundView = self.setEmptyView()
        }
        return appleMusicPlaylist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppleMusicPlaylistCell", for: indexPath) as? AppleMusicPlaylistCollectionViewCell {
            cell.playlistImage.frame = CGRect(x: 0, y: 0, width: DeviceSize.playlistImageSize, height: DeviceSize.playlistImageSize)
			cell.playlistImage.image = appleMusicPlaylist[indexPath.item].playListImage
			cell.playlistImage.layer.cornerRadius = 20
			for playlist in viewModel.playlists {
				if playlist.id == appleMusicPlaylist[indexPath.item].songs[0].id {
					cell.playlistLabel.text = playlist.attributes.name
				}
			}
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: DeviceSize.playlistImageSize, height: DeviceSize.playlistImageSize + 27)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return CGFloat(DeviceSize.playlistHorizontalSpacing)
	}

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(DeviceSize.playlistVerticalSpacing)
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
					let songsString = song.map {
						return $0.title
					}
					var imageUrl = song[0].imageURL
					imageUrl = imageUrl.replacingOccurrences(of: "{w}", with: "\(song[0].width)")
					imageUrl = imageUrl.replacingOccurrences(of: "{h}", with: "\(song[0].height)")
					
					if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
						if let image = UIImage(data: data) {
							self?.appleMusicPlaylist.append(AppleMusicPlayList(playListImage: image, songs: song, songsString: songsString))
						}
					}
				}
				self?.collectionView.reloadData()
			}
			.store(in: &cancelBag)
	}
}

private extension AppleMusicPlaylistViewController {
	func setEmptyView() -> UIView {
		let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
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
		emptyView.addSubview(backgroundButton)
		backgroundButton.translatesAutoresizingMaskIntoConstraints = false
		backgroundButton.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
		backgroundButton.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
		return emptyView
	}
}
