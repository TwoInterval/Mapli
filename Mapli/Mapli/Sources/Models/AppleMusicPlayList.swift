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
	var imageURL: String
	var id: String
	var width: Int
	var height: Int
	var isCheck: Bool
}
