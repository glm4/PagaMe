//
//  CurrencyPresenter.swift
//  PagaMe
//
//  Created by German on 11/20/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation

internal protocol CurrencyPresenter {
  
  var currencySymbol: String { get }
  var currencyDecimalSeparator: String { get }
  
}

extension CurrencyPresenter {
  
  var currencySymbol: String {
    Currency.current
  }
  
  var currencyDecimalSeparator: String {
    Currency.decimalSeparator
  }
  
}

enum Currency {
  
  static let minimumPayment: Double = 0.5
  static let maximumPayment: Double = 1_000_000
  static let current = Locale.current.currencySymbol ?? "$"
  static let decimalSeparator = Locale.current.decimalSeparator ?? "."
  
}
