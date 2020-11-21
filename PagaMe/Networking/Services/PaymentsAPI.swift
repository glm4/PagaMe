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
          let rootObject = response["root"] as? [[String: Any]]
        else {
          failure(App.error(
            domain: .parsing,
            localizedDescription: "Could not parse a valid Payment Method".localized
          ))
          return
        }
        
        let paymentMethods = rootObject.compactMap {
          try? JSONDecoder().decode(PaymentMethod.self, from: $0)
        }
        success(paymentMethods)
      },
      failure: failure
    )
  }
}
