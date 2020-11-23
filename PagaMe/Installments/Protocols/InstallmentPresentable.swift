//
//  InstallmentPresentable.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation

protocol InstallmentPayerCostPresentable {
  
  var installmentCount: Int { get }
  var fullMessage: String { get }
  var installmentAmount: Double { get }
  var totalAmount: Double { get }
  
}
