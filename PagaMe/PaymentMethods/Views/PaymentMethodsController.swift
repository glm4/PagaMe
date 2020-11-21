//
//  PaymentMethodsControllerViewController.swift
//  PagaMe
//
//  Created by German on 11/20/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

internal final class PaymentMethodsController: UIViewController,
  ContinueButtonPresentable, ActivityIndicatorPresenter {
  
  lazy var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView()
    
    indicator.hidesWhenStopped = true
    indicator.color = .brand
    
    return indicator
  }()
  
  var validationDriver: Driver<Bool> {
    //TODO: Update with viewModel
    Driver<Bool>.just(true)
  }
  
  var viewModel: PaymentMethodsViewModel!
  private(set) var disposeBag = DisposeBag()
  
  // MARK: - Properties

  @IBOutlet weak var continueButton: UIButton!
  
  @IBOutlet weak var instructionLabel: UILabel! {
    didSet {
      instructionLabel.text = "payment_methods.instructions".localized
      
      instructionLabel.numberOfLines = 2
      instructionLabel.font = .defaultRegular
      instructionLabel.textColor = .body
    }
  }
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.separatorStyle = .none
    }
  }
  
  // MARK: - Lifecycle Events

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.backgroundColor = .black
    viewModel.fetchPaymentMethods()
    stylizeContinueButton()
    setupLayout()
    setupBindings()
  }
  
  // MARK: - UI

  private func setupLayout() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    instructionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      //Instructions Label
      instructionLabel.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: AtomicLayout.horizontalMargins
      ),
      instructionLabel.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: AtomicLayout.horizontalMargins
      ),
      instructionLabel.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -AtomicLayout.horizontalMargins
      ),
      
      // Table View
      tableView.topAnchor.constraint(
        equalTo: instructionLabel.bottomAnchor,
        constant: AtomicLayout.horizontalMargins
      ),
      tableView.bottomAnchor.constraint(
        equalTo: continueButton.topAnchor,
        constant: -AtomicLayout.horizontalMargins
      ),
      tableView.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: -AtomicLayout.horizontalMargins
      ),
      tableView.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: AtomicLayout.horizontalMargins
      )
    ])
    
    setupButtonLayoutConstraints()
  }
  
  private func setupBindings() {
    setupButtonBindings()
    
    viewModel.statusDriver
      .map { $0 == .loading }
      .drive(activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)
  }

  func continueButtonTapped() {
    //TODO:
  }
}
