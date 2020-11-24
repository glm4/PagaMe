//
//  SuccessfulPaymentController.swift
//  PagaMe
//
//  Created by German on 11/23/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SuccessfulPaymentController: UIViewController, ContinueButtonPresentable {
  
  var disposeBag = DisposeBag()
  
  var buttonTitle: String {
    "success.go_back".localized.uppercased()
  }

  // MARK: - Properties
  
  @IBOutlet weak var continueButton: UIButton!
  
  @IBOutlet weak var headlineLabel: UILabel! {
    didSet {
      headlineLabel.textColor = .brand
      headlineLabel.font = .header
      headlineLabel.text = "success.payment_done".localized
    }
  }
  
  @IBOutlet weak var successIcon: UIImageView!
  
  var validationDriver: Driver<Bool> {
    .just(true)
  }
  
  private var animationsRan = false
  
  // MARK: - Lifecycle Events

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Prevents interactive dismissal on iOS >=13 modals
    if #available(iOS 13.0, *) {
      isModalInPresentation = true
    }
    
    setupUI()
    setupButtonLayoutConstraints()
    setupButtonBindings()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !animationsRan {
      UIView.animate(withDuration: 0.35) { [weak self] in
        guard let self = self else { return }
        
        self.headlineLabel.alpha = 1
        self.headlineLabel.transform = .identity
        
        self.successIcon.alpha = 1
        self.successIcon.transform = .identity
      }
    }
  }
  
  // MARK: - UI
  
  private func setupUI() {
    // Set initial state for animations
    headlineLabel.alpha = 0
    successIcon.alpha = 0
    
    headlineLabel.transform = CGAffineTransform(translationX: 0, y: 100)
    successIcon.transform = CGAffineTransform(translationX: 0, y: -100)
    
    stylizeContinueButton()
  }
   
  func continueButtonTapped() {
    AppNavigator.shared.dismiss(animated: true) {
      AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot)
    }
  }

}
