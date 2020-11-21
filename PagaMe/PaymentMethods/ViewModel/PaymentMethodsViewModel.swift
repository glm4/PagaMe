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

class PaymentMethodsViewModel: PaymentFlowManageable, NetworkActivityStatus {
  
  // MARK: - Properties
  
  private(set) var statusRelay: BehaviorRelay<NetworkStatus> = BehaviorRelay<NetworkStatus>(
    value: .idle
  )
  
  private var paymentMethodsRelay = BehaviorRelay<[PaymentMethod]>(value: [])
  
  private var paymentMethods: [PaymentMethod] {
    paymentMethodsRelay.value
  }

  var paymentMethodsDriver: Driver<[PaymentMethod]> {
    paymentMethodsRelay.asDriver()
  }
  
  private var selectedMethodRelay = BehaviorRelay<PaymentMethod?>(value: nil)
  
  var selectedMethodDriver: Driver<PaymentMethod?> {
    selectedMethodRelay.asDriver()
  }
  
  // MARK: - Public API
  
  func selectPaymentMethod(atIndex index: Int) {
    guard index >= 0 && index < paymentMethods.count else { return }
    
    selectedMethodRelay.accept(paymentMethodsRelay.value[index])
  }
  
  func confirmPaymentMethod() {
    guard let selectedMethod = selectedMethodRelay.value else { return }
    
    paymentManager.setPaymentMethod(paymentMethod: selectedMethod)
  }
  
  func fetchPaymentMethods() {
    statusRelay.accept(.loading)
    PaymentsAPI.getPaymentMethods(success: { [weak self] methods in
      guard let self = self else { return }
      
      self.paymentMethodsRelay.accept(methods)
      self.statusRelay.accept(.idle)
      
    }, failure: { _ in
      // Debug error
      self.statusRelay.accept(.failed)
    })
  }

}
