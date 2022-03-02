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

protocol AccountVCViewModelProtocol {
    var email: ReplaySubject<String> { get set }
    
    func getEmail()
    func logOut()
}

final class AccountVCViewModel: AccountVCViewModelProtocol {
    var email = ReplaySubject<String>.create(bufferSize: 1)
    
    func getEmail() {
        if let userEmail = Auth.auth().currentUser?.email {
            email.onNext(userEmail)
        }
    }
    
    func logOut() {
        do {
            
        } catch {
            fatalError("error logging out")
        }
        
    }
    
}
