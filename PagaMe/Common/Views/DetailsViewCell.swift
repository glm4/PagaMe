//
//  DetailsViewCell.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit

class DetailsViewCell: UITableViewCell {

  static let reusableNibName = "DetailsViewCell"
  
  // MARK: - Properties

  @IBOutlet weak var thumbnailImageView: UIImageView! {
    didSet {
      thumbnailImageView.contentMode = .scaleAspectFit
    }
  }
  
  @IBOutlet weak var typeLabel: UILabel! {
    didSet {
      typeLabel.font = UIFont.defaultRegular.withSize(14)
      typeLabel.textColor = .brand
    }
  }
  
  @IBOutlet weak var nameLabel: UILabel! {
    didSet {
      nameLabel.font = .defaultSemibold
      nameLabel.textColor = .body
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    thumbnailImageView.setRoundBorders(AtomicLayout.defaultCornerRadius)
    contentView.setRoundBorders(AtomicLayout.defaultCornerRadius)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    thumbnailImageView.kf.cancelDownloadTask()
  }
  
  // MARK: - UI
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    contentView.addBorder(color: selected ? .brand : .clear, weight: 2)
  }
  
  // MARK: - Public API

  func configure(with presentable: CellDetailPresentable) {
    
    thumbnailImageView.kf.setImage(with: presentable.thumbnailURL) { [weak self] result in
      switch result {
      case .success:
        self?.thumbnailImageView.backgroundColor = .clear
      default:
        break
      }
    }
    
    nameLabel.text = presentable.headline
    typeLabel.text = presentable.subHeadline
  }

}
