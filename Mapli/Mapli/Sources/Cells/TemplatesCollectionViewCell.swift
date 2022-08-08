//
//  TemplatesCollectionViewCell.swift
//  Mapli
//
//  Created by woo0 on 2022/08/04.
//

import UIKit

class TemplatesCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var templatesImageView: UIImageView!
	@IBOutlet weak var templatesCheckImageView: UIImageView!
	
	var imageName = String()
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override var isSelected: Bool {
		didSet {
			if isSelected {
				templatesCheckImageView.isHidden = false
			} else {
				templatesCheckImageView.isHidden = true
			}
		}
	}
}
