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

internal final class HomeViewController: UIViewController,
  ActivityIndicatorPresenter,
  ContinueButtonPresentable {
  
  var validationDriver: Driver<Bool> {
    viewModel.validAmountDriver
  }

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
      amountField.font = UIFont.defaultRegular.withSize(40)
      
      amountField.addBorder(color: .brand, weight: 1.5)
      amountField.setRoundBorders(AtomicLayout.defaultCornerRadius)
      
      amountField.keyboardType = .decimalPad
      amountField.delegate = self
    }
  }
  
  @IBOutlet weak var continueButton: UIButton!
  
  var viewModel: HomeViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    amountField.becomeFirstResponder()
    stylizeContinueButton()
    setupLayout()
    setupBindings()
  }
  
  // MARK: - UI

  private func setupLayout() {
    amountLabel.translatesAutoresizingMaskIntoConstraints = false
    amountField.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      // Amount Field
      amountField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      amountField.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: AtomicLayout.defaultMargins
      ),
      amountField.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -AtomicLayout.defaultMargins
      ),
      amountField.heightAnchor.constraint(equalToConstant: Layout.AmountField.height),
      amountField.topAnchor.constraint(
        equalTo: amountLabel.bottomAnchor,
        constant: Layout.AmountField.top
      ),
      
      // Amount Label
      amountLabel.leadingAnchor.constraint(equalTo: amountField.leadingAnchor),
      amountLabel.trailingAnchor.constraint(
        greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -AtomicLayout.defaultMargins
      )
    ])
    
    setupButtonLayoutConstraints()
  }
  
  private func setupBindings() {
    viewModel.formattedAmountDriver
      .drive(amountField.rx.text)
      .disposed(by: disposeBag)

    setupButtonBindings()
    
    viewModel.paymentStatusDriver
      .filter { $0 == .amount }
      .asObservable()
      .subscribe(onNext: {[weak self] _ in
        
      self?.navigateToPaymentMethods()
    }).disposed(by: disposeBag)
  }
  
  private func navigateToPaymentMethods() {
    AppNavigator.shared.navigate(to: HomeRoutes.paymentMethods, with: .push)
  }
}

extension HomeViewController: UITextFieldDelegate {
  
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    if string.isEmpty {
      return true
    }
    
    if string == viewModel.currencyDecimalSeparator {
      return !(textField.text?.contains(viewModel.currencyDecimalSeparator) ?? false) &&
        (textField.text?.contains(viewModel.currencySymbol) ?? false)
    }
    
    if string == viewModel.currencySymbol {
      return !(textField.text?.contains(viewModel.currencySymbol) ?? false)
    }
    
    guard string.hasNumbers else { return false }
    
    let nsString = NSString(string: textField.text ?? "")
    let finalInput = nsString.replacingCharacters(in: range, with: string)
    
    viewModel.amountInputChange(with: finalInput)
    
    return false
  }
  
  // MARK: - ContinueButtonPresentable

  func continueButtonTapped() {
    viewModel.confirmedAmount()
  }
}

enum Layout {
  
  enum AmountField {
    
    static let height: CGFloat = 45
    static let top: CGFloat = 10
    
  }
}
