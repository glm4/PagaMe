//
//  PaymentsAPI.swift
//  PagaMe
//
//  Created by German Lopez on 11/19/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation

class PaymentsAPI {
  
  class func getPaymentMethods(
    success: @escaping (_ paymentMethods: [PaymentMethod]) -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    APIClient.request(
      .get,
      url: "/payment_methods",
      success: { response, _ in
        guard
          let paymentMethods = try? JSONDecoder().decode(
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
}
