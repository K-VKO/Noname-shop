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

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var yourAvatarLabel: UILabel!
    
    
    @IBOutlet weak var email: UILabel! {
        didSet {
            viewModel.email.subscribe { [weak self] event in
                self?.email.text = event.element
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
