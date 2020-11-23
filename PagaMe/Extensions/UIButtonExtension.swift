//
//  UIButtonExtension.swift
//  PagaMe
//
//  Created by German on 11/19/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit

extension UIButton {
  
  func applyDefaultStyle() {
    titleLabel?.font = .defaultSemibold
    
    setRoundBorders(AtomicLayout.defaultCornerRadius)
    backgroundColor = .brand
  }
}
