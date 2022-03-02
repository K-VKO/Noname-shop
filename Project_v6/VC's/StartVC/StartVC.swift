//
//  StartVC.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 9.02.22.
//

import UIKit
import Lottie
import Firebase

final class StartVC: UIViewController {
    @IBOutlet var animationView: AnimationView! {
        didSet {
            animationView.contentMode = .scaleAspectFill
            animationView.loopMode = .loop
            animationView.animationSpeed = 1
            animationView.play()
        }
    }
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.roundCorners()
        }
    }
    @IBAction func getStartedTapped() {
       let vc = AuthVCNavigationController(rootViewController: AuthVC.loadFromNib())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
