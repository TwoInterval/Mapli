//
//  UIScreen+.swift
//  Mapli
//
//  Created by woo0 on 2022/08/01.
//

import UIKit

extension UIScreen {
	func getDevice() -> DeviceSize {
		if self.bounds.size.width == 428 {
			return DeviceSize.iPhone13ProMax
		} else if self.bounds.size.width == 390 {
			return DeviceSize.iPhone13
		} else if self.bounds.size.width == 375 {
			return DeviceSize.iPhoneMini
		} else if self.bounds.size.width == 414 {
			return DeviceSize.iPhone11ProMax
		} else if self.bounds.size.width == 375 {
			return DeviceSize.iPhone11
		} else if self.bounds.size.width == 320 {
			return DeviceSize.iPhoneSE
		} else if self.bounds.size.width == 414 {
			return DeviceSize.iPhone8Plus
		} else if self.bounds.size.width == 375 {
			return DeviceSize.iPhone8
		} else {
			return DeviceSize.iPhone13
		}
	}
	
	enum DeviceSize {
		case iPhone13
		case iPhone13ProMax
		case iPhoneMini
		case iPhone11ProMax
		case iPhone11
		case iPhone8Plus
		case iPhone8
		case iPhoneSE

		var leadingPadding: Int {
			switch self {
			case .iPhone13: return 20
			case .iPhone13ProMax: return 22
			case .iPhoneMini: return 19
			case .iPhone11ProMax: return 21
			case .iPhone11: return 19
			case .iPhone8Plus: return 22
			case .iPhone8: return 15
			case .iPhoneSE: return 22
			}
		}
		
		var topPaddong: Int {
			switch self {
			case .iPhone13: return 40
			case .iPhone13ProMax: return 44
			case .iPhoneMini: return 39
			case .iPhone11ProMax: return 44
			case .iPhone11: return 40
			case .iPhone8Plus: return 22
			case .iPhone8: return 20
			case .iPhoneSE: return 17
			}
		}
		
		var fontSize: Int {
			switch self {
			case .iPhone13: return 17
			case .iPhone13ProMax: return 17
			case .iPhoneMini: return 17
			case .iPhone11ProMax: return 17
			case .iPhone11: return 17
			case .iPhone8Plus: return 15
			case .iPhone8: return 15
			case .iPhoneSE: return 15
			}
		}
		
		var playlistImageSize: Int {
			switch self {
			case .iPhone13: return 170
			case .iPhone13ProMax: return 187
			case .iPhoneMini: return 164
			case .iPhone11ProMax: return 181
			case .iPhone11: return 164
			case .iPhone8Plus: return 181
			case .iPhone8: return 155
			case .iPhoneSE: return 132
			}
		}
		
		var playlistPadding: Int {
			switch self {
			case .iPhone13: return 20
			case .iPhone13ProMax: return 22
			case .iPhoneMini: return 18
			case .iPhone11ProMax: return 20
			case .iPhone11: return 19
			case .iPhone8Plus: return 21
			case .iPhone8: return 25
			case .iPhoneSE: return 22
			}
		}
		
		var playlistVerticalSpacing: Int {
			switch self {
			case .iPhone13: return 28
			case .iPhone13ProMax: return 31
			case .iPhoneMini: return 27
			case .iPhone11ProMax: return 30
			case .iPhone11: return 27
			case .iPhone8Plus: return 28
			case .iPhone8: return 25
			case .iPhoneSE: return 22
			}
		}
		
		var templatesWidth: Int {
			switch self {
			case .iPhone13: return 210
			case .iPhone13ProMax: return 229
			case .iPhoneMini: return 202
			case .iPhone11ProMax: return 221
			case .iPhone11: return 199
			case .iPhone8Plus: return 199
			case .iPhone8: return 183
			case .iPhoneSE: return 155
			}
		}
		
		var templatesHeight: Int {
			switch self {
			case .iPhone13: return 309
			case .iPhone13ProMax: return 337
			case .iPhoneMini: return 297
			case .iPhone11ProMax: return 327
			case .iPhone11: return 296
			case .iPhone8Plus: return 295
			case .iPhone8: return 269
			case .iPhoneSE: return 230
			}
		}
		
		var previewTopPadding: Int {
			switch self {
			case .iPhone13: return 97
			case .iPhone13ProMax: return 97
			case .iPhoneMini: return 50
			case .iPhone11ProMax: return 97
			case .iPhone11: return 50
			case .iPhone8Plus: return 50
			case .iPhone8: return 50
			case .iPhoneSE: return 50
			}
		}
		
		var previewBottomPadding: Int {
			switch self {
			case .iPhone13: return 107
			case .iPhone13ProMax: return 107
			case .iPhoneMini: return 50
			case .iPhone11ProMax: return 107
			case .iPhone11: return 50
			case .iPhone8Plus: return 50
			case .iPhone8: return 50
			case .iPhoneSE: return 50
			}
		}
	}

}
