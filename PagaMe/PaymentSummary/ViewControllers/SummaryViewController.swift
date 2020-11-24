//
//  SummaryViewController.swift
//  PagaMe
//
//  Created by German on 11/23/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SummaryViewController: ListViewController {

  var viewModel: SummaryViewModel!
    
  override var instructionsLocalizationKey: String {
    "summary.headline"
  }

  // MARK: - UI

  override func setupUI() {
    super.setupUI()
    stylizeInstructionsLabel()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.rowHeight = UITableView.automaticDimension
    
    for section in SummarySection.allCases {
      guard let item = viewModel.item(at: section.rawValue) else {
        continue
      }
      
      if let nibName = item.reusableNibName {
        let cellNib = UINib(nibName: nibName, bundle: nil)
        tableView.register(
          cellNib,
          forCellReuseIdentifier: item.reuseIdentifier
        )
      } else {
        tableView.register(
          item.cellClassToRegister,
          forCellReuseIdentifier: item.reuseIdentifier
        )
      }
    }
    
    continueButton.setTitle(
      "summary.confirmation_button".localized.uppercased(),
      for: .normal
    )
  }
  
  private func stylizeInstructionsLabel() {
    instructionLabel.textColor = .brand
    instructionLabel.font = .header
  }
  
  override func setupBindings() {
    super.setupBindings()

    viewModel.paymentStatusDriver
      .filter { status in
        if case .completed(let result) = status {
          return result.0 && result.1 == nil
        }
        
        return false
      }
      .asObservable()
      .subscribe(onNext: {[weak self] _ in
        
      self?.proceedToConfirmPayment()
    }).disposed(by: disposeBag)
    
  }
  
  private func proceedToConfirmPayment() {
    AppNavigator.shared.navigate(to: HomeRoutes.success, with: .modal)
  }
  
  override func continueButtonTapped() {
    viewModel.confirmPayment()
  }

}

extension SummaryViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.itemCount
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    
    guard let item = viewModel.item(at: indexPath.section) else {
      fatalError("Presentable item not found")
    }
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: item.reuseIdentifier,
      for: indexPath
    )
    
    //swiftlint:disable force_cast
    
    //Force cast rule disabled since the pattern match will ensure success
    switch item {
    case is PaymentMethodPresentable:
      return paymentMethodCell(cell, with: item as! PaymentMethodPresentable)
    case is CardIssuerPresentable:
      return issuerCell(cell, with: item as! CardIssuerPresentable)
    case is InstallmentPayerCostPresentable:
      return installmentOptionCell(cell, with: item as! InstallmentPayerCostPresentable)
    case is AmountRepresentable:
      return amountCell(cell)
    default:
      fatalError("Unexpected summary item time.")
    }
    //swiftlint:enable force_cast
  }
  
  private func issuerCell(
    _ cell: UITableViewCell,
    with presentable: CardIssuerPresentable
  ) -> UITableViewCell {
    if let cell = cell as? DetailsViewCell {
      cell.configure(with: presentable)
    }
    
    return cell
  }
  
  private func paymentMethodCell(
    _ cell: UITableViewCell,
    with presentable: PaymentMethodPresentable
  ) -> UITableViewCell {
    if let cell = cell as? DetailsViewCell {
      cell.configure(with: presentable)
    }
    
    return cell
  }
  
  private func installmentOptionCell(
    _ cell: UITableViewCell,
    with presentable: InstallmentPayerCostPresentable
  ) -> UITableViewCell {
    if let cell = cell as? InstallmentTableViewCell {
      cell.configure(with: presentable)
    }
    
    return cell
  }
  
  private func amountCell(_ cell: UITableViewCell) -> UITableViewCell {
    if let cell = cell as? SummaryAmountViewCell {
      cell.configure(with: viewModel.formattedAmount)
    }
    
    return cell
  }
  
}

extension SummaryViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    
    guard
      let summarySection = SummarySection(rawValue: section),
      viewModel.item(at: section) != nil
    else {
      return nil
    }
    
    let containerView = UIView(
      frame: CGRect(
        origin: .zero,
        size: CGSize(width: tableView.frame.width, height: Layout.sectionHeight)
      )
    )
    
    let label = UILabel(frame: .zero)
    containerView.addSubview(label)
    label.embedInSuperView()
    
    label.text = summarySection.title
    label.font = .defaultSemibold
    
    return containerView
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    Layout.sectionHeight
  }
}

fileprivate extension SummaryViewController {
  
  enum Layout {
    
    static let sectionHeight: CGFloat = 30
    
  }
  
}
