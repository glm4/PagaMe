//
//  SummaryPresentable.swift
//  PagaMe
//
//  Created by German on 11/23/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation
import UIKit

internal typealias RegistrableCellClass = UITableViewCell.Type

internal protocol SummaryPresentable {
  
  var reuseIdentifier: String { get }
  var reusableNibName: String? { get }
  var cellClassToRegister: RegistrableCellClass { get }
  
}

extension SummaryPresentable {
  
  var reuseIdentifier: String {
    ""
  }
  
  var reusableNibName: String? {
    reuseIdentifier
  }
  
  var cellClassToRegister: RegistrableCellClass {
    UITableViewCell.self
  }
  
}

internal typealias AmountRepresentable = Decimal

extension Decimal: SummaryPresentable {
  
  var reuseIdentifier: String {
    SummaryAmountViewCell.reuseIdentifier
  }
  
  var reusableNibName: String? {
    nil
  }
  
  var cellClassToRegister: RegistrableCellClass {
    SummaryAmountViewCell.self
  }
  
}

extension Issuer: SummaryPresentable {
  
  var reuseIdentifier: String {
    IssuerDetailViewCell.reuseIdentifier
  }
  
  var reusableNibName: String? {
    DetailsViewCell.reusableNibName
  }
  
}

extension PaymentMethod: SummaryPresentable {
  
  var reuseIdentifier: String {
    PaymentMethodViewCell.reuseIdentifier
  }
  
  var reusableNibName: String? {
    DetailsViewCell.reusableNibName
  }
  
}

extension PayerCost: SummaryPresentable {
  
  var reuseIdentifier: String {
    InstallmentTableViewCell.reuseIdentifier
  }
  
}
