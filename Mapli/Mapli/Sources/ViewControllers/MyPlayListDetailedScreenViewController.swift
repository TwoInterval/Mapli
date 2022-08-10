//
//  PlayListDetailedScreenViewController.swift
//  Mapli
//
//  Created by 김상현 on 2022/08/09.
//

import UIKit

class MyPlayListDetailedScreenViewController: UIViewController {
    @IBOutlet var myPlayListImageView: UIImageView!
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
        let alert = UIAlertController(title: "메뉴", message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        // 메시지 창 컨트롤러에 들어갈 버튼 액션 객체 생성
        let shareAction =  UIAlertAction(title: "공유하기", style: UIAlertAction.Style.default){_ in
            guard let imageName = self.myPlayListModel?.playListImageName else { return }
            guard let image = ImageDataManager.shared.fetchImage(named: imageName) else { return }
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        let destructiveAction = UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.destructive){(_) in
            // 버튼 클릭시 실행되는 코드
        }
        let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) {_ in
            self.dismiss(animated: true)
        }
        
        //메시지 창 컨트롤러에 버튼 액션을 추가
        alert.addAction(shareAction)
        alert.addAction(destructiveAction)
        alert.addAction(cancelAction)

        //메시지 창 컨트롤러를 표시
        self.present(alert, animated: true)
    }
    
    private func setImageView() {
        myPlayListImageView.layer.cornerRadius = 20
        guard let myPlayListModel = myPlayListModel else { return }
        guard let imageName = myPlayListModel.playListImageName else { return }
        myPlayListImageView.image = ImageDataManager.shared.fetchImage(named: imageName)
    }
    
}
