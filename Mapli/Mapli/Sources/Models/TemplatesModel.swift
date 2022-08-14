//
//  TemplatesModel.swift
//  Mapli
//
//  Created by woo0 on 2022/08/04.
//

import Foundation

struct TemplatesModel {
	var imageName: Template
	var isCheck: Bool
}

enum Template: String, CaseIterable, Codable {
    case templates1
    case templates2
    case templates3
    case templates4
    case templates5
}
