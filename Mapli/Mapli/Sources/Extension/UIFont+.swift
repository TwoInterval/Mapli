//
//  UIFont+.swift
//  Mapli
//
//  Created by 김상현 on 2022/08/11.
//

import UIKit

extension UIFont {
    
    
    enum Font: String {
        case ChosunCentennial, EBS훈민정음L, EBS훈민정음R, EBS훈민정음SB, Eulyoo1945, UhBeemysen, UhBeeSeulvely, Chalkduster
        case GowunBatangRegular = "GowunBatang-Regular"
        // UhBeemysenBold 적용안됨
    }
    
    static func font(size: CGFloat, font: Font) -> UIFont {
        guard let font = UIFont(name: font.rawValue, size: size) else {
            return UIFont()
        }
        return font
    }
}
