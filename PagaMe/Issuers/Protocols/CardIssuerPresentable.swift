//
//  CardIssuerPresentable.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation

protocol CardIssuerPresentable: CellDetailPresentable {
  
  var issuerName: String { get }
  var thumbnailURL: URL? { get }
  
}

extension Issuer: CardIssuerPresentable {
  
  var headline: String {
    issuerName
  }
  
  var subHeadline: String {
    ""
  }
  
  var issuerName: String {
    name
  }
  
  var thumbnailURL: URL? {
    secureThumbnail
  }
  
}
