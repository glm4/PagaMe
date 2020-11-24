//
//  SummaryViewModel.swift
//  PagaMe
//
//  Created by German on 11/23/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum SummarySection: Int, CaseIterable {
  case paymentMethod, issuer, installmentOption, amount
  
  var title: String {
    switch self {
    case .paymentMethod:
      return "summary.payment_method_header".localized
    case .issuer:
      return "summary.issuer_header".localized
    case .installmentOption:
      return "summary.installment_header".localized
    case .amount:
      return "summary.amount_header".localized
    }
  }
}

class SummaryViewModel: PaymentFlowManageable, NetworkActivityStatus {
  
  var statusRelay = BehaviorRelay<NetworkStatus>(value: .idle)
  
  private var disposeBag = DisposeBag()
  
  var validOrderDriver: Driver<Bool> {
    Driver.just(paymentManager.validOrder)
  }
  
  init() {
    paymentManager.statusDriver.asObservable()
      .subscribe(onNext: { [weak self] status in
        if status == .placingPayment {
          self?.statusRelay.accept(.loading)
        }
        
        guard case .completed(let result) = status else { return }
        
        let success = result.0 != nil && result.1 == nil
        self?.statusRelay.accept(success ? .idle : .failed)
      }).disposed(by: disposeBag)
  }
  
  // MARK: - Public API
  
  var formattedAmount: String {
    let numberValue = NSDecimalNumber(decimal: paymentManager.orderAmount ?? 0)
    
    return NumberFormatter.currencyFormatter.string(from: numberValue) ?? Currency.current
  }
  
  var itemCount: Int {
    SummarySection.allCases.count
  }
  
  func item(at index: Int) -> SummaryPresentable? {
    switch index {
    case SummarySection.paymentMethod.rawValue:
      return paymentManager.orderPaymentMethod
    case SummarySection.issuer.rawValue:
      return paymentManager.orderIssuer
    case SummarySection.installmentOption.rawValue:
      return paymentManager.orderInstallmentOption
    case SummarySection.amount.rawValue:
      return paymentManager.orderAmount
    default:
      return nil
    }
  }
  
  func confirmPayment() {
    paymentManager.confirmPayment()
  }

}
