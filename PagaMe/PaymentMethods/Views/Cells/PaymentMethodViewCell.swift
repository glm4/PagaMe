//
//  PaymentMethodViewCell.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit

class PaymentMethodViewCell: DetailsViewCell {
  
  static let reuseIdentifier = "PaymentMethodViewCell"
  
  // MARK: - Public API
  
  func configure(with presentable: PaymentMethodPresentable) {
    super.configure(with: presentable)
  }
    
}
