//
//  SongSelectionViewController.swift
//  Mapli
//
//  Created by woo0 on 2022/07/22.
//

import UIKit

class SongSelectionViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	private var dummy = ["금요일에 만나요", "No Brainer", "Peaches", "Uptown Funk", "칵테일 사랑", "Intentions", "Treasure"]
	override func viewDidLoad() {
		
	}
}

extension SongSelectionViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dummy.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let song = dummy[indexPath.row]
		cell.textLabel?.text = song
		
		return cell
	}
}

extension SongSelectionViewController: UITableViewDelegate {
	
}
