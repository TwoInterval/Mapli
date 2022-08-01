//
//  DeviceSize.swift
//  Mapli
//
//  Created by woo0 on 2022/08/01.
//

import UIKit

enum DeviceSize {
	static let leftPadding = UIScreen.main.proDevice ? 20 : 15
	static let topPaddong = UIScreen.main.proDevice ? 40 : 15
	static let fontSize = UIScreen.main.proDevice ? 17 : 15
	static let playlistImageSize = UIScreen.main.proDevice ? 170 : 150
}
