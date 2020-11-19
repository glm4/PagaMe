//
//  HomeRoutes.swift
//  PagaMe
//
//  Created by Mauricio Cousillas on 6/13/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

enum HomeRoutes: Route {
  case home

  var screen: UIViewController {
    switch self {
    case .home:
      guard
        let navVC = UIStoryboard(
          name: "Main", bundle: nil
        ).instantiateInitialViewController() as? UINavigationController,
        let home = navVC.viewControllers.first as? HomeViewController
      else {
        fatalError("HomeViewController could not be instantiated.")
      }
      
      home.viewModel = HomeViewModel()
      return home
    }
  }
}
