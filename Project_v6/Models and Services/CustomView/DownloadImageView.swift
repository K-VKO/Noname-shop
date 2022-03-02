//
//  DownloadImageView.swift
//  Project_v6
//
//  Created by Константин Вороненко on 2.03.22.
//

import UIKit

final class DownloadImageView: UIImageView {
    
    private var downloadTask: DispatchWorkItem?
    
    func load(_ url: URL?,completion: @escaping (UIImage?) -> Void) {
        guard let url = url else { return }
        
        let downloadTask = DispatchWorkItem(qos: .userInitiated, block: {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                    completion(image)
                }
            }
        })
        DispatchQueue.global(qos: .userInitiated).async(execute: downloadTask)
        self.downloadTask = downloadTask
    }
    
    func cancel() {
        downloadTask?.cancel()
        downloadTask = nil
    }
}
