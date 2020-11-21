//
//  PaymentMethodsViewModel.swift
//  PagaMe
//
//  Created by German on 11/20/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum PaymentMethodsStatus {
  case loading, idle, failed
}

class PaymentMethodsViewModel: PaymentFlowManageable {

  private var statusRelay = BehaviorRelay<PaymentMethodsStatus>(value: .idle)
  
  var statusDriver: Driver<PaymentMethodsStatus> {
     statusRelay.asDriver()
   }
  
  private var paymentMethodsRelay = BehaviorRelay<[PaymentMethod]>(value: [])

  var paymentMethodsDriver: Driver<[PaymentMethod]> {
    paymentMethodsRelay.asDriver()
  }
  
  private var selectedMethodRelay = BehaviorRelay<PaymentMethod?>(value: nil)
  
  init() {
    
  }
  
  // MARK: - Public API
  
  func selectPaymentMethod() {
    guard let paymentMethod = selectedMethodRelay.value else { return }
    
    paymentManager.setPaymentMethod(paymentMethod: paymentMethod)
  }
  
  func fetchPaymentMethods() {
    statusRelay.accept(.loading)
    PaymentsAPI.getPaymentMethods(success: { [weak self] methods in
      guard let self = self else { return }
      
      self.paymentMethodsRelay.accept(methods)
      self.statusRelay.accept(.idle)
    }, failure: { error in
      // Debug error
      self.statusRelay.accept(.failed)
    })
  }

}

