//
//  AppleMusicPlaylistViewController.swift
//  Mapli
//
//  Created by 전호정 on 2022/08/04.
//

import UIKit

class AppleMusicPlaylistViewController: UIViewController {
    @IBOutlet weak private var collectionView: UICollectionView!
    
    var viewModel: AppleMusicViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        guard viewModel != nil else {
            return
        }
        print(viewModel?.playlists)
        print(viewModel?.mySongs)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
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
        
        if (viewModel != nil ? viewModel!.playlists.count : 0) == 0 {
            let label = UILabel()
            label.text = "Apple Music 앱에서\n플레이리스트를 추가해주세요.\n\n\n\n\n\n\n"
            label.numberOfLines = 9
            label.textAlignment = .center
            label.textColor = .gray
            collectionView.backgroundView = label
        }
        
        return viewModel != nil ? viewModel!.playlists.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppleMusicPlaylistCell", for: indexPath) as? AppleMusicPlaylistCollectionViewCell {
            
            var newImage = UIImage(named: "templates3")
            newImage = resize(image: newImage ?? UIImage(), width: 170, height: 170)
            cell.playlistImage.image = newImage
            cell.playlistImage.contentMode = .scaleAspectFit
            cell.playlistLabel.text = "aaaa"
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension AppleMusicPlaylistViewController: UICollectionViewDelegate {
    
}
