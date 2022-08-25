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
        let image = UIImage(systemName: "ellipsis.circle")?.withTintColor(UIColor(named: "TextColor") ?? UIColor.black, renderingMode: .alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(onTapRightBarButtonItem))
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    @objc private func onTapRightBarButtonItem() {
        let actionSheet = UIAlertController(title: String(format: NSLocalizedString("메뉴", comment: "")), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let shareAction =  UIAlertAction(title: String(format: NSLocalizedString("공유하기", comment: "")), style: UIAlertAction.Style.default){_ in
            guard let imageName = self.myPlayListModel?.myPlayListImageString else { return }
            guard let image = ImageDataManager.shared.fetchImage(named: imageName) else { return }
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        let editAction =  UIAlertAction(title: String(format: NSLocalizedString("편집하기", comment: "")), style: UIAlertAction.Style.default){_ in
            let storyBoard = UIStoryboard(name: "ChooseTemplateStoryboard", bundle: nil)
            guard let viewController = storyBoard.instantiateViewController(withIdentifier: "ChooseTemplateVC") as? ChooseTemplateViewController else { return }
            viewController.chooseTemplateViewControllerType = .edit
            viewController.myPlayListModel = self.myPlayListModel
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        let destructiveAction = UIAlertAction(title: String(format: NSLocalizedString("삭제하기", comment: "")), style: UIAlertAction.Style.destructive){(_) in
            self.popRemoveAlert()
        }
        let cancelAction = UIAlertAction(title: String(format: NSLocalizedString("취소", comment: "")), style: UIAlertAction.Style.cancel) {_ in
            self.dismiss(animated: true)
        }
        actionSheet.addAction(shareAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(destructiveAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true)
    }
    
    private func setImageView() {
        myPlayListImageView.layer.cornerRadius = 20
        guard let myPlayListModel = myPlayListModel else { return }
        guard let imageName = myPlayListModel.myPlayListImageString else { return }
        myPlayListImageView.image = ImageDataManager.shared.fetchImage(named: imageName)
    }
    
    private func popRemoveAlert() {
        let alert = UIAlertController(title: String(format: NSLocalizedString("플레이리스트 삭제", comment: "")), message: String(format: NSLocalizedString("플레이리스트를 삭제하시겠습니까?", comment: "")), preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: String(format: NSLocalizedString("취소", comment: "")), style: .default) { (_) in
            self.dismiss(animated: true)
        }
        let removeAction = UIAlertAction(title: String(format: NSLocalizedString("삭제", comment: "")), style: .destructive) { (_) in
            guard let myPlayListModel = self.myPlayListModel else { return }
            self.myPlayListModelManager.removeMyPlayListModel(myPlayListModel)
            self.navigationController?.popViewController(animated: false)
        }
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        self.present(alert, animated: true)
    }
    
}
