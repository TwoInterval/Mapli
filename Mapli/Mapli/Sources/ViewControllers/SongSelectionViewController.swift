//
//  SongSelectionViewController.swift
//  Mapli
//
//  Created by woo0 on 2022/07/22.
//

import UIKit

class SongSelectionViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var selectAllButton: UIButton!
	
	private let viewModel = AppleMusicViewModel()
	
	private var isFiltering: Bool {
		let searchController = self.navigationItem.searchController
		let isActive = searchController?.isActive ?? false
		let isSearchText = searchController?.searchBar.text?.isEmpty == false
		return isActive && isSearchText
	}
	private var isSearchBar = false
	private var musicList = [MySong]()
	private var searchMusicList = [MySong]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraint()
		setupTableView()
		setupNavigatoinBar()
		initRefresh()
		
		
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
	
//	@IBAction func selectAllButtonTapped(_ sender: UIButton) {
//		if CheckIfSelected() {
//			for row in 0..<tableView.numberOfRows(inSection: 0) {
//				let indexPath = IndexPath(row: row, section: 0)
//				let cell = tableView.cellForRow(at: indexPath) as! SongSelectionTableViewCell
//				cell.selectionStyle = .none
//				musicList[indexPath.row].isCheck = false
//				cell.checkmark.image = UIImage(named: "UnSelected")
//			}
//		} else {
//			for row in 0..<(tableView.numberOfRows(inSection: 0) < 9 ? tableView.numberOfRows(inSection: 0) : 9) {
//				let indexPath = IndexPath(row: row, section: 0)
//				let cell = tableView.cellForRow(at: indexPath) as! SongSelectionTableViewCell
//				cell.selectionStyle = .none
//				musicList[indexPath.row].isCheck.toggle()
//				cell.checkmark.image = (musicList[indexPath.row].isCheck) ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
//			}
//		}
//	}
	
	private func setupConstraint() {
		self.searchButton.translatesAutoresizingMaskIntoConstraints = false
		self.searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(DeviceSize.leadingPadding)).isActive = true
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
		navigationItem.title = "음악 선택"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextButtonTapped))
		navigationItem.backBarButtonItem = backButton
		navigationController?.navigationBar.backIndicatorImage = UIImage()
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
		navigationController?.navigationBar.tintColor = .red
	}
	
	private func CheckIfSelected() -> Bool {
		var isSelected = false
		for row in 0..<musicList.count {
			if musicList[row].isCheck {
				isSelected = true
			}
		}
		return isSelected
	}
	
	private func initRefresh() {
		let refresh = UIRefreshControl()
		refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
		refresh.attributedTitle = NSAttributedString(string: "RELOAD")
		tableView.refreshControl = refresh
	}
	
	@objc private func updateUI(refresh: UIRefreshControl) {
		refresh.endRefreshing()
		viewModel.viewDidLoad()
		musicList = viewModel.mySongs
		self.tableView.reloadData()
	}
    
	@objc private func nextButtonTapped() {
		let chooseTemplateVC = self.storyboard?.instantiateViewController(withIdentifier: "ChooseTemplateVC") ?? UIViewController()
		self.navigationController?.pushViewController(chooseTemplateVC, animated: true)
	}
}

extension SongSelectionViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return isFiltering ? searchMusicList.count : musicList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SongSelectionTableCell", for: indexPath) as! SongSelectionTableViewCell
		
		if isFiltering {
			let song = searchMusicList[indexPath.row]
			cell.songTitle.text = song.title
			cell.checkmark.image = song.isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
		} else {
			let song = musicList[indexPath.row]
			cell.songTitle.text = song.title
			cell.checkmark.image = song.isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! SongSelectionTableViewCell
		
		cell.selectionStyle = .none
		
		if isFiltering {
			if let row = self.musicList.firstIndex(where: { $0.title == searchMusicList[indexPath.row].title }) {
				musicList[row].isCheck.toggle()
			}
			if let row = self.searchMusicList.firstIndex(where: { $0.title == searchMusicList[indexPath.row].title }) {
				searchMusicList[row].isCheck.toggle()
			}
			cell.checkmark.image = searchMusicList[indexPath.row].isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
		} else {
			musicList[indexPath.row].isCheck.toggle()
			cell.checkmark.image = musicList[indexPath.row].isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
		}
	}
}

extension SongSelectionViewController: UITableViewDelegate {
	
}

extension SongSelectionViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		searchMusicList = musicList.filter { return $0.title.localizedCaseInsensitiveContains(text) }
		
		tableView.reloadData()
	}
}
