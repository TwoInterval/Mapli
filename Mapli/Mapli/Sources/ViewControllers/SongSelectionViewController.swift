//
//  SongSelectionViewController.swift
//  Mapli
//
//  Created by woo0 on 2022/07/22.
//

import UIKit

class SongSelectionViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	private var isFiltering: Bool {
		let searchController = self.navigationItem.searchController
		let isActive = searchController?.isActive ?? false
		let isSearchText = searchController?.searchBar.text?.isEmpty == false
		return isActive && isSearchText
	}
	private var isSearchBar = false
	
	var dummy = [MySong(title: "금요일에 만나요", isCheck: false), MySong(title: "No Brainer", isCheck: false), MySong(title: "Peaches", isCheck: false), MySong(title: "Uptown Funk", isCheck: false), MySong(title: "칵테일 사랑", isCheck: false), MySong(title: "Intentions", isCheck: false), MySong(title: "Treasure", isCheck: false), MySong(title: "아무노래", isCheck: false), MySong(title: "Monologue", isCheck: false), MySong(title: "사랑앓이", isCheck: false), MySong(title: "METHOR", isCheck: false), MySong(title: "People", isCheck: false)]
	var searchDummy = [MySong]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupNavigatoinBar()
		
		navigationItem.title = "음악 선택"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextButtonTapped))
		
	}
	
	@IBAction func searchButtonTapped(_ sender: UIButton) {
		isSearchBar.toggle()
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = "노래 제목을 입력하세요."
		searchController.searchResultsUpdater = self
		searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
		
		if isSearchBar {
			navigationItem.searchController = searchController
		} else {
			navigationItem.searchController = nil
		}
	}
	
	@IBAction func selectAllButtonTapped(_ sender: UIButton) {
		if CheckIfSelected() {
			for row in 0..<tableView.numberOfRows(inSection: 0) {
				let indexPath = IndexPath(row: row, section: 0)
				let cell = tableView.cellForRow(at: indexPath) as! SongSelectionTableViewCell
				cell.selectionStyle = .none
				dummy[indexPath.row].isCheck = false
				cell.checkmark.image = UIImage(named: "UnSelected")
			}
		} else {
			for row in 0..<(tableView.numberOfRows(inSection: 0) < 9 ? tableView.numberOfRows(inSection: 0) : 9) {
				let indexPath = IndexPath(row: row, section: 0)
				let cell = tableView.cellForRow(at: indexPath) as! SongSelectionTableViewCell
				cell.selectionStyle = .none
				dummy[indexPath.row].isCheck = !(dummy[indexPath.row].isCheck)
				cell.checkmark.image = (dummy[indexPath.row].isCheck) ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
			}
		}
	}
	
	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	private func setupSearchController() {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = "노래 제목을 입력하세요."
		navigationItem.searchController = searchController
		searchController.searchResultsUpdater = self
		searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
	}
	
	private func setupNavigatoinBar() {
		let backButton = UIBarButtonItem()
		backButton.title = "이전"
		navigationItem.backBarButtonItem = backButton
		navigationController?.navigationBar.backIndicatorImage = UIImage()
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
		navigationController?.navigationBar.tintColor = .red
	}
	
	private func CheckIfSelected() -> Bool {
		var isSelected = false
		for row in 0..<dummy.count {
			if dummy[row].isCheck {
				isSelected = true
			}
		}
		return isSelected
	}
	
	@objc private func nextButtonTapped() {
		let chooseTemplateVC = self.storyboard?.instantiateViewController(withIdentifier: "ChooseTemplateVC") ?? UIViewController()
		self.navigationController?.pushViewController(chooseTemplateVC, animated: true)
	}
}

extension SongSelectionViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return isFiltering ? searchDummy.count : dummy.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SongSelectionTableCell", for: indexPath) as! SongSelectionTableViewCell
		
		if isFiltering {
			let song = searchDummy[indexPath.row]
			cell.songTitle.text = song.title
			cell.checkmark.image = song.isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
		} else {
			let song = dummy[indexPath.row]
			cell.songTitle.text = song.title
			cell.checkmark.image = song.isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! SongSelectionTableViewCell
		
		cell.selectionStyle = .none
		
		if isFiltering {
			if let row = self.dummy.firstIndex(where: { $0.title == searchDummy[indexPath.row].title }) {
				dummy[row].isCheck.toggle()
			}
			if let row = self.searchDummy.firstIndex(where: { $0.title == searchDummy[indexPath.row].title }) {
				searchDummy[row].isCheck.toggle()
			}
			cell.checkmark.image = searchDummy[indexPath.row].isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
		} else {
			dummy[indexPath.row].isCheck.toggle()
			cell.checkmark.image = dummy[indexPath.row].isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
		}
	}
}

extension SongSelectionViewController: UITableViewDelegate {
	
}

extension SongSelectionViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		searchDummy = dummy.filter { return $0.title.localizedCaseInsensitiveContains(text) }
		
		tableView.reloadData()
	}
}
