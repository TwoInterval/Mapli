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
	@IBOutlet weak private var collectionView: UICollectionView!
    
	private let imagePicker = UIImagePickerController()
    private var templatesList = [TemplatesModel(imageName: .templates1, isCheck: false), TemplatesModel(imageName: .templates2, isCheck: false), TemplatesModel(imageName: .templates3, isCheck: false), TemplatesModel(imageName: .templates4, isCheck: false), TemplatesModel(imageName: .templates5, isCheck: false)]
	private var selectedTemplates: TemplatesModel?
    var selectedMusicList: AppleMusicPlayList!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraint()
		setupTitleTextFieldStyle()
		setupImagePicker()
		setupNavigationBar()
		setupCollectionView()
		
		titleLabel.attributedText = convertToAttributedString(text: titleLabel.text ?? "")
		imageTitleLabel.attributedText = convertToAttributedString(text: imageTitleLabel.text ?? "")
		templateTitleLabel.attributedText = convertToAttributedString(text: templateTitleLabel.text ?? "")
	}
	
	@IBAction func imagePickerButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "대표 이미지 선택", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction =  UIAlertAction(title: "사진 촬영", style: UIAlertAction.Style.default) { _ in
            self.openCamera()
        }
        let galleryAction =  UIAlertAction(title: "갤러리에서 선택", style: UIAlertAction.Style.default) { _ in
            self.openLibrary()
        }
        let defaultImageAction =  UIAlertAction(title: "플레이리스트 이미지 사용", style: UIAlertAction.Style.default) { _ in
            DispatchQueue.main.async {
                guard let image = self.selectedMusicList.playListImage else { return }
                let resizedImage = self.resize(image: image, width: self.imagePickerButton.frame.size.width, height: self.imagePickerButton.frame.size.height)
                self.imagePickerButton.setImage(resizedImage, for: .normal)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel) {_ in
            self.dismiss(animated: true)
        }
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(defaultImageAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "미리보기", style: .plain, target: self, action: #selector(nextButtonTapped))
	}
	
	private func convertToAttributedString(text: String) -> NSMutableAttributedString {
		let attributedString = NSMutableAttributedString(string: text)
		attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: (text as NSString).range(of: text))
		attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: "*"))
		return attributedString
	}
	
	private func setupTitleTextFieldStyle() {
		titleTextField.delegate = self
		titleTextField.borderStyle = .none
		titleTextField.font = UIFont(name: titleTextField.font != nil ? titleTextField.font!.fontName : "AppleSDGothicNeo-Regular", size: 17)
		let border = CALayer()
		border.frame = CGRect(x: 0, y: titleTextField.frame.size.height-10, width: titleTextField.frame.width-40, height: 1)
		border.backgroundColor = UIColor.black.cgColor
		titleTextField.layer.addSublayer(border)
	}
	
	private func setupImagePicker() {
		imagePickerButton.layer.cornerRadius = 20
		imagePicker.allowsEditing = true
		imagePicker.delegate = self
	}
	
	private func setupCollectionView() {
		collectionView.dataSource = self
		collectionView.delegate = self
	}
    
    @objc private func nextButtonTapped() {
        guard let title = titleTextField.text else { return }
        if title == "" {
            showToastMessage("제목을 입력해주세요.")
            return
        }
        guard let image = imagePickerButton.image(for: .normal) else {
            showToastMessage("대표 이미지를 선택해주세요.")
            return
        }
		guard let templateName = selectedTemplates?.imageName else {
			showToastMessage("템플릿을 선택해주세요.")
			return
		}
        let imageDataManager = ImageDataManager.shared
        guard let savedImageFileName = imageDataManager.saveImage(image: image) else { return }
        
        let myPlayListModel = MyPlayListModel(title: title, titleImageName: savedImageFileName, template: templateName, playListImageName: nil)

        let storyBoard = UIStoryboard(name: "playListPreview", bundle: nil)
        guard let playListPreviewVC = storyBoard.instantiateViewController(withIdentifier: "playListPreview") as? PreviewMyPlayListViewController else { return }
        playListPreviewVC.myPlayListModel = myPlayListModel
        playListPreviewVC.selectedMusicList = self.selectedMusicList
        self.navigationController?.pushViewController(playListPreviewVC, animated: true)
    }
}

