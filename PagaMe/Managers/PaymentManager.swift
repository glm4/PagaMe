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

internal final class PaymentManager {
  
  /// PaymentManager.Status defines the different phases for a single payment process
  enum Status: Equatable {
    
    static func == (lhs: PaymentManager.Status, rhs: PaymentManager.Status) -> Bool {
      if case .completed(let resultLeft) = lhs, case .completed(let resultRight) = rhs {
        return
          resultLeft.0 == resultRight.0 &&
          resultLeft.1.localizedDescription == resultRight.1.localizedDescription
      }
      
      if case .notStarted = lhs, case .notStarted = rhs { return true }
      if case .amount = lhs, case .amount = rhs { return true }
      if case .paymentMethod = lhs, case .paymentMethod = rhs { return true }
      if case .issuer = lhs, case .issuer = rhs { return true }
      if case .installment = lhs, case .installment = rhs { return true }
      if case .summary = lhs, case .summary = rhs { return true }
      
      return false
    }
    
    case notStarted
    case amount
    case paymentMethod
    case issuer
    case installment
    case summary
    case completed(result: (Bool, Error))
  }
  
  // MARK: - Properties
  
  /// Singleton instance for convenience
  static let shared = PaymentManager()
  
  private var statusRelay = BehaviorRelay<Status>(value: .notStarted)
  
  var statusDriver: Driver<Status> {
    statusRelay.asDriver()
  }
  
//  private var payment
  
  // MARK: - Public API

  func setAmount(amount: Double) {
    //Payment.amount= amount
    statusRelay.accept(.amount)
  }
  
  func setPaymentMethod(paymentMethod: PaymentMethod) {
    //Payment.method = paymentMethod
    statusRelay.accept(.paymentMethod)
  }
  
}
