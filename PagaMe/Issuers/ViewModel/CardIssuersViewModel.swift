//
//  CardIssuersViewModel.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CardIssuersViewModel: PaymentFlowManageable, NetworkActivityStatus {
  
  // MARK: - Properties

  private var selectedPaymentMethod: PaymentMethod? {
    paymentManager.orderPaymentMethod
  }
  
  private(set) var statusRelay: BehaviorRelay<NetworkStatus> = BehaviorRelay<NetworkStatus>(
    value: .idle
  )
  
  private var cardIssuersRelay = BehaviorRelay<[Issuer]>(value: [])
  
  private var issuers: [Issuer] {
    cardIssuersRelay.value
  }

  var cardIssuersDriver: Driver<[Issuer]> {
    cardIssuersRelay.asDriver()
  }
  
  private var selectedIssuerRelay = BehaviorRelay<Issuer?>(value: nil)
  
  var selectedIssuerDriver: Driver<Issuer?> {
    selectedIssuerRelay.asDriver()
  }
  
  // MARK: - Public API

  func selectIssuer(atIndex index: Int) {
    guard index >= 0 && index < issuers.count else { return }
    
    selectedIssuerRelay.accept(cardIssuersRelay.value[index])
  }
  
  func confirmIssuer() {
    guard let issuer = selectedIssuerRelay.value else { return }
    
    paymentManager.setIssuer(issuer: issuer)
  }
  
  func fetchCardIssuers() {
    guard let paymentMethodId = selectedPaymentMethod?.id else {
      self.statusRelay.accept(.failed)
      return
    }
    
    statusRelay.accept(.loading)
    PaymentsAPI.getIssuers(
      paymentMethodId: paymentMethodId,
      success: { [weak self] issuers in
      guard let self = self else { return }
      
      self.cardIssuersRelay.accept(issuers)
      self.statusRelay.accept(.idle)
      
    }, failure: { _ in
      // Debug error
      self.statusRelay.accept(.failed)
    })
  }
}
