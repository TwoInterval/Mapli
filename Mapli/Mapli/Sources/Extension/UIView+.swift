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
	func transformToImage(x: CGFloat, y: CGFloat, size: CGSize) -> UIImage? {
		let renderer = UIGraphicsImageRenderer(bounds: CGRect(x: x+19, y: y-20, width: size.width, height: size.height))
		return renderer.image { rendererContext in
			layer.render(in: rendererContext.cgContext)
		}
	}
}
