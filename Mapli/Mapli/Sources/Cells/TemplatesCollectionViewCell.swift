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
	
    var template: Template? = nil
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		templatesCheckImageView.translatesAutoresizingMaskIntoConstraints = false
		templatesCheckImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		templatesCheckImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
	}
	
    override func prepareForReuse() {
        super.prepareForReuse()
        template = nil
        templatesImageView.image = nil
        templatesCheckImageView.image = nil
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
