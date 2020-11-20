//
//  PaymentFlowManageable.swift
//  PagaMe
//
//  Created by German on 11/20/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation
import RxCocoa

/// Conformance to this protocol provides access to a payment manager
internal protocol PaymentFlowManageable {
  
  var paymentManager: PaymentManager { get }
  var paymentStatusDriver: Driver<PaymentManager.Status> { get }
  
}

extension PaymentFlowManageable {
  
  var paymentManager: PaymentManager {
    PaymentManager.shared
  }
  
  var paymentStatusDriver: Driver<PaymentManager.Status> {
    PaymentManager.shared.statusDriver
  }
}
