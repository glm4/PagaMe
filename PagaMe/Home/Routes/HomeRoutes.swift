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
  case paymentMethods
  case cardIssuers
  case installments
  case summary
  
  var screen: UIViewController {
    switch self {
    case .home:
      return homeViewController()
    case .paymentMethods:
      return paymentMethodsController()
    case .cardIssuers:
      return cardIssuersController()
    case .installments:
      return installmentsController()
    case .summary:
      return summaryViewController()
    }
  }
  
  // MARK: - Convenience builders
  
  private func homeViewController() -> UIViewController {
    guard
      let navVC = UIStoryboard.main
        .instantiateInitialViewController() as? UINavigationController,
      let homeVC = navVC.viewControllers.first as? HomeViewController
    else {
      fatalError("HomeViewController could not be instantiated.")
    }
    
    homeVC.viewModel = HomeViewModel()
    return navVC
  }
  
  private func paymentMethodsController() -> UIViewController {
    guard
      let paymentMethodsVC = UIStoryboard.paymentMethods.instantiateViewController(
        withIdentifier: PaymentMethodsController.identifier
      ) as? PaymentMethodsController
    else {
      fatalError("PaymentMethodsController could not be instantiated.")
    }
    
    paymentMethodsVC.viewModel = PaymentMethodsViewModel()
    return paymentMethodsVC
  }
  
  private func cardIssuersController() -> UIViewController {
    guard
      let issuersVC = UIStoryboard.issuers.instantiateViewController(
        withIdentifier: IssuersViewController.identifier
      ) as? IssuersViewController
    else {
      fatalError("IssuersViewController could not be instantiated.")
    }
    
    issuersVC.viewModel = CardIssuersViewModel()
    return issuersVC
  }
  
  private func installmentsController() -> UIViewController {
    guard
      let issuersVC = UIStoryboard.installment.instantiateViewController(
        withIdentifier: InstallmentsViewController.identifier
      ) as? InstallmentsViewController
    else {
      fatalError("InstallmentsViewController could not be instantiated.")
    }
    
    issuersVC.viewModel = InstallmentsViewModel()
    return issuersVC
  }
  
  func summaryViewController() -> UIViewController {
    guard
      let summaryVC = UIStoryboard.summary.instantiateViewController(
        withIdentifier: SummaryViewController.identifier
      ) as? SummaryViewController
    else {
      fatalError("SummaryViewController could not be instantiated.")
    }
    
    summaryVC.viewModel = SummaryViewModel()
    return summaryVC
  }
  
}
