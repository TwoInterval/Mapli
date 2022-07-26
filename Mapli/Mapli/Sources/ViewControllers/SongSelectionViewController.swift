//
//  SongSelectionViewController.swift
//  Mapli
//
//  Created by woo0 on 2022/07/22.
//

import UIKit

class SongSelectionViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	var dummy = [["song": "금요일에 만나요", "isCheck": false], ["song": "No Brainer", "isCheck": false], ["song": "Peaches", "isCheck": false], ["song": "Uptown Funk", "isCheck": false], ["song": "칵테일 사랑", "isCheck": false], ["song": "Intentions", "isCheck": false], ["song": "Treasure", "isCheck": false], ["song": "금요일에 만나요", "isCheck": false], ["song": "No Brainer", "isCheck": false], ["song": "Peaches", "isCheck": false], ["song": "Uptown Funk", "isCheck": false], ["song": "칵테일 사랑", "isCheck": false], ["song": "Intentions", "isCheck": false], ["song": "Treasure", "isCheck": false]]
	override func viewDidLoad() {
		tableView.dataSource = self
		tableView.delegate = self
	}
	@IBAction func searchButtonTapped(_ sender: UIButton) {
	}
	@IBAction func selectAllButtonTapped(_ sender: UIButton) {
		if CheckIfSelected() {
			for row in 0..<tableView.numberOfRows(inSection: 0) {
				let indexPath = IndexPath(row: row, section: 0)
				let cell = tableView.cellForRow(at: indexPath) as! SongSelectionTableViewCell
				cell.selectionStyle = .none
				dummy[indexPath.row]["isCheck"] = false
				cell.checkmark.image = UIImage(named: "UnSelected")
			}
		} else {
			for row in 0..<(tableView.numberOfRows(inSection: 0) < 9 ? tableView.numberOfRows(inSection: 0) : 9) {
				let indexPath = IndexPath(row: row, section: 0)
				let cell = tableView.cellForRow(at: indexPath) as! SongSelectionTableViewCell
				cell.selectionStyle = .none
				dummy[indexPath.row]["isCheck"] = !(dummy[indexPath.row]["isCheck"] as? Bool ?? false)
				cell.checkmark.image = (dummy[indexPath.row]["isCheck"] as? Bool ?? false) ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
			}
		}
	}
	private func CheckIfSelected() -> Bool {
		var isSelected = false
		for row in 0..<dummy.count {
			if dummy[row]["isCheck"] as? Bool ?? false {
				isSelected = true
			}
		}
		return isSelected
	}
}

extension SongSelectionViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dummy.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SongSelectionTableCell", for: indexPath) as! SongSelectionTableViewCell
		let song = dummy[indexPath.row]
		cell.songTitle.text = song["song"] as? String ?? ""
		
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! SongSelectionTableViewCell
		cell.selectionStyle = .none
		dummy[indexPath.row]["isCheck"] = !(dummy[indexPath.row]["isCheck"] as? Bool ?? false)
		cell.checkmark.image = (dummy[indexPath.row]["isCheck"] as? Bool ?? false) ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
	}
}

extension SongSelectionViewController: UITableViewDelegate {
	
}
