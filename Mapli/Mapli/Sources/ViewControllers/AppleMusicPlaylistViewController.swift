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
	private var songs = [Song]()
	private var viewModel = AppleMusicViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
		setupViewModel()
		initRefresh()
    }
	
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
	
	private func initRefresh() {
		let refresh = UIRefreshControl()
		refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
		refresh.attributedTitle = NSAttributedString(string: "RELOAD")
		collectionView.refreshControl = refresh
	}
	
	@objc private func updateUI(refresh: UIRefreshControl) {
		refresh.endRefreshing()
		songs = viewModel.songs
		collectionView.reloadData()
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

extension AppleMusicPlaylistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if viewModel.playlists.count == 0 {
            let label = UILabel()
            label.text = "Apple Music 앱에서\n플레이리스트를 추가해주세요.\n\n\n\n\n\n\n"
            label.numberOfLines = 9
            label.textAlignment = .center
            label.textColor = .gray
            collectionView.backgroundView = label
        }
        
        return viewModel.playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppleMusicPlaylistCell", for: indexPath) as? AppleMusicPlaylistCollectionViewCell {
			if !songs.isEmpty {
				var url = songs[0].attributes.artwork.url
				url = url.replacingOccurrences(of: "{w}", with: "\(songs[0].attributes.artwork.width)")
				url = url.replacingOccurrences(of: "{h}", with: "\(songs[0].attributes.artwork.height)")

				if URL(string: url) != nil {
					cell.playlistImage.load(url: URL(string: url)!)
				}
			}
			cell.playlistLabel.text = viewModel.playlists[indexPath.item].attributes.name
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension AppleMusicPlaylistViewController: UICollectionViewDelegate {
    
}

private extension AppleMusicPlaylistViewController {
	func setupViewModel() {
		viewModel.$playlists
			.receive(on: DispatchQueue.main)
			.sink { [weak self] playlist in
				if !playlist.isEmpty {
					self?.viewModel.fetchSongs(playlistId: "\(playlist[0].id)")
					self?.collectionView.backgroundView = nil
				}
			}
			.store(in: &cancelBag)
		
		viewModel.$songs
			.receive(on: DispatchQueue.main)
			.sink { [weak self] song in
				self?.songs = song
				self?.collectionView.reloadData()
			}
			.store(in: &cancelBag)
	}
}