extension ChooseTemplateViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Template.allCases.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TamplatesCollectionCell", for: indexPath) as? TemplatesCollectionViewCell {
            
            let templateImage = templatesList[indexPath.item].imageName
            var newImage = UIImage(named: templateImage.rawValue)

			newImage = resize(image: newImage ?? UIImage(), width: CGFloat(DeviceSize.templatesWidth), height: CGFloat(DeviceSize.templatesHeight))
			cell.templatesImageView.image = newImage
			cell.templatesImageView.contentMode = .scaleAspectFit
			cell.templatesCheckImageView.image = resize(image: UIImage(named: "Selected")!, width: 50, height: 50)
            cell.template = templateImage
			cell.isSelected = templatesList[indexPath.item].isCheck
			
			return cell
		} else {
			return UICollectionViewCell()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) as? TemplatesCollectionViewCell {
            guard let cellTemplate = cell.template else { return }
			selectedTemplates = TemplatesModel(imageName: cellTemplate, isCheck: cell.isSelected)
		}
	}
}

extension ChooseTemplateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
    func openLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		var newImage: UIImage? = nil
		
		if let possibleImage = info[.editedImage] as? UIImage {
			newImage = possibleImage
		} else if let possibleImage = info[.originalImage] as? UIImage {
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


extension ChooseTemplateViewController {
    func showToastMessage(_ message: String, font: UIFont = UIFont.systemFont(ofSize: 12, weight: .light)) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.width / 2 - 150, y: view.frame.height - 120, width: 300, height: 50))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.numberOfLines = 2
        toastLabel.font = font
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)

        UIView.animate(withDuration: 1.5, delay: 0.7, options: .curveEaseOut) {
            toastLabel.alpha = 0.0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
}

extension ChooseTemplateViewController: UITextFieldDelegate {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// 출처: https://jwonylee.github.io/ios/take-a-photo
extension UIImagePickerController {
	open override var childForStatusBarHidden: UIViewController? {
		return nil
	}

	open override var prefersStatusBarHidden: Bool {
		return true
	}

	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		fixCannotMoveEditingBox()
	}

	func fixCannotMoveEditingBox() {
		if let cropView = cropView,
		   let scrollView = scrollView,
		   scrollView.contentOffset.y == 0 {

			let top: CGFloat = cropView.frame.minY
			let bottom = scrollView.frame.height - cropView.frame.height - top
			scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)

			var offset: CGFloat = 0
			if scrollView.contentSize.height > scrollView.contentSize.width {
				offset = 0.5 * (scrollView.contentSize.height - scrollView.contentSize.width)
			}
			scrollView.contentOffset = CGPoint(x: 0, y: -top + offset)
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
			self?.fixCannotMoveEditingBox()
		}
	}

	var cropView: UIView? {
		return findCropView(from: self.view)
	}

	var scrollView: UIScrollView? {
		return findScrollView(from: self.view)
	}

	func findCropView(from view: UIView) -> UIView? {
		let width = UIScreen.main.bounds.width
		let size = view.bounds.size
		if width == size.height, width == size.height {
			return view
		}
		for view in view.subviews {
			if let cropView = findCropView(from: view) {
				return cropView
			}
		}
		return nil
	}

	func findScrollView(from view: UIView) -> UIScrollView? {
		if let scrollView = view as? UIScrollView {
			return scrollView
		}
		for view in view.subviews {
			if let scrollView = findScrollView(from: view) {
				return scrollView
			}
		}
		return nil
	}
}
