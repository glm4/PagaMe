//
//  AppDelegate.swift
//  PagaMe
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static let shared: AppDelegate = {
    guard let appD = UIApplication.shared.delegate as? AppDelegate else {
      return AppDelegate()
    }
    return appD
  }()

  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    IQKeyboardManager.shared.enable = true

    UINavigationBar.appearance().tintColor = .body
    
    let rootVC = AppNavigator.shared.rootViewController
    window?.rootViewController = rootVC

    return true
  }
}
