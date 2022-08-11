//
//  PlayListDetailedScreenViewController.swift
//  Mapli
//
//  Created by 김상현 on 2022/08/09.
//

import UIKit

class MyPlayListDetailedScreenViewController: UIViewController {
    @IBOutlet var myPlayListImageView: UIImageView!
    private let myPlayListModelManager = MyPlayListModelManager.shared
    var myPlayListModel: MyPlayListModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setNavigationBar()
            self.setImageView()
        }
    }
    private func setNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(onTapLeftBarButtonItem))
        let image = UIImage(systemName: "ellipsis.circle")
        let rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(onTapRightBarButtonItem))
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc private func onTapLeftBarButtonItem() {
        self.navigationController?.popViewController(animated: false)
    }
    @objc private func onTapRightBarButtonItem() {
        let actionSheet = UIAlertController(title: "메뉴", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let shareAction =  UIAlertAction(title: "공유하기", style: UIAlertAction.Style.default){_ in
            guard let imageName = self.myPlayListModel?.playListImageName else { return }
            guard let image = ImageDataManager.shared.fetchImage(named: imageName) else { return }
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        let destructiveAction = UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.destructive){(_) in
            self.popRemoveAlert()
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default) {_ in
            self.dismiss(animated: true)
        }
        actionSheet.addAction(shareAction)
        actionSheet.addAction(destructiveAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true)
    }
    
    private func setImageView() {
        myPlayListImageView.layer.cornerRadius = 20
        guard let myPlayListModel = myPlayListModel else { return }
        guard let imageName = myPlayListModel.playListImageName else { return }
        myPlayListImageView.image = ImageDataManager.shared.fetchImage(named: imageName)
    }
    
    private func popRemoveAlert() {
        let alert = UIAlertController(title: "플레이리스트 삭제", message: "플레이리스트를 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default) { (_) in
            self.dismiss(animated: true)
        }
        let removeAction = UIAlertAction(title: "삭제", style: .destructive) { (_) in
            guard let myPlayListModel = self.myPlayListModel else { return }
            self.myPlayListModelManager.removeMyPlayListModel(myPlayListModel)
            self.navigationController?.popViewController(animated: false)
        }
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        self.present(alert, animated: true)
    }
    
}
