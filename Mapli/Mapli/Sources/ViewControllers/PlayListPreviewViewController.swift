//
//  playListPreviewViewController.swift
//  Mapli
//
//  Created by 김상현 on 2022/07/26.
//

import UIKit

class PlayListPreviewViewController: UIViewController {
    @IBOutlet var templateCollectionView: UICollectionView!
    @IBOutlet var templateCollectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var templateCollectionViewBottomConstraint: NSLayoutConstraint!
    
    var myPlayListModel: MyPlayListModel? = nil
    var selectedMusicList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setConstraint()
            self.configureImageView()
            self.configureNavigationBar()
        }
    }
    
    private func setConstraint() {
        templateCollectionViewTopConstraint.constant = CGFloat(DeviceSize.previewTopPadding)
        templateCollectionViewBottomConstraint.constant = CGFloat(DeviceSize.previewBottomPadding)
        templateCollectionView.contentInset.top = max((templateCollectionView.frame.height - templateCollectionView.contentSize.height) / 4.5, 0)
    }
    
    private func configureImageView() {
        guard let templateImage = myPlayListModel?.templateName else { return }
        guard let image = UIImage(named: templateImage) else { return }
        templateCollectionView.backgroundView = UIImageView(image: image)
    }
    
    private func configureNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(title: "이전", style: .done, target: self, action: #selector(onTapBackButton))
        
        let rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(onTapCompleteButton))

        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func onTapBackButton() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func onTapCompleteButton() {
        guard let image = templateCollectionView.transformToImage() else { return }
        guard let imageFileName = ImageDataManager.shared.saveImage(image: image) else { return }
        guard var myPlayListModel = myPlayListModel else { return }
        myPlayListModel.playListImageName = imageFileName
        MyPlayListModelManager.shared.appendMyPlayListModelArray(myPlayListModel)
        self.navigationController?.popToRootViewController(animated: false)
    }
}

extension PlayListPreviewViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedMusicList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateCollectionViewCell", for: indexPath) as? TemplateCollectionViewCell else { return UICollectionViewCell() }
        let musicTitle = selectedMusicList[indexPath.item]
        cell.setUI(musicTitle)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.9
        let height = (collectionView.bounds.height * 0.05)
        let CGSize = CGSize(width: width, height: height)
        return CGSize
    }
   
}

class TemplateCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setUI(_ titleText: String) {
        DispatchQueue.main.async {
            self.titleLabel.text = titleText
        }
    }
}
