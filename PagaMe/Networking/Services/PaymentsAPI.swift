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
}
