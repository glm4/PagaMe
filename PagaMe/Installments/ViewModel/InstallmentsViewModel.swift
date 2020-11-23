//
//  InstallmentsViewModel.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class InstallmentsViewModel: PaymentFlowManageable, NetworkActivityStatus {
  
  var statusRelay = BehaviorRelay<NetworkStatus>(value: .idle)
  
  var selectedInstallmentOptionDriver: Driver<PayerCost?> {
    selectedPaymentOptionRelay.asDriver()
  }
  
  var installmentCount: Int {
    installmentsRelay.value.count
  }
  
  private var selectedPaymentOptionRelay = BehaviorRelay<PayerCost?>(value: nil)
  
  private var installmentsRelay = BehaviorRelay<[Installment]>(value: [])
  
  var installmentsDriver: Driver<[Installment]> {
    installmentsRelay.asDriver()
  }
  
  // MARK: - Order Data

  private var selectedPaymentMethod: PaymentMethod? {
    paymentManager.orderPaymentMethod
  }
  
  private var selectedIssuer: Issuer? {
    paymentManager.orderIssuer
  }
  
  private var enteredAmount: Decimal? {
    paymentManager.orderAmount
  }
  
  private func installment(at index: Int) -> Installment? {
    guard index >= 0 && index < installmentCount else {
      return nil
    }
    
    return installmentsRelay.value[index]
  }
  
  private func installmentOption(at indexPath: IndexPath) -> PayerCost? {
    guard
      let installment = installment(at: indexPath.section),
      indexPath.row >= 0,
      indexPath.row < installment.payerCosts.count
    else {
      return nil
    }
    
    return installment.payerCosts[indexPath.row]
  }
  
  // MARK: - Public API

  func installmentPresentable(at index: Int) -> InstallmentHeaderPresentable? {
    installment(at: index)
  }
  
  func installmentOptionsCount(at index: Int) -> Int {
    installment(at: index)?.payerCosts.count ?? 0
  }
  
  func installmentOptionPresentable(at indexPath: IndexPath) -> InstallmentPayerCostPresentable? {
    installmentOption(at: indexPath)
  }
  
  func fetchInstallments() {
    guard
      let amount = enteredAmount,
      let paymentMethodId = selectedPaymentMethod?.id,
      let issuerId = selectedIssuer?.id
    else {
      statusRelay.accept(.failed)
      return
    }
    
    statusRelay.accept(.loading)
      
    PaymentsAPI.getInstallemnts(
      paymentMethodId: paymentMethodId,
      issuerId: issuerId,
      amount: amount,
      success: { [weak self] installments in
        self?.statusRelay.accept(.failed)
        self?.installmentsRelay.accept(installments)
    }, failure: { [weak self] error in
      //DEBUG `error`
      self?.statusRelay.accept(.failed)
    })
  }
  
  func selectInstallment(at indexPath: IndexPath) {
    selectedPaymentOptionRelay.accept(installmentOption(at: indexPath))
  }
  
}
