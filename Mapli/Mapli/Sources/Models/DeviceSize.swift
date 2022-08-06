//
//  DeviceSize.swift
//  Mapli
//
//  Created by woo0 on 2022/08/01.
//

import UIKit

enum DeviceSize {
	static let leadingPadding = UIScreen.main.proDevice ? 20 : 15
	static let topPaddong = UIScreen.main.proDevice ? 40 : 15
	static let fontSize = UIScreen.main.proDevice ? 17 : 15
	static let playlistImageSize = UIScreen.main.proDevice ? 170 : 155
	static let playlistPadding = UIScreen.main.proDevice ? 20 : 25
	static let playlistSpacing = UIScreen.main.proDevice ? 10 : 15
	static let templatesWidth = UIScreen.main.proDevice ? 210 : 183
	static let templatesHeight = UIScreen.main.proDevice ? 309 : 269
}
