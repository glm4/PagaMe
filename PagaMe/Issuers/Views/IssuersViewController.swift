//
//  IssuersViewController.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IssuersViewController: ListViewController {

  // MARK: - Properties
  
  override var instructionsLocalizationKey: String {
    "issuers.instructions"
  }
  
  override var validationDriver: Driver<Bool> {
    viewModel.selectedIssuerDriver.map({ $0 != nil })
  }
  
  override var statusDriver: Driver<NetworkStatus> {
    viewModel.statusDriver
  }
  
  var viewModel: CardIssuersViewModel!
  
  // MARK: - Lifecycle Events

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.fetchCardIssuers()
  }
  
  // MARK: - UI

  override func setupUI() {
    super.setupUI()
    
    let cellNib = UINib(nibName: DetailsViewCell.reusableNibName, bundle: nil)
    tableView.register(
      cellNib,
      forCellReuseIdentifier: IssuerDetailViewCell.reuseIdentifier
    )
  }
  
  override func setupBindings() {
    super.setupBindings()
    
    viewModel.cardIssuersDriver
      .asObservable()
      .bind(to: tableView.rx.items(
        cellIdentifier: IssuerDetailViewCell.reuseIdentifier,
        cellType: DetailsViewCell.self
      )) { _, issuer, cell in
        
        cell.selectionStyle = .none
        cell.configure(with: issuer)
      }.disposed(by: disposeBag)
    
    tableView.rx.itemSelected.subscribe({ [weak self] event in
      guard let index = event.element?.row else { return }
      
      self?.viewModel.selectIssuer(atIndex: index)
    }).disposed(by: disposeBag)
    
    viewModel.paymentStatusDriver
      .filter { $0 == .issuer }
      .asObservable()
      .subscribe(onNext: {[weak self] _ in
        
      self?.navigateToInstallments()
    }).disposed(by: disposeBag)
    
  }
  
  override func continueButtonTapped() {
    viewModel.confirmIssuer()
  }
  
  func navigateToInstallments() {
    AppNavigator.shared.navigate(to: HomeRoutes.installments, with: .push)
  }
  
}
