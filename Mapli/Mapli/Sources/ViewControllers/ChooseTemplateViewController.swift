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
	
	private let imagePicker = UIImagePickerController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTitleLabelStyle()
		setupTitleTextFieldStyle()
		setupImagePicker()
		
		navigationItem.title = "템플릿 선택"
	}
	
	@IBAction func imagePickerButtonTapped(_ sender: UIButton) {
		present(imagePicker, animated: true)
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
	
	private func setupImagePicker() {
		imagePicker.sourceType = .photoLibrary
		imagePicker.allowsEditing = true
		imagePicker.delegate = self
	}
}

extension ChooseTemplateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		var newImage: UIImage? = nil
		
		if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
			newImage = possibleImage
		} else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			newImage = possibleImage
		}
		
		imagePickerButton.setTitle("", for: .normal)
		newImage = resize(image: newImage ?? UIImage())
		imagePickerButton.setImage(newImage, for: .normal)
		imagePickerButton.imageView?.contentMode = .scaleAspectFit
		imagePickerButton.semanticContentAttribute = .forceRightToLeft
		picker.dismiss(animated: true, completion: nil)
	}
	
	func resize(image: UIImage) -> UIImage {
		let width = imagePickerButton.frame.size.width
		let height = imagePickerButton.frame.size.height
		let size = CGSize(width: width, height: height)
		let render = UIGraphicsImageRenderer(size: size)
		let renderImage = render.image { context in
			image.draw(in: CGRect(origin: .zero, size: size))
		}
		return renderImage
	}
}
