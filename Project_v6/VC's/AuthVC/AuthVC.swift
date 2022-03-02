//
//  LoginVC.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 9.02.22.
//

import UIKit
import Lottie
import FirebaseAuth

enum ScreenType {
    case login
    case signUp
}

final class AuthVC: UIViewController {
    private var viewModel: AuthViewModelProtocol = AuthViewModel()
    
    private var screenType: ScreenType = .login

    @IBOutlet weak var button: UIButton! {
        didSet {
            button.roundCorners()
        }
    }
    @IBOutlet weak var animationView: AnimationView! {
        didSet {
            animationView.loopMode = .loop
            animationView.animationSpeed = 0.5
            animationView.contentMode = .scaleAspectFill
            animationView.play()
        }
    }
    @IBOutlet weak var loginAnimation: AnimationView! {
        didSet {
            loginAnimation.loopMode = .loop
            loginAnimation.animationSpeed = 1
            loginAnimation.contentMode = .scaleAspectFill
            loginAnimation.play()
        }
    }
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var needSignUpBlock: UIStackView!
    
    @IBOutlet weak var emailCheckIcon: UIImageView!
    @IBOutlet weak var passwordCheckIcon: UIImageView! {
        didSet {
            emailCheckIcon.isHidden = true
            passwordCheckIcon.isHidden = true
        }
    }
    
    //Text fields
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField! {
        didSet {
            email.delegate = self
            password.delegate = self
        }
    }
    
    
    //Form block Constraints
    @IBOutlet weak var formCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var formBottomConstraint: NSLayoutConstraint!
    
    //Keyboard Actions
    private func addObserversForKeyborard() {
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)

       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
       let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        loginAnimation.isHidden = true
        formBottomConstraint.constant = keyboardHeight + 10
        formCenterConstraint.priority = UILayoutPriority(249)
        self.view.layoutIfNeeded()
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        loginAnimation.isHidden = false
        formBottomConstraint.constant = 0
        formCenterConstraint.priority = UILayoutPriority(1000)
        self.view.layoutIfNeeded()
    }
    
    //In case of user dosn't have an account
    @IBAction func signUpDidTap(_ sender: Any) {
        let vc = AuthVC.loadFromNib()
        vc.screenType = .signUp
        navigationController?.pushViewController(vc, animated: true)
    }

    
    //Main button
    @IBAction func buttonDidTap(_ sender: Any) {
        guard let email = email.text, !email.isEmpty,
              let password = password.text, !password.isEmpty else {
                  print("missing fields")
                  return
              }
        
        if self.screenType == .login {
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] result, error in
                
                guard error == nil else {
                    self?.showAlert(title: "Error", message: "User does not exist or password is incorrect")
                    return
                }
                

                self?.navigationController?.viewControllers.removeAll()
                let vc = TabBar.loadFromNib()
                
                
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
        
        else if screenType == .signUp {
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {[weak self] result, error in
                
                guard error == nil else {
                    print("ACCOUNT ALREADT EXISTS")
                    return
                }
                print("account created")
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
    }
    
    private func setupView() {
        if self.screenType == .signUp {
            loginAnimation.animation = Animation.named("form-animation-new")
            loginAnimation.contentMode = .scaleAspectFill
            loginAnimation.animationSpeed = 0.3
            loginAnimation.play()
            screenTitle.text = "Registration"
            button.setTitle("Sign Up", for: .normal)
            needSignUpBlock.isHidden = true
        }
        
        self.hideKeyboardWhenTappedAround()
        addObserversForKeyborard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginAnimation.play()
        animationView.play()
    }
}

extension AuthVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            textField.resignFirstResponder()
            password.becomeFirstResponder()
        } else if textField == password {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.screenType == .signUp {
            if textField == email {
                emailCheckIcon.isHidden = false
                if viewModel.validateEmail(email: textField.text ?? "") == true {
                    emailCheckIcon.image = UIImage(systemName: "checkmark.square.fill")
                    emailCheckIcon.tintColor = UIColor.systemGreen
                } else {
                    emailCheckIcon.image = UIImage(systemName: "xmark.app.fill")
                    emailCheckIcon.tintColor = UIColor.systemRed
                }
            } else if textField == password {
                passwordCheckIcon.isHidden = false
                if viewModel.validatePassword(password: textField.text ?? "") == true {
                    passwordCheckIcon.image = UIImage(systemName: "checkmark.square.fill")
                    passwordCheckIcon.tintColor = UIColor.systemGreen
                } else {
                    passwordCheckIcon.image = UIImage(systemName: "xmark.app.fill")
                    passwordCheckIcon.tintColor = UIColor.systemRed
                }
            }
        }
    }
}
