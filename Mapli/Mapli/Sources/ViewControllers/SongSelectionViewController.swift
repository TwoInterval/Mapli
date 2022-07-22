//
//  SongSelectionViewController.swift
//  Mapli
//
//  Created by woo0 on 2022/07/22.
//

import UIKit

class SongSelectionViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	var dummy = ["금요일에 만나요", "No Brainer", "Peaches", "Uptown Funk", "칵테일 사랑", "Intentions", "Treasure"]
	override func viewDidLoad() {
		tableView.dataSource = self
		tableView.delegate = self
	}
}

extension SongSelectionViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dummy.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SongSelectionTableCell", for: indexPath) as! SongSelectionTableViewCell
		let song = dummy[indexPath.row]
		cell.songTitle.text = song
		
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! SongSelectionTableViewCell
		cell.selectionStyle = .none
		cell.isCheck = !(cell.isCheck)
	}
}

extension SongSelectionViewController: UITableViewDelegate {
	
}
