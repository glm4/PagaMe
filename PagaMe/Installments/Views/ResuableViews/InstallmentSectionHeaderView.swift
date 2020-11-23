//
//  InstallmentSectionHeaderView.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit
import Kingfisher

internal typealias InstallmentHeaderPresentable =
  CardIssuerPresentable & PaymentMethodPresentable

internal class InstallmentSectionHeaderView: UITableViewHeaderFooterView {
  
  static let reuseIdentifier = "InstallmentSectionHeaderView"
  static let defaultHeight: CGFloat = 60
  
  lazy var thumbnailView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.contentMode = .scaleAspectFit
    imageView.setRoundBorders(AtomicLayout.defaultCornerRadius)
    
    return imageView
  }()
  
  lazy var nameLabel: UILabel = {
    let label = UILabel()
    
    label.textColor = .body
    label.font = .defaultSemibold
    
    return label
  }()
  
  lazy var typeLabel: UILabel = {
    let label = UILabel()
    
    label.font = UIFont.defaultRegular.withSize(14)
    label.textColor = .brand
    
    return label
  }()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    thumbnailView.kf.cancelDownloadTask()
  }
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout() {
    [thumbnailView, nameLabel, typeLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      //Thumbnail
      thumbnailView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: AtomicLayout.defaultMargins * 2
      ),
      thumbnailView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: AtomicLayout.defaultMargins
      ),
      thumbnailView.heightAnchor.constraint(equalToConstant: Layout.ThumbnailView.height),
      thumbnailView.widthAnchor.constraint(
        equalTo: thumbnailView.heightAnchor,
        multiplier: 3 / 2,
        constant: 0
      ),
      thumbnailView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -AtomicLayout.defaultMargins
      ),
      
      // Name Label
      nameLabel.leadingAnchor.constraint(
        equalTo: thumbnailView.trailingAnchor,
        constant: AtomicLayout.defaultMargins
      ),
      nameLabel.trailingAnchor.constraint(
        greaterThanOrEqualTo: contentView.trailingAnchor,
        constant: -AtomicLayout.defaultMargins
      ),
      nameLabel.bottomAnchor.constraint(equalTo: thumbnailView.centerYAnchor),
      
      // Type Label
      typeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      typeLabel.topAnchor.constraint(equalTo: thumbnailView.centerYAnchor),
      typeLabel.trailingAnchor.constraint(
        greaterThanOrEqualTo: contentView.trailingAnchor,
        constant: -AtomicLayout.defaultMargins
      )
    ])
  }
  
  // MARK: - Public API
  
  func configure(with presentable: InstallmentHeaderPresentable) {
    nameLabel.text = presentable.issuerName
    typeLabel.text = presentable.paymentMethodType
    
    thumbnailView.kf.setImage(with: presentable.thumbnailURL)
  }

}

fileprivate extension InstallmentSectionHeaderView {
  
  enum Layout {
    
    enum ThumbnailView {
      
      static let height: CGFloat = 40
      
    }
    
  }
}
