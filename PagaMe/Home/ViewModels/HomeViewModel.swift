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
  
  private let formatter = NumberFormatter()
  
  var formattedAmountDriver: Driver<String> {
    amountRelay.map({ [weak self] value in
      self?.formatter.string(from: NSNumber(value: value)) ?? ""
    }).asDriver(onErrorJustReturn: "")
  }
  
  var amountDriver: Driver<Double> {
    amountRelay.asDriver()
  }
  
  var validAmountDriver: Driver<Bool> {
    amountRelay.map({
      $0 >= Currency.minimumPayment && $0 <= Currency.maximumPayment
    }).asDriver(onErrorJustReturn: false)
  }
  
  private let amountRelay: BehaviorRelay<Double> = BehaviorRelay<Double>(
    value: 0
  )
  
  init() {
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    formatter.maximum = NSNumber(value: Currency.maximumPayment)
    
    formatter.currencySymbol = Currency.current
    formatter.currencyDecimalSeparator = Currency.decimalSeparator
    formatter.alwaysShowsDecimalSeparator = false
    formatter.usesGroupingSeparator = false
    formatter.maximumFractionDigits = 2
  }
  
  // MARK: - Public API
  
  func amountInputChange(with text: String) {
    guard let number = formatter.number(from: text) else {
      return
    }
    amountRelay.accept(number.doubleValue)
  }
  
  func confirmedAmount() {
    paymentManager.setAmount(amount: amountRelay.value)
  }

}
