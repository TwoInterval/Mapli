//
//  ChooseTemplateViewController.swift
//  Mapli
//
//  Created by woo0 on 2022/07/31.
//

import UIKit

class ChooseTemplateViewController: UIViewController {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var imagePickerButton: UIButton!
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTitleLabelStyle()
		setupTitleTextFieldStyle()
		
		navigationItem.title = "템플릿 선택"
	}
	
	private func setupTitleLabelStyle() {
		let attributedString = NSMutableAttributedString(string: titleLabel.text ?? "")
		attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: ((titleLabel.text ?? "") as NSString).range(of: "*"))
		attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: ((titleLabel.text ?? "") as NSString).range(of: "제목"))
		titleLabel.attributedText = attributedString
	}
	
	private func setupTitleTextFieldStyle() {
		titleTextField.borderStyle = .none
		let border = CALayer()
		border.frame = CGRect(x: 0, y: titleTextField.frame.size.height-10, width: titleTextField.frame.width-40, height: 1)
		border.backgroundColor = UIColor.black.cgColor
		titleTextField.layer.addSublayer(border)
	}
}
