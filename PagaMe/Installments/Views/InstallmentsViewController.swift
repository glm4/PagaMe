//
//  InstallmentsViewController.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InstallmentsViewController: ListViewController {
  
  // MARK: - Properties
  
  override var instructionsLocalizationKey: String {
    "installments.instructions"
  }
  
  override var validationDriver: Driver<Bool> {
    viewModel.selectedInstallmentOptionDriver.map { $0 != nil }
  }
  
  override var statusDriver: Driver<NetworkStatus> {
    viewModel.statusDriver
  }
  
  var viewModel: InstallmentsViewModel!
  
  // MARK: - Lifecycle Events

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.fetchInstallments()
  }
  
  // MARK: - UI

  override func setupUI() {
    super.setupUI()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.sectionHeaderHeight = InstallmentSectionHeaderView.defaultHeight
    
    let cellNib = UINib(
      nibName: InstallmentTableViewCell.reuseIdentifier,
      bundle: nil
    )
    tableView.register(
      cellNib,
      forCellReuseIdentifier: InstallmentTableViewCell.reuseIdentifier
    )
    
    tableView.register(
      InstallmentSectionHeaderView.self,
      forHeaderFooterViewReuseIdentifier: InstallmentSectionHeaderView.reuseIdentifier
    )
  }
  
  override func setupBindings() {
    super.setupBindings()
    
    viewModel.installmentsDriver.asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.tableView.reloadData()
      }).disposed(by: disposeBag)
    
    tableView.rx.itemSelected.subscribe({ [weak self] event in
      guard let indexPath = event.element else { return }
      
      self?.viewModel.selectInstallment(at: indexPath)
    }).disposed(by: disposeBag)
    
    viewModel.paymentStatusDriver
      .filter { $0 == .installment }
      .asObservable()
      .subscribe(onNext: {[weak self] _ in
        
      self?.navigateConfirmation()
    }).disposed(by: disposeBag)
    
  }
  
  override func continueButtonTapped() {
//    viewModel.confirmIssuer()
  }
  
  func navigateConfirmation() {
    //TODO
  }

}

extension InstallmentsViewController: RxTableViewDataSourceType {

  typealias Element = Installment
  
  func tableView(_ tableView: UITableView, observedEvent: Event<Installment>) {
    
  }
  

}

extension InstallmentsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.installmentCount
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.installmentOptionsCount(at: section)
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: InstallmentTableViewCell.reuseIdentifier,
      for: indexPath
    )
    
    if
      let presentable = viewModel.installmentOptionPresentable(at: indexPath),
      let cell = cell as? InstallmentTableViewCell
    {
      cell.configure(with: presentable)
    }
    
    return cell
  }

}

extension InstallmentsViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    
    if
      let header = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: InstallmentSectionHeaderView.reuseIdentifier
      ) as? InstallmentSectionHeaderView,
      let presentable = viewModel.installmentPresentable(at: section)
    {
      header.configure(with: presentable)
      return header
    }
    
    return nil
  }
  
}
