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

internal final class PaymentMethodsController: ListViewController {
  
  override var validationDriver: Driver<Bool> {
    viewModel.selectedMethodDriver.map({ $0 != nil })
  }
  
  override var statusDriver: Driver<NetworkStatus> {
    viewModel.statusDriver
  }
  
  var viewModel: PaymentMethodsViewModel!

  override var instructionsLocalizationKey: String {
    "payment_methods.instructions"
  }
  
  // MARK: - Lifecycle Events

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.fetchPaymentMethods()
  }
  
  // MARK: - UI
  
  override func setupUI() {
    super.setupUI()
    
    let cellNib = UINib(nibName: DetailsViewCell.reusableNibName, bundle: nil)
    tableView.register(
      cellNib,
      forCellReuseIdentifier: PaymentMethodViewCell.reuseIdentifier
    )
  }
  
  override func setupBindings() {
    super.setupBindings()
    
    viewModel.paymentMethodsDriver
      .asObservable()
      .bind(to: tableView.rx.items(
        cellIdentifier: PaymentMethodViewCell.reuseIdentifier,
        cellType: DetailsViewCell.self
      )) { _, method, cell in
        
        cell.selectionStyle = .none
        cell.configure(with: method)
      }.disposed(by: disposeBag)
    
    tableView.rx.itemSelected.subscribe({ [weak self] event in
      guard let indexPath = event.element?.row else { return }
      
      self?.viewModel.selectPaymentMethod(atIndex: indexPath)
    }).disposed(by: disposeBag)
    
    viewModel.paymentStatusDriver
      .filter { $0 == .paymentMethod }
      .asObservable()
      .subscribe(onNext: {[weak self] _ in
        
      self?.navigateToCardIssuers()
    }).disposed(by: disposeBag)
  }

  override func continueButtonTapped() {
    viewModel.confirmPaymentMethod()
  }
  
  private func navigateToCardIssuers() {
    AppNavigator.shared.navigate(to: HomeRoutes.cardIssuers, with: .push)
  }
}
