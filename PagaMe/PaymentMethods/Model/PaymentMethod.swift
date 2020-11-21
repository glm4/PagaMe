//
//  PaymentMethod.swift
//  PagaMe
//
//  Created by German on 11/20/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation

struct PaymentMethod: Codable {
  
  // MARK: - Properties

  let id: String
  let name: String
  let secureThumbnail: URL?
  let paymentTypeId: String
  
}
