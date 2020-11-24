//
//  SummaryAmountViewCell.swift
//  PagaMe
//
//  Created by German on 11/23/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit

internal class SummaryAmountViewCell: UITableViewCell {

  static let reuseIdentifier = "SummaryAmountViewCell"
  
  private lazy var totalLabel: UILabel = {
    let label = UILabel()
    
    label.font = UIFont.defaultSemibold.withSize(30)
    label.textColor = .body
    label.textAlignment = .center
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupLayout()
  }
  
  private func setupLayout() {
    contentView.addSubview(totalLabel)
    totalLabel.embedInSuperView()
  }
  
  // MARK: - Public API

  func configure(with formattedTotalAmount: String) {
    totalLabel.text = formattedTotalAmount
  }

}
