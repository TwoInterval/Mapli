//
//  playListPreviewViewController.swift
//  Mapli
//
//  Created by 김상현 on 2022/07/26.
//

import UIKit

class PreviewMyPlayListViewController: UIViewController {
    @IBOutlet var templateCollectionView: UICollectionView!
    
    var myPlayListModel: MyPlayListModel? = nil
    var selectedMusicList: AppleMusicPlayList!

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.configureNavigationBar()
            self.setConstraint()
            self.configureImageView()
        }
    }

    private func setConstraint() {
        templateCollectionView.translatesAutoresizingMaskIntoConstraints = false
        templateCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: CGFloat(UIScreen.getDevice().previewTopPadding)).isActive = true
        templateCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -CGFloat(UIScreen.getDevice().previewBottomPadding)).isActive = true
        templateCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        templateCollectionView.widthAnchor.constraint(equalToConstant: CGFloat(UIScreen.getDevice().previewImageViewWidth)).isActive = true
        templateCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(UIScreen.getDevice().previewImageViewHeight)).isActive = true
        
        var insetMultiplier = CGFloat(1)
        guard let songs = selectedMusicList.songsString else { return }
        let songsCount = CGFloat(songs.count)
        guard let myPlayListModel = myPlayListModel else { return }
        switch myPlayListModel.template {
        case .templates1:
            insetMultiplier = 4 + 0.2 * songsCount
        case .templates2:
            insetMultiplier = 3.2 + 0.2 * songsCount
        case .templates3:
            insetMultiplier = 3.2 + 0.2 * songsCount
		case .templates7:
			insetMultiplier = 1.2 + 0.2 * songsCount
			addSongCountLabel(songCount: Int(songsCount))
        default:
            insetMultiplier = 3.7 + 0.2 * songsCount
        }
        templateCollectionView.contentInset.top = max((templateCollectionView.frame.height - templateCollectionView.contentSize.height) / insetMultiplier, 0)
    }
    
    private func configureImageView() {
        guard let templateImage = myPlayListModel?.template.rawValue else { return }
        guard let image = UIImage(named: templateImage) else { return }
		let imageView = UIImageView(image: image)
		if myPlayListModel?.template == .templates7 {
			imageView.contentMode = .scaleAspectFit
			imageView.backgroundColor = .white
		}
		templateCollectionView.backgroundView = imageView
		templateCollectionView.layer.borderWidth = 0.5
		templateCollectionView.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func configureNavigationBar() {
        let rightBarButtonItem = UIBarButtonItem(title: String(format: NSLocalizedString("완료", comment: "")), style: .done, target: self, action: #selector(onTapCompleteButton))

        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
	
	private func addSongCountLabel(songCount: Int) {
		let songCountLabel = UILabel()
		if songCount == 10 {
			songCountLabel.text = "0\(songCount)곡"
		} else {
			songCountLabel.text = "00\(songCount)곡"
		}
		songCountLabel.font = UIFont(name: "NanumBarunGothicOTFBold", size: 13)
		songCountLabel.textAlignment = .right
		songCountLabel.textColor = .yellow
		self.view.addSubview(songCountLabel)
		DispatchQueue.main.async {
			songCountLabel.translatesAutoresizingMaskIntoConstraints = false
			songCountLabel.topAnchor.constraint(equalTo: self.templateCollectionView.topAnchor, constant: 42.5).isActive = true
			songCountLabel.trailingAnchor.constraint(equalTo: self.templateCollectionView.trailingAnchor, constant: -23).isActive = true
			songCountLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
			songCountLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		}
	}
    
    @objc func onTapBackButton() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func onTapCompleteButton() {
		var image = UIImage()
		if myPlayListModel?.template == .templates7 {
			image = self.view.transformToImage(x: templateCollectionView.bounds.minX, y: templateCollectionView.bounds.midY, size: templateCollectionView.bounds.size) ?? UIImage()
		} else {
			image = templateCollectionView.transformToImage() ?? UIImage()
		}
        guard let imageFileName = ImageDataManager.shared.saveImage(image: image) else { return }
        guard var myPlayListModel = myPlayListModel else { return }
        myPlayListModel.myPlayListImageString = imageFileName
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
