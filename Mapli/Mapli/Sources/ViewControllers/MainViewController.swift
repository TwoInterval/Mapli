//
//  ViewController.swift
//  Mapli
//
//  Created by woo0 on 2022/07/22.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigatoinBar()
        setupCollectionView()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

	private func setupNavigatoinBar() {
		let backButton = UIBarButtonItem()
		backButton.title = "취소"
		navigationItem.backBarButtonItem = backButton
		navigationController?.navigationBar.backIndicatorImage = UIImage()
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
		navigationController?.navigationBar.tintColor = .red
	}

}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let label = UILabel()
        label.text = "나만의 플레이리스트를\n추가해주세요.\n\n\n\n\n"
        label.numberOfLines = 7
        label.textAlignment = .center
        label.textColor = .gray
        collectionView.backgroundView = label
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell {
            
            cell.imageView.image = UIImage(named: "Selected")
            cell.pliName.text = "aaaa"
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
