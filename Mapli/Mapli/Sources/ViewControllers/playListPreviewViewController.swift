//
//  playListPreviewViewController.swift
//  Mapli
//
//  Created by 김상현 on 2022/07/26.
//

import UIKit

class playListPreviewViewController: UIViewController {
    @IBOutlet var templateImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.configureImageView()
            self.configureNavigationBar()
        }
    }

    private func configureImageView() {
        templateImageView.image = UIImage(named: "blackBoard.png")
    }
    
    private func configureNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(title: "이전", style: .done, target: self, action: #selector(onTapBackButton))
        
        let rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(onTapBackButton))

        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func onTapBackButton() {
        print("ddd")
//        self.navigationController?.dismiss(animated: true)
        
    }
}

extension playListPreviewViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateCollectionViewCell", for: indexPath) as? TemplateCollectionViewCell else { return UICollectionViewCell() }
        cell.setUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.8
        let height = (collectionView.bounds.height * 0.1) - 4.5
        let CGSize = CGSize(width: width, height: height)
        return CGSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return inset
    }
}

class TemplateCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setUI() {
        DispatchQueue.main.async {
            self.titleLabel.text = "금요일에 만나요. - 아이유"
        }
    }
}
