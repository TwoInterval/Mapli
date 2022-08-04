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
	@IBOutlet weak var imageTitleLabel: UILabel!
	@IBOutlet weak var imagePickerButton: UIButton!
	@IBOutlet weak var templateTitleLabel: UILabel!
	@IBOutlet weak var templateScrollView: UIScrollView!
	
	private let imagePicker = UIImagePickerController()
	private let imageList = ["templates1", "templates2", "templates3", "templates4", "templates5"]
	
	private var buttonList = [UIButton]()
	private var selectedTemplates = "templates1"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraint()
		setupTitleLabelStyle()
		setupTitleTextFieldStyle()
		setupImagePicker()
		setupTemplateImage()
		setupNavigationBar()
		
		imagePickerButton.layer.cornerRadius = 20
	}
	
	@IBAction func imagePickerButtonTapped(_ sender: UIButton) {
		present(imagePicker, animated: true)
	}
	
	private func setupConstraint() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(DeviceSize.topPaddong)).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(DeviceSize.leadingPadding)).isActive = true
		imageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		imageTitleLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: CGFloat(DeviceSize.topPaddong)).isActive = true
		imageTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(DeviceSize.leadingPadding)).isActive = true
		templateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		templateTitleLabel.topAnchor.constraint(equalTo: imagePickerButton.bottomAnchor, constant: CGFloat(DeviceSize.topPaddong)).isActive = true
		templateTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(DeviceSize.leadingPadding)).isActive = true
		templateScrollView.translatesAutoresizingMaskIntoConstraints = false
		templateScrollView.topAnchor.constraint(equalTo: templateTitleLabel.bottomAnchor, constant: 10).isActive = true
		templateScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(DeviceSize.leadingPadding)).isActive = true
		templateScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		templateScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}
	
	private func setupNavigationBar() {
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
	
	private func setupImagePicker() {
		imagePicker.sourceType = .photoLibrary
		imagePicker.allowsEditing = true
		imagePicker.delegate = self
	}
	
	private func setupTemplateImage() {
		for i in 0..<imageList.count{
			let xPosition = CGFloat(DeviceSize.templatesWidth+DeviceSize.leadingPadding) * CGFloat(i)
			let templatesButton = UIButton(frame: CGRect(x: xPosition, y: 0, width: CGFloat(DeviceSize.templatesWidth), height: CGFloat(DeviceSize.templatesHeight)))
			templatesButton.setImage(UIImage(named: "\(imageList[i])") ?? UIImage(), for: .normal)
			templatesButton.imageView?.contentMode = .scaleAspectFit
			
			let tapGesture = CustomTapGesture(target: self, action: #selector(chooseTemplate(gesture:)))
			tapGesture.imageName = imageList[i]
			tapGesture.button = templatesButton
			templatesButton.addGestureRecognizer(tapGesture)
			templatesButton.isUserInteractionEnabled = true
			
			if i == 0 {
				templatesButton.isSelected = true
				templatesButton.layer.borderColor = UIColor.red.cgColor
				templatesButton.layer.borderWidth = 1
			}
			
			buttonList.append(templatesButton)
			
			templateScrollView.contentSize.width = CGFloat(DeviceSize.templatesWidth+DeviceSize.leadingPadding) * CGFloat(1+i)
			templateScrollView.addSubview(templatesButton)
		}
	}
	
	@objc func chooseTemplate(gesture: CustomTapGesture) {
		print(gesture.imageName ?? "")
		buttonList.map {
			$0.isSelected = false
		}
		gesture.button.isSelected = true
		buttonList.map {
			if $0.isSelected {
				$0.layer.borderColor = UIColor.red.cgColor
				$0.layer.borderWidth = 1
			} else {
				$0.layer.borderColor = UIColor.clear.cgColor
				$0.layer.borderWidth = 0
			}
		}
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
		newImage = newImage?.withRoundedCorners(radius: 20)
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
