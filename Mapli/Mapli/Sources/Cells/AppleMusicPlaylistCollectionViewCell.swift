//
//  AppleMusicPlaylistCollectionViewCell.swift
//  Mapli
//
//  Created by 전호정 on 2022/08/04.
//

import UIKit

class AppleMusicPlaylistCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playlistLabel.translatesAutoresizingMaskIntoConstraints = false
        playlistLabel.topAnchor.constraint(equalTo: playlistImage.bottomAnchor, constant: 5).isActive = true
    }
}
