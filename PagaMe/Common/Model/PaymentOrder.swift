//
//  PaymentOrder.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation

struct PaymentOrder {
  
  var amount: Decimal?
  var paymentMethod: PaymentMethod?
  var issuer: Issuer?
  var installmentOption: PayerCost?
  
  var validOrder: Bool {
    amount != nil &&
      paymentMethod != nil &&
      issuer != nil &&
      installmentOption != nil
  }
  
}
