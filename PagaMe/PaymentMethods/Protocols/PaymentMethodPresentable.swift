//
//  PaymentMethodPresentable.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation

protocol PaymentMethodPresentable {
  
  var headline: String { get }
  var subHeadline: String { get }
  var thumbnailURL: URL? { get }
  
}

extension PaymentMethod: PaymentMethodPresentable {
  
  var headline: String {
    name
  }
  
  var subHeadline: String {
    paymentTypeId.replacingOccurrences(of: "_", with: " ").capitalized
  }
  
  var thumbnailURL: URL? {
    secureThumbnail
  }
  
}
