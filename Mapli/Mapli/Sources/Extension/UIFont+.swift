//
//  UIFont+.swift
//  Mapli
//
//  Created by 김상현 on 2022/08/11.
//

import UIKit

extension UIFont {
    enum Font: String {
        case ChosunCentennial
    }
    
    static func font(size: CGFloat, font: Font) -> UIFont {
        guard let font = UIFont(name: font.rawValue, size: size) else {
            return UIFont()
        }
        return font
    }
}
