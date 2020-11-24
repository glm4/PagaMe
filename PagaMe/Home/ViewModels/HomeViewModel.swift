//
//  HomeViewModel.swift
//  PagaMe
//
//  Created by German on 8/3/18.
//  Copyright © 2018 Rootstrap Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: CurrencyPresenter, PaymentFlowManageable {
  
  var formattedAmountDriver: Driver<String> {
    amountRelay.map({ [weak self] value in
      self?.currencyFormatter.string(from: value) ?? ""
    }).asDriver(onErrorJustReturn: "")
  }
  
  var validAmountDriver: Driver<Bool> {
    amountRelay.map({
      $0.doubleValue >= Currency.minimumPayment &&
        $0.doubleValue <= Currency.maximumPayment
    }).asDriver(onErrorJustReturn: false)
  }
  
  private let amountRelay: BehaviorRelay<NSNumber> = BehaviorRelay<NSNumber>(
    value: 0
  )
  
  private var numberFormatter: NumberFormatter {
    NumberFormatter.defaultFormatter
  }
  
  private var currencyFormatter: NumberFormatter {
    NumberFormatter.currencyFormatter
  }
  
  // MARK: - Public API
  
  func amountInputChange(with text: String) {
    guard let number = numberFormatter.number(from: text) else {
      if text.isEmpty {
        amountRelay.accept(0)
      }
      return
    }
    
    amountRelay.accept(number)
  }
  
  func confirmedAmount() {
    paymentManager.setAmount(amount: amountRelay.value.doubleValue)
  }

}
