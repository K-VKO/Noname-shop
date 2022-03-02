//
//  AuthViewModel.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 9.02.22.
//

import Foundation
import Firebase

protocol AuthViewModelProtocol {
    func validateEmail(email: String) -> Bool
    func validatePassword(password: String) -> Bool
}

final class AuthViewModel: AuthViewModelProtocol {
    func validateEmail(email: String) -> Bool {
        return Validator().isValidEmailAddress(emailAddressString: email)
    }
    
    func validatePassword(password: String) -> Bool {
        return Validator().isValidPassword(password: password)
    }
    
}
