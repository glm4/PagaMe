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

class HomeViewModel {
  
  private let formatter = NumberFormatter()
  
  var formattedAmountDriver: Driver<String> {
    amountRelay.asDriver()
  }
  
  var amountRelay: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
  
  func amountInputChange(with text: String) {
    let formattedString = formatter.string(for: text) ?? "$"
    
    amountRelay.accept(formattedString)
  }
  
  init() {
    formatter.currencySymbol = "$"
  }
}
