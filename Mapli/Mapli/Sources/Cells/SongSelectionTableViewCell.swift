//
//  SongSelectionTableViewCell.swift
//  Mapli
//
//  Created by woo0 on 2022/07/22.
//

import UIKit

class SongSelectionTableViewCell: UITableViewCell {
	@IBOutlet weak var songTitle: UILabel!
	@IBOutlet weak var checkmark: UIImageView!
	
	var isCheck = false
	
	override func layoutSubviews() {
		checkmark.image = isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
