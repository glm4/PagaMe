//
//  IssuerDetailViewCell.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit

class IssuerDetailViewCell: DetailsViewCell {

  static let reuseIdentifier = "IssuerDetailViewCell"

  // MARK: - Public API

  func configure(with presentable: CardIssuerPresentable) {
    super.configure(with: presentable)
  }

}
