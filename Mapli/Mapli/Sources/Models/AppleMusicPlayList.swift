//
//  MySongModel.swift
//  Mapli
//
//  Created by woo0 on 2022/07/31.
//

import Foundation
import UIKit

struct AppleMusicPlayList {
    var playListImage: UIImage? = nil
    var songs: [MySong]
    var songsString: [String]? = nil
}

struct MySong {
	var title: String
	var image: UIImage
	var artistName: String
	var id: String
	var isCheck: Bool
}
