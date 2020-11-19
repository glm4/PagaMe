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
    success: @escaping () -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    APIClient.request(
      .get,
      url: "/payment_methods",
      success: { response, _ in
//        guard
//          let userDictionary = response["user"] as? [String: Any],
//          let user = User(dictionary: userDictionary)
//        else {
//          failure(App.error(
//            domain: .parsing,
//            localizedDescription: "Could not parse a valid user".localized
//          ))
//          return
//        }
        
//        UserDataManager.currentUser = user
        success()
      },
      failure: failure
    )
  }
}
