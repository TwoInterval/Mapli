//
//  ViewController.swift
//  Mapli
//
//  Created by woo0 on 2022/07/22.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigatoinBar()
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

