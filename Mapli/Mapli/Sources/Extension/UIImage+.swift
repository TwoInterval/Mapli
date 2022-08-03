//
//  UIImage+.swift
//  Mapli
//
//  Created by woo0 on 2022/08/03.
//

import UIKit

extension UIImage {
	public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
		let maxRadius = min(size.width, size.height) / 2
		let cornerRadius: CGFloat
		if let radius = radius, radius > 0 && radius <= maxRadius {
			cornerRadius = radius
		} else {
			cornerRadius = maxRadius
		}
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		let rect = CGRect(origin: .zero, size: size)
		UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
		draw(in: rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}
