//
//  ImageDataManager.swift
//  Mapli
//
//  Created by 김상현 on 2022/08/08.
//

import UIKit

class ImageDataManager {
    static let shared = ImageDataManager()
    private let imageUserDefaultsKey: String = "imageFileName"
    
    var imageID: Int {
        return UserDefaults.standard.integer(forKey: imageUserDefaultsKey)
    }
    
    private func updateImageID() throws {
        UserDefaults.standard.set((imageID + 1), forKey: imageUserDefaultsKey)
    }
    
    ///  이미지 저장에 성공하면 파일 이름을 return합니다.
    func saveImage(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return nil
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return nil
        }
        do {
            try updateImageID()
            try data.write(to: directory.appendingPathComponent("\(imageID).png")!)
            
            return imageID.description
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
