//
//  MyPlayListModel.swift
//  Mapli
//
//  Created by 김상현 on 2022/08/08.
//

import Foundation

struct MyPlayListModel: Codable, Equatable {
    var title: String
    var titleImageName: String
    var template: Template
    var playListImageName: String?
    
    public static func == (lhs: MyPlayListModel, rhs: MyPlayListModel) -> Bool {
        guard lhs.title == rhs.title else {return false}
        guard lhs.titleImageName == rhs.titleImageName else {return false}
        guard lhs.template == rhs.template else {return false}
        guard lhs.playListImageName == rhs.playListImageName else {return false}
        return true
    }
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
    
    func removeMyPlayListModel(_ model: MyPlayListModel) {
        guard let index = myPlayListModelArray.firstIndex(of: model) else { return }
        myPlayListModelArray.remove(at: index)
        saveModelArrayToUserDefaults()
    }
    
    func replaceMyPlayListModel(originalModel: MyPlayListModel, newModel: MyPlayListModel) {
        guard let index = myPlayListModelArray.firstIndex(of: originalModel) else { return }
        myPlayListModelArray[index] = newModel
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
