//
//  FileManagerService.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 18.02.22.
//

import UIKit

final class FileManagerService {
    
    private let fileManagerQueue = DispatchQueue(label: "fileManagerQueue", qos: .utility)
    
    func save(image: UIImage, name: String, completion: @escaping (String?) -> Void) {
        fileManagerQueue.async {
            let data = image.jpegData(compressionQuality: 0.1)
            
            do {
                var directoryPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                
                directoryPath.appendPathComponent("\(name).jpg")
                try data?.write(to: directoryPath)
                completion(name + ".jpg")
                print("FileManagerService: \(#function) did save success with localName = \(name)")
            } catch {
                completion(nil)
                print("FileManagerService: \(#function) did failed with error = \(error.localizedDescription)  localName = \(name)")
            }
        }

    }
    
    func loadImage(localName: String?, completion: @escaping (UIImage?) -> Void) {
            fileManagerQueue.async {
                guard let localName = localName else { return }
                do {
                    var directoryPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    directoryPath.appendPathComponent(localName)
                    let data = try Data(contentsOf: directoryPath)
                    
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    } else {
                        completion(nil)
                    }
                } catch {
                    completion(nil)
                }
            }
        }
}
