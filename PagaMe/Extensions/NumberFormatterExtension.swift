//
//  NumberFormatterExtension.swift
//  PagaMe
//
//  Created by German on 11/23/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation

extension NumberFormatter {
  
  static let defaultFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .decimal
    formatter.locale = Locale.current
    formatter.maximum = NSNumber(value: Currency.maximumPayment)
    
    formatter.decimalSeparator = Currency.decimalSeparator
    formatter.alwaysShowsDecimalSeparator = false
    formatter.usesGroupingSeparator = false
    formatter.maximumFractionDigits = 2
    
    return formatter
  }()
  
  static let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    formatter.maximum = NSNumber(value: Currency.maximumPayment)
    
    formatter.currencySymbol = Currency.current
    formatter.currencyDecimalSeparator = Currency.decimalSeparator
    formatter.alwaysShowsDecimalSeparator = false
    formatter.usesGroupingSeparator = false
    formatter.maximumFractionDigits = 2
    
    return formatter
  }()
}
