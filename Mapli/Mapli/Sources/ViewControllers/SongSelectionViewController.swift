//
//  SongSelectionViewController.swift
//  Mapli
//
//  Created by woo0 on 2022/07/22.
//

import UIKit

class SongSelectionViewController: UIViewController, UISearchBarDelegate {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var selectAllButton: UIButton!
	
	private var isFiltering: Bool {
		let searchController = self.navigationItem.searchController
		let isActive = searchController?.isActive ?? false
		let isSearchText = searchController?.searchBar.text?.isEmpty == false
		return isActive && isSearchText
	}
	private var isSearchBar = false
	private var searchMusicList = [MySong]()
	
    var appleMusicPlayList: AppleMusicPlayList!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraint()
		setupTableView()
		setupNavigatoinBar()
		initRefresh()
	}
	
	@IBAction func searchButtonTapped(_ sender: UIButton) {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = "노래 제목을 입력하세요."
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
		navigationItem.searchController = searchController
		DispatchQueue.main.async {
			searchController.searchBar.searchTextField.becomeFirstResponder()
		}
		isSearchBar = true
		searchButton.isHidden = true
	}
	
	@IBAction func selectAllButtonTapped(_ sender: UIButton) {
		if CheckIfSelected() {
			for row in 0..<tableView.numberOfRows(inSection: 0) {
                appleMusicPlayList.songs[row].isCheck = false
				tableView.reloadData()
			}
		} else {
			for row in 0..<(tableView.numberOfRows(inSection: 0) < 10 ? tableView.numberOfRows(inSection: 0) : 10) {
				let indexPath = IndexPath(row: row, section: 0)
				if let cell = tableView.cellForRow(at: indexPath) as? SongSelectionTableViewCell {
					cell.selectionStyle = .none
                    appleMusicPlayList.songs[indexPath.row].isCheck.toggle()
                    cell.checkmark.image = (appleMusicPlayList.songs[indexPath.row].isCheck) ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
				}
			}
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		navigationItem.searchController = nil
		searchButton.isHidden = false
		isSearchBar = false
	}
	
	private func setupConstraint() {
		self.searchButton.translatesAutoresizingMaskIntoConstraints = false
		self.searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(UIScreen().getDevice().leadingPadding)).isActive = true
	}
	
	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
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
        for row in 0 ..< appleMusicPlayList.songs.count {
            if appleMusicPlayList.songs[row].isCheck {
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
		self.tableView.reloadData()
	}
	
	@objc private func nextButtonTapped() {
        let selectedMySongList = appleMusicPlayList.songs.filter { $0.isCheck }
		let selectedMusicList = selectedMySongList.map { $0.title }
		if !selectedMusicList.isEmpty {
			let chooseTemplateVC = self.storyboard?.instantiateViewController(withIdentifier: "ChooseTemplateVC") as! ChooseTemplateViewController
            appleMusicPlayList.songsString = selectedMusicList
			chooseTemplateVC.selectedMusicList = appleMusicPlayList
			self.navigationController?.pushViewController(chooseTemplateVC, animated: true)
		} else {
			showToastMessage("최소 1곡 이상 선택해주세요.", y: view.frame.height - 120)
		}
	}
}

extension SongSelectionViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? searchMusicList.count : appleMusicPlayList.songs.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "SongSelectionTableCell", for: indexPath) as? SongSelectionTableViewCell {
			
			if isFiltering {
				let song = searchMusicList[indexPath.row]
				cell.songTitle.text = song.title
				cell.checkmark.image = song.isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
			} else {
                let song = appleMusicPlayList.songs[indexPath.row]
				cell.songTitle.text = song.title
				cell.checkmark.image = song.isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
			}
			
			return cell
		} else {
			return UITableViewCell()
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? SongSelectionTableViewCell {
			cell.selectionStyle = .none
			let songs = appleMusicPlayList.songs.filter { $0.isCheck == true }
			
			if isFiltering {
				if let row = self.appleMusicPlayList.songs.firstIndex(where: { $0.title == searchMusicList[indexPath.row].title }) {
					if appleMusicPlayList.songs[row].isCheck == false && songs.count >= 10 {
						showToastMessage("최대 10개까지 선택 가능합니다.", y: view.frame.height - 350)
					} else {
						appleMusicPlayList.songs[row].isCheck.toggle()
						cell.checkmark.image = searchMusicList[indexPath.row].isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
					}
				}
				if let row = self.searchMusicList.firstIndex(where: { $0.title == searchMusicList[indexPath.row].title }) {
					if searchMusicList[row].isCheck == false && songs.count >= 10 {
						showToastMessage("최대 10개까지 선택 가능합니다.", y: view.frame.height - 350)
					} else {
						searchMusicList[row].isCheck.toggle()
						cell.checkmark.image = searchMusicList[indexPath.row].isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
					}
				}
			} else {
				if appleMusicPlayList.songs[indexPath.row].isCheck == false && songs.count >= 10 {
					if isSearchBar {
						showToastMessage("최대 10개까지 선택 가능합니다.", y: view.frame.height - 350)
					} else {
						showToastMessage("최대 10개까지 선택 가능합니다.", y: view.frame.height - 120)
					}
				} else {
					appleMusicPlayList.songs[indexPath.row].isCheck.toggle()
					cell.checkmark.image = appleMusicPlayList.songs[indexPath.row].isCheck ? UIImage(named: "Selected") : UIImage(named: "UnSelected")
				}
			}
		}
	}
}

extension SongSelectionViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
        searchMusicList = appleMusicPlayList.songs.filter { return $0.title.localizedCaseInsensitiveContains(text) }
		
		tableView.reloadData()
	}
}

extension SongSelectionViewController {
	func showToastMessage(_ message: String, font: UIFont = UIFont.systemFont(ofSize: 12, weight: .light), y: CGFloat) {
		let toastLabel = UILabel(frame: CGRect(x: view.frame.width / 2 - 150, y: y, width: 300, height: 50))
		
		toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
		toastLabel.textColor = UIColor.white
		toastLabel.numberOfLines = 2
		toastLabel.font = font
		toastLabel.text = message
		toastLabel.textAlignment = .center
		toastLabel.layer.cornerRadius = 10
		toastLabel.clipsToBounds = true
		
		self.view.addSubview(toastLabel)

		UIView.animate(withDuration: 1.5, delay: 0.7, options: .curveEaseOut) {
			toastLabel.alpha = 0.0
		} completion: { _ in
			toastLabel.removeFromSuperview()
		}
	}
}
