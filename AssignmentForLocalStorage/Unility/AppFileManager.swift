//
//  AppFileManager.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 17/04/24.
//

import Foundation
import UIKit

class AppFileManager {
    
    static let instance = AppFileManager()
    private let cacheData = NSCache<NSString, UIImage>()
    
    private init() {}
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func save(image: UIImage) -> String? {
        let fileName = UUID().uuidString + ".jpeg"
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
            
            return fileName // ----> Save fileName
        }
        print("Error saving image")
        return nil
    }
    
    func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            let image = UIImage(data: imageData)
            
            return image
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}
