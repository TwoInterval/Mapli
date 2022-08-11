//
//  PreviewMyPlayListCollectionViewCell.swift
//  Mapli
//
//  Created by 김상현 on 2022/08/11.
//

import UIKit

class PreviewMyPlayListCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    var selectedTemplate: Template? = nil
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUI(_ titleText: String) {
        guard let selectedTemplate = selectedTemplate else { return }
//        switch selectedTemplate {
//        case .templates1:
//            self.titleLabel.font = .systemFont(ofSize: <#T##CGFloat#>, weight: <#T##UIFont.Weight#>)
//        case .templates2:
//            <#code#>
//        case .templates3:
//            <#code#>
//        case .templates4:
//            <#code#>
//        case .templates5:
//            <#code#>
//        }
        DispatchQueue.main.async {
            self.titleLabel.text = titleText
        }
    }
}
