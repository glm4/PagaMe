//
//  ContinueButtonPresentable.swift
//  PagaMe
//
//  Created by German on 11/20/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

internal protocol ContinueButtonPresentable: RxDisposable {
  var continueButton: UIButton! { get }
  var buttonTitle: String { get }
  var validationDriver: Driver<Bool> { get }
  
  func setupButtonLayoutConstraints()
  func setupButtonBindings()
  func continueButtonTapped()
  func stylizeContinueButton()
}

extension ContinueButtonPresentable where Self: UIViewController {
  
  var buttonTitle: String {
    "continue_button.default".localized.uppercased()
  }
  
  func setupButtonLayoutConstraints() {
    continueButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      continueButton.heightAnchor.constraint(
        equalToConstant: ContinueButton.height
      ),
      continueButton.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: AtomicLayout.defaultMargins
      ),
      continueButton.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -AtomicLayout.defaultMargins
      ),
      continueButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -ContinueButton.bottom)
    ])
  }
  
  func setupButtonBindings() {
    validationDriver
      .drive(continueButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    validationDriver
      .map({ $0 ? 1 : 0.75 })
      .drive(continueButton.rx.alpha)
      .disposed(by: disposeBag)
    
    continueButton.rx.tap.bind { [weak self] in
      self?.continueButtonTapped()
    }.disposed(by: disposeBag)
  }
  
  func stylizeContinueButton() {
    continueButton.setTitleColor(.body, for: .normal)
    continueButton.setTitle(buttonTitle, for: .normal)
    
    continueButton.applyDefaultStyle()
  }
  
}
