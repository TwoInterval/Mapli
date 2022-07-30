//
//  Mapli++Bundle.swift
//  Mapli
//
//  Created by woo0 on 2022/07/30.
//

import Foundation

extension Bundle {
	var apiKey: String {
		guard let file = self.path(forResource: "AppleMusicInfo", ofType: "plist") else { return "" }
		
		guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
		guard let key = resource["API_KEY"] as? String else { fatalError("AppleMusicInfo.plist에 API_KEY를 입력해주세요.")}
		return key
	}
}
