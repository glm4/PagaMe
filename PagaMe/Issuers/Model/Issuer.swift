//
//  Issuer.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation

struct Issuer: Codable {
  
  let id: String
  let name: String
  let secureThumbnail: URL?
  let processingMode: String?
  
}
