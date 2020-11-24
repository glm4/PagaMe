//
//  PaymentsAPI.swift
//  PagaMe
//
//  Created by German Lopez on 11/19/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation

class PaymentsAPI {
  
  private static let paymentsPath = "/payment_methods"
  private static let issuersPath = "\(paymentsPath)/card_issuers"
  private static let installmentsPath = "\(paymentsPath)/installments"
  
  // MARK: - Payment Methods
  
  class func getPaymentMethods(
    success: @escaping (_ paymentMethods: [PaymentMethod]) -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    APIClient.request(
      .get,
      url: paymentsPath,
      success: { response, _ in
        guard
          let paymentMethods = try? JSONDecoder.defaultDecoder.decode(
            [PaymentMethod].self,
            from: response
          )
        else {
          failure(App.error(
            domain: .parsing,
            localizedDescription: "Could not parse a valid Payment Method".localized
          ))
          return
        }
        
        success(paymentMethods)
      },
      failure: failure
    )
  }
  
  // MARK: - Issuers
  
  class func getIssuers(
    paymentMethodId: String,
    success: @escaping (_ issuers: [Issuer]) -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    APIClient.request(
      .get,
      url: issuersPath,
      params: ["payment_method_id": paymentMethodId],
      success: { response, _ in
        guard
          let cardIssuers = try? JSONDecoder.defaultDecoder.decode(
            [Issuer].self,
            from: response
          )
        else {
          failure(App.error(
            domain: .parsing,
            localizedDescription: "Could not parse a valid Issuer".localized
          ))
          return
        }
        
        success(cardIssuers)
      },
      failure: failure
    )
  }
  
  // MARK: - Installments
  
  class func getInstallemnts(
    paymentMethodId: String,
    issuerId: String,
    amount: Decimal,
    success: @escaping (_ installments: [Installment]) -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    
    let requestParams = [
      "payment_method_id": paymentMethodId,
      "issuer.id": issuerId,
      "amount": "\(amount)"
    ]
    APIClient.request(
      .get,
      url: installmentsPath,
      params: requestParams,
      success: { response, _ in
        guard
          let installments = try? JSONDecoder.defaultDecoder.decode(
            [Installment].self,
            from: response
          )
        else {
          failure(App.error(
            domain: .parsing,
            localizedDescription: "Could not parse a valid Installment".localized
          ))
          return
        }
        
        success(installments)
      },
      failure: failure
    )
  }
  
  class func completePayment(
    paymentMethodId: String,
    amount: Decimal,
    installments: Int,
    success: @escaping (_ payment: Payment) -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    let requestParams: [String: Any] = [
      "installments": installments,
      "payment_method_id": paymentMethodId,
      "amount": "\(amount)"
    ]
    APIClient.request(
      .post,
      url: paymentsPath,
      params: requestParams,
      success: { response, _ in
        guard
          let payment = try? JSONDecoder.defaultDecoder.decode(
            Payment.self,
            from: response
          )
        else {
          failure(App.error(
            domain: .parsing,
            localizedDescription: "Could not parse a valid Payment".localized
          ))
          return
        }
        
        success(payment)
      },
      failure: failure
    )
  }
}
