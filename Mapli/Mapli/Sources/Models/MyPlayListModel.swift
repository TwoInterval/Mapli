//
//  MyPlayListModel.swift
//  Mapli
//
//  Created by 김상현 on 2022/08/08.
//

import Foundation

struct MyPlayListModel: Codable {
    var title: String
    var titleImageName: String
    var templateName: String
    var playListImageName: String?
}

class MyPlayListModelManager {
    static let shared = MyPlayListModelManager()
    private let userDefaults = UserDefaults.standard
    private let userDefaultsKey = "MyPlayListModel"
    var myPlayListModelArray: [MyPlayListModel] = []

    init() {
        fetchModelArrayFromUserDefaults()
    }
    
    func appendMyPlayListModelArray(_ model: MyPlayListModel) {
        myPlayListModelArray.append(model)
        saveModelArrayToUserDefaults()
    }
    
    private func saveModelArrayToUserDefaults() {
        let encoder = JSONEncoder()
        guard let encodedModel = try? encoder.encode(myPlayListModelArray) else { return }
        userDefaults.set(encodedModel, forKey: userDefaultsKey)
    }
    
    private func fetchModelArrayFromUserDefaults() {
        if let savedData = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data {
            let decoder = JSONDecoder()
            guard let savedObject = try? decoder.decode([MyPlayListModel].self, from: savedData) else { return }
            myPlayListModelArray = savedObject
        }
    }
}
