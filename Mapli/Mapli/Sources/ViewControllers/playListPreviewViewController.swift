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
        }
    }

    private func configureImageView() {
        templateImageView.image = UIImage(named: "blackBoard.png")
    }
}
