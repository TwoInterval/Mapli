//
//  SongSelectionTableViewCell.swift
//  Mapli
//
//  Created by woo0 on 2022/07/22.
//

import UIKit

protocol CellButtonTappedDelegate: AnyObject {
	func playButtonTapped(index: Int)
}

class SongSelectionTableViewCell: UITableViewCell {
	@IBOutlet weak var songTitle: UILabel!
	@IBOutlet weak var artistName: UILabel!
	@IBOutlet weak var albumImage: UIImageView!
	@IBOutlet weak var checkmark: UIImageView!
	@IBOutlet weak var playButton: UIButton!
	
	var index = 0
	var playing = false
	var cellDelegate: CellButtonTappedDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
//		self.playButton.addTarget(self, action: #selector(cellClicked), for: .touchUpInside)
		
		if checkmark != nil {
			checkmark!.translatesAutoresizingMaskIntoConstraints = false
			checkmark!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
			checkmark!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
		}
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	
	@IBAction func playButtonTapped(_ sender: UIButton) {
		cellDelegate?.playButtonTapped(index: index)
	}
}
