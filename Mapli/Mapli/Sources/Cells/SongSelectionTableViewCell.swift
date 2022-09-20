//
//  SongSelectionTableViewCell.swift
//  Mapli
//
//  Created by woo0 on 2022/07/22.
//

import UIKit

class SongSelectionTableViewCell: UITableViewCell {
	@IBOutlet weak var songTitle: UILabel!
	@IBOutlet weak var artistName: UILabel!
	@IBOutlet weak var albumImage: UIImageView!
	@IBOutlet weak var checkmark: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		if checkmark != nil {
			checkmark!.translatesAutoresizingMaskIntoConstraints = false
			checkmark!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
			checkmark!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
		}
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
