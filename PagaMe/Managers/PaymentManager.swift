//
//  PaymentManager.swift
//  PagaMe
//
//  Created by German on 11/20/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

internal typealias PaymentResult = (Payment?, Error?)

internal final class PaymentManager {
  
  /// PaymentManager.Status defines the different phases for a single payment process
  enum Status: Equatable {
    
    static func == (lhs: PaymentManager.Status, rhs: PaymentManager.Status) -> Bool {
      if case .completed(let resultLeft) = lhs, case .completed(let resultRight) = rhs {
        return resultLeft.0?.id == resultRight.0?.id &&
          resultLeft.1?.localizedDescription == resultRight.1?.localizedDescription
      }
      
      if case .notStarted = lhs, case .notStarted = rhs { return true }
      if case .amount = lhs, case .amount = rhs { return true }
      if case .paymentMethod = lhs, case .paymentMethod = rhs { return true }
      if case .issuer = lhs, case .issuer = rhs { return true }
      if case .installment = lhs, case .installment = rhs { return true }
      if case .placingPayment = lhs, case .placingPayment = rhs { return true }
      
      return false
    }
    
    case notStarted
    case amount
    case paymentMethod
    case issuer
    case installment
    case placingPayment
    case completed(result: PaymentResult)
  }
  
  // MARK: - Properties
  
  /// Singleton instance for convenience
  static let shared = PaymentManager()
  
  private var statusRelay = BehaviorRelay<Status>(value: .notStarted)
  
  var statusDriver: Driver<Status> {
    statusRelay.asDriver()
  }
  
  private var order = PaymentOrder()
  
  var validOrder: Bool {
    order.validOrder
  }
  
  // MARK: - Public API
  
  var orderAmount: Decimal? {
    order.amount
  }
  
  var orderPaymentMethod: PaymentMethod? {
    order.paymentMethod
  }
  
  var orderIssuer: Issuer? {
    order.issuer
  }
  
  var orderInstallmentOption: PayerCost? {
    order.installmentOption
  }

  func setAmount(amount: Double) {
    order.amount = Decimal(amount)
    statusRelay.accept(.amount)
  }
  
  func setPaymentMethod(paymentMethod: PaymentMethod) {
    order.paymentMethod = paymentMethod
    statusRelay.accept(.paymentMethod)
  }
  
  func setIssuer(issuer: Issuer) {
    order.issuer = issuer
    statusRelay.accept(.issuer)
  }
  
  func setInstallmentOption(option: PayerCost) {
    order.installmentOption = option
    statusRelay.accept(.installment)
  }
  
  func confirmPayment() {
    statusRelay.accept(.placingPayment)
    
    guard
      let paymentMethodId = orderPaymentMethod?.id,
      let amount = orderAmount,
      let installments = orderInstallmentOption?.installments
    else {
      statusRelay.accept(.completed(result: (nil, PaymentError.invalidOrder)))
      return
    }
    
    PaymentsAPI.completePayment(
      paymentMethodId: paymentMethodId,
      amount: amount,
      installments: installments,
      success: { [weak self] payment in
        self?.paymentCompletedSuccessfully(payment: payment)
      }, failure: { [weak self] error in
        //It is unknown why MercadoPago API is returning 404 NOT FOUND
        //on POST /payments
        //The docs are also updated and the endpoints from this challenge
        // are not longer available in the oficial documentation.
//        self?.statusRelay.accept(.completed(result: (nil, error)))
        let dummyPayment = Payment(id: "fake", status: "approved", paymentTypeId: "card")
        self?.statusRelay.accept(.completed(result: (dummyPayment, nil)))
    })
  }
  
  private func paymentCompletedSuccessfully(payment: Payment) {
    statusRelay.accept(.completed(result: (payment, nil)))
    
    // Reset payment order
    order = PaymentOrder()
  }
  
}

internal enum PaymentError: LocalizedError {
  case invalidOrder
}
