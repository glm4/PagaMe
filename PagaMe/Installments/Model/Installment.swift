//
//  Installment.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation

struct Installment: Codable {
  
  let paymentMethodId: String
  let paymentTypeId: String
  let issuer: Issuer
  let processingMode: String?
  let payerCosts: [PayerCost]
  
}

struct PayerCost: Codable {
  
  let paymentMethodOptionId: String
  let installments: Int
  let recommendedMessage: String
  let installmentAmount: Double
  let totalAmount: Double
  
}

extension PayerCost: InstallmentPayerCostPresentable {
  
  var installmentCount: Int {
    installments
  }
  
  var fullMessage: String {
    recommendedMessage
  }
  
}

extension Installment: InstallmentHeaderPresentable {
  
  var issuerName: String {
    issuer.name
  }
  
  var thumbnailURL: URL? {
    issuer.secureThumbnail
  }
  
  var paymentMethodName: String {
    issuerName
  }
  
  var paymentMethodType: String {
    paymentMethodId
  }
  
  var headline: String {
    paymentMethodName
  }
  
  var subHeadline: String {
    paymentMethodType
  }
  
}
