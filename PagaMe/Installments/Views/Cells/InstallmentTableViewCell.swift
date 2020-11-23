//
//  InstallmentTableViewCell.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit

internal class InstallmentTableViewCell: UITableViewCell {

  static let reuseIdentifier = "InstallmentTableViewCell"
  
  @IBOutlet weak var fullMessageLabel: UILabel!
  
  @IBOutlet weak var installmentCountLabel: UILabel! {
    didSet {
      installmentCountLabel.text = "installment_option.installment_count".localized
    }
  }
  
  @IBOutlet weak var totalAmountLabel: UILabel! {
     didSet {
       totalAmountLabel.text = "installment_option.total_amount".localized
     }
   }
  
  @IBOutlet weak var totalPaymentLabel: UILabel!
  @IBOutlet weak var totalInstallmentsLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    
    [fullMessageLabel, installmentCountLabel, totalAmountLabel].forEach {
      $0?.font = .defaultSemibold
      $0?.textColor = .body
    }
    
    [totalPaymentLabel, totalInstallmentsLabel].forEach {
      $0?.font = .defaultRegular
      $0?.textColor = .brand
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    contentView.addBorder(color: .brand, weight: selected ? 2 : 0)
  }
  
  // MARK: - Public API
  
  func configure(with presentable: InstallmentPayerCostPresentable) {
    fullMessageLabel.text = presentable.fullMessage
    
    totalInstallmentsLabel.text = "\(presentable.installmentCount)"
    totalPaymentLabel.text = "\(Currency.current) \(presentable.totalAmount)"
  }
    
}
