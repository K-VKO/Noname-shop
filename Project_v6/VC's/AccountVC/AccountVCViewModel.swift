//
//  AccountVCViewModel.swift
//  Project_v6
//
//  Created by Константин Вороненко on 28.02.22.
//

import Foundation
import FirebaseAuth
import Firebase
import RxSwift
import RxCocoa
import UIKit

protocol AccountVCViewModelProtocol {
    var email: ReplaySubject<String> { get set }
    var image: ReplaySubject<UIImage> { get set }
    
    func getEmail()
    func saveImage(image: UIImage, name: String)
    func tryLoadImage(email: String)
}

final class AccountVCViewModel: AccountVCViewModelProtocol {
    var image = ReplaySubject<UIImage>.create(bufferSize: 1)
    var email = ReplaySubject<String>.create(bufferSize: 1)
    
    func getEmail() {
        if let userEmail = Auth.auth().currentUser?.email {
            email.onNext(userEmail)
            tryLoadImage(email: userEmail)
        }
    }
    
    func saveImage(image: UIImage, name: String) {
        FileManagerService().save(image: image, name: name) { _ in
            print("image saved")
        }
    }
    
    func tryLoadImage(email: String) {
        FileManagerService().loadImage(localName: "\(email).jpg") { grabbedImage in
            if let grabbedImage = grabbedImage {
                self.image.onNext(grabbedImage)
            }
        }
    }
}
