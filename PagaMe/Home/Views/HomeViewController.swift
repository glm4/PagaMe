//
//  HomeViewController.swift
//  PagaMe
//
//  Created by Rootstrap on 5/23/17.
//  Copyright © 2017 Rootstrap Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, ActivityIndicatorPresenter {

  let activityIndicator = UIActivityIndicatorView()
  
  // MARK: - Outlets
  
  @IBOutlet weak var welcomeLabel: UILabel! {
    didSet {
      welcomeLabel.textColor = .brand
      welcomeLabel.font = .header
      welcomeLabel.text = "home.welcome_message".localized
    }
  }
  
  @IBOutlet weak var amountLabel: UILabel! {
    didSet {
      amountLabel.text = "home.amount_instructions".localized
      
      amountLabel.numberOfLines = 2
      amountLabel.font = .defaultRegular
      amountLabel.textColor = .body
    }
  }
    
  @IBOutlet weak var amountField: UITextField! {
    didSet {
      amountField.tintColor = .body
      amountField.textColor = .body
      amountField.font = .defaultRegular
      
      amountField.addBorder(color: .brand, weight: 1.5)
      amountField.setRoundBorders(Layout.AmountField.cornerRadius)
      
      amountField.delegate = self
    }
  }
  
  @IBOutlet weak var continueButton: UIButton! {
    didSet {
      continueButton.applyDefaultStyle()
    }
  }
  
  var viewModel: HomeViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupLayout()
    setupBindings()
  }
  
  // MARK: - UI

  private func setupLayout() {
    amountLabel.translatesAutoresizingMaskIntoConstraints = false
    amountField.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      amountField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      amountField.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: Layout.horizontalMargins
      ),
      amountField.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -Layout.horizontalMargins
      ),
      amountField.heightAnchor.constraint(equalToConstant: Layout.AmountField.height),
      
      amountLabel.leadingAnchor.constraint(equalTo: amountField.leadingAnchor),
      amountLabel.trailingAnchor.constraint(
        greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -Layout.horizontalMargins
      ),
      amountField.topAnchor.constraint(
        equalTo: amountLabel.bottomAnchor,
        constant: Layout.AmountField.top
      )
    ])
  }
  
  private func setupBindings() {
    viewModel.formattedAmountDriver
      .drive(amountField.rx.text)
      .disposed(by: disposeBag)
  }
}

extension HomeViewController: UITextFieldDelegate {
  
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    
    let nsString = NSString(string: textField.text ?? "")
    let finalInput = nsString.replacingCharacters(in: range, with: string)
    
    viewModel.amountInputChange(with: finalInput)
    
    return false
  }
}

enum Layout {
  
  static let horizontalMargins: CGFloat = 16
  
  enum AmountField {
    
    static let height: CGFloat = 30
    static let top: CGFloat = 10
    
    static let cornerRadius: CGFloat = 4
    
  }
}
