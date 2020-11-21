//
//  PaymentMethodPresentable.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation

protocol PaymentMethodPresentable: CellDetailPresentable {
  
  var paymentMethodName: String { get }
  var paymentMethodType: String { get }
  var thumbnailURL: URL? { get }
  
}

extension PaymentMethod: PaymentMethodPresentable {
  
  var paymentMethodName: String {
    name
  }
  
  var paymentMethodType: String {
    paymentTypeId.replacingOccurrences(of: "_", with: " ").capitalized
  }
  
  var headline: String {
    paymentMethodName
  }
  
  var subHeadline: String {
    paymentMethodType
  }
  
  var thumbnailURL: URL? {
    secureThumbnail
  }
  
}
