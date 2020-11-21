//
//  CellDetailPresentable.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation

protocol CellDetailPresentable {
  
  var headline: String { get }
  var subHeadline: String { get }
  var thumbnailURL: URL? { get }
  
}
