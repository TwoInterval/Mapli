//
//  MainCollectionViewCell.swift
//  Mapli
//
//  Created by 전호정 on 2022/08/04.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pliName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 20
        pliName.translatesAutoresizingMaskIntoConstraints = false
        pliName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        pliName.text = ""
    }
    
}

