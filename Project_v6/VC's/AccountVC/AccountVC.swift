//
//  AccountVC.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 15.02.22.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

final class AccountVC: UIViewController {
    private var viewModel: AccountVCViewModelProtocol = AccountVCViewModel()
    private var disposeBag = DisposeBag()

    @IBOutlet weak var avatarImage: UIImageView! {
        didSet {
            //MARK: in case no image was set, loading from DB
            viewModel.image.subscribe { [weak self] event in
                if let image = event.element {
                    self?.avatarImage.image = image
                    self?.yourAvatarLabel.isHidden = true
                }
            }.disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var yourAvatarLabel: UILabel!
    @IBAction func editImageDidTap(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self // new
        present(imagePickerVC, animated: true)
    }
    
    
    @IBOutlet weak var email: UILabel! {
        didSet {
            viewModel.email.subscribe { [weak self] event in
                self?.email.text = event.element
                if let email = event.element {
                    self?.viewModel.tryLoadImage(email: email)
                }
            }.disposed(by: disposeBag)
        }
    }
    @IBAction func logOutDidTap(_ sender: Any) {
        try? Auth.auth().signOut()
        
        self.navigationController?.viewControllers.removeAll()
        let vc = AuthVC.loadFromNib()
        
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getEmail()
    }
}




extension AccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            avatarImage.image = image
            if let email = email.text {
                viewModel.saveImage(image: image, name: email)
            }
            yourAvatarLabel.isHidden = true
        }
    }
    
}
