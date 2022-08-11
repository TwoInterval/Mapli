//
//  UIView+.swift
//  Mapli
//
//  Created by 김상현 on 2022/08/11.
//

import UIKit

extension UIView {
    func transformToImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
