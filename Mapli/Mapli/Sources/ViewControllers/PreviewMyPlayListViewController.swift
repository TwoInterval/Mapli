//
//  playListPreviewViewController.swift
//  Mapli
//
//  Created by 김상현 on 2022/07/26.
//

import UIKit

class PreviewMyPlayListViewController: UIViewController {
    @IBOutlet var templateCollectionView: UICollectionView!
    @IBOutlet var templateCollectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var templateCollectionViewBottomConstraint: NSLayoutConstraint!
    
    var myPlayListModel: MyPlayListModel? = nil
    var selectedMusicList: AppleMusicPlayList!

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setConstraint()
            self.configureImageView()
            self.configureNavigationBar()
        }
    }
    
    private func setConstraint() {
        templateCollectionViewTopConstraint.constant = CGFloat(UIScreen.getDevice().previewTopPadding)
        templateCollectionViewBottomConstraint.constant = CGFloat(UIScreen.getDevice().previewBottomPadding)
        
        guard let myPlayListModel = myPlayListModel else { return }
        var insetMultiplier = CGFloat(1)
        switch myPlayListModel.template {
        case .templates1:
            insetMultiplier = 6
        case .templates2:
            insetMultiplier = 4
        case .templates3:
            insetMultiplier = 4
        default:
            insetMultiplier = 4.5
        }
        templateCollectionView.contentInset.top = max((templateCollectionView.frame.height - templateCollectionView.contentSize.height) / insetMultiplier, 0)
    }
    
    private func configureImageView() {
        guard let templateImage = myPlayListModel?.template.rawValue else { return }
        guard let image = UIImage(named: templateImage) else { return }
        templateCollectionView.backgroundView = UIImageView(image: image)
    }
    
    private func configureNavigationBar() {
        let rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(onTapCompleteButton))

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

extension PreviewMyPlayListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let songs = selectedMusicList.songsString else { return 0 }
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewMyPlayListCollectionViewCell", for: indexPath) as? PreviewMyPlayListCollectionViewCell else { return UICollectionViewCell() }
        guard let myPlayListModel = myPlayListModel else { return cell }
        guard let songs = selectedMusicList.songsString else { return cell }
        let musicTitle = songs[indexPath.item]
        DispatchQueue.main.async {
            cell.selectedTemplate = myPlayListModel.template
            cell.setUI(musicTitle)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthMultiplier = 0.8
        var heightMultiplier = 0.05
        
        guard let myPlayListModel = myPlayListModel else { return CGSize() }
        switch myPlayListModel.template {
        case .templates1:
            heightMultiplier = 0.04
        case .templates2:
            heightMultiplier = 0.04
        case .templates3:
            widthMultiplier = 0.51
            heightMultiplier = 0.04
        case .templates5:
            widthMultiplier = 0.7
        default: break
        }
        
        let width = collectionView.bounds.width * widthMultiplier
        let height = collectionView.bounds.height * heightMultiplier
        let CGSize = CGSize(width: width, height: height)
        return CGSize
    }
}
