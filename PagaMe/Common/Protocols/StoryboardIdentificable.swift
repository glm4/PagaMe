//
//  StoryboardIdentificable.swift
//  PagaMe
//
//  Created by German on 11/20/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit

protocol StoryboardIdentificable {
  
  static var identifier: String { get }
  
}

extension UIViewController: StoryboardIdentificable {
  
  static var identifier: String {
    String(describing: Self.self)
  }
  
}
