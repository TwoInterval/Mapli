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
	@IBOutlet weak var collectionView: UICollectionView!
	
	private let imagePicker = UIImagePickerController()
	
	private var templatesList = ["templates1", "templates2", "templates3", "templates4", "templates5"]
	private var selectedTemplates = "templates1"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraint()
		setupTitleLabelStyle()
		setupTitleTextFieldStyle()
		setupImagePicker()
		setupNavigationBar()
		setupCollectionView()
		
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
	
	private func setupCollectionView() {
		collectionView.dataSource = self
		collectionView.delegate = self
	}
}

extension ChooseTemplateViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return templatesList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TamplatesCollectionCell", for: indexPath) as? TemplatesCollectionViewCell {
			
			var newImage = UIImage(named: "\(templatesList[indexPath.item])")
			newImage = resize(image: newImage ?? UIImage(), width: CGFloat(DeviceSize.templatesWidth), height: CGFloat(DeviceSize.templatesHeight))
			cell.templatesImageView.image = newImage
			cell.templatesImageView.contentMode = .scaleAspectFit
			cell.templatesCheckImageView.image = UIImage(named: "Selected")
			cell.imageName = "\(templatesList[indexPath.item])"
			
			if indexPath.item == 0 {
				cell.isSelected = true
				collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
			} else {
				cell.isSelected = false
			}
			
			return cell
		} else {
			return UICollectionViewCell()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) as? TemplatesCollectionViewCell {
			selectedTemplates = "\(cell.imageName)"
		}
	}
}

extension ChooseTemplateViewController: UICollectionViewDelegate {
	
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
		newImage = resize(image: newImage ?? UIImage(), width: imagePickerButton.frame.size.width, height: imagePickerButton.frame.size.height)
		newImage = newImage?.withRoundedCorners(radius: 20)
		imagePickerButton.setImage(newImage, for: .normal)
		imagePickerButton.imageView?.contentMode = .scaleAspectFit
		imagePickerButton.semanticContentAttribute = .forceRightToLeft
		picker.dismiss(animated: true, completion: nil)
	}
	
	func resize(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
		let size = CGSize(width: width, height: height)
		let render = UIGraphicsImageRenderer(size: size)
		let renderImage = render.image { context in
			image.draw(in: CGRect(origin: .zero, size: size))
		}
		return renderImage
	}
}
