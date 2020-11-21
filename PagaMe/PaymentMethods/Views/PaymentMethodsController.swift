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
    viewModel.selectedMethodDriver.map({ $0 != nil })
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
//      tableView.cell
    }
  }
  
  // MARK: - Lifecycle Events

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    setupLayout()
    setupBindings()
    
    viewModel.fetchPaymentMethods()
  }
  
  // MARK: - UI
  
  private func setupUI() {
    let cellNib = UINib(nibName: PaymentMethodViewCell.reuseIdentifier, bundle: nil)
    tableView.register(
      cellNib,
      forCellReuseIdentifier: PaymentMethodViewCell.reuseIdentifier
    )
    
    stylizeContinueButton()
  }

  private func setupLayout() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    instructionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      //Instructions Label
      instructionLabel.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: AtomicLayout.defaultMargins
      ),
      instructionLabel.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: AtomicLayout.defaultMargins
      ),
      instructionLabel.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -AtomicLayout.defaultMargins
      ),
      
      // Table View
      tableView.topAnchor.constraint(
        equalTo: instructionLabel.bottomAnchor,
        constant: AtomicLayout.defaultMargins
      ),
      tableView.bottomAnchor.constraint(
        equalTo: continueButton.topAnchor,
        constant: -AtomicLayout.defaultMargins
      ),
      tableView.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: -AtomicLayout.defaultMargins
      ),
      tableView.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: AtomicLayout.defaultMargins
      )
    ])
    
    setupButtonLayoutConstraints()
  }
  
  private func setupBindings() {
    setupButtonBindings()
    
    viewModel.statusDriver
      .map { $0 == .loading }
      .drive(onNext: { [weak self] isLoading in
        self?.showActivityIndicator(isLoading)
      }).disposed(by: disposeBag)
    
    viewModel.paymentMethodsDriver
      .asObservable()
      .bind(to: tableView.rx.items(
        cellIdentifier: PaymentMethodViewCell.reuseIdentifier,
        cellType: PaymentMethodViewCell.self
      )) { _, method, cell in
        
        cell.selectionStyle = .none
        cell.configure(with: method)
      }.disposed(by: disposeBag)
    
    tableView.rx.itemSelected.subscribe({ [weak self] event in
      guard let indexPath = event.element?.row else { return }
      
      self?.viewModel.selectPaymentMethod(atIndex: indexPath)
    }).disposed(by: disposeBag)
  }

  func continueButtonTapped() {
    //TODO:
  }
}
