//
//  NetworkState.swift
//  PagaMe
//
//  Created by German on 5/20/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum NetworkStatus: Equatable {
  
  case loading, idle, failed
  
}

protocol NetworkActivityStatus {
  
  var statusRelay: BehaviorRelay<NetworkStatus> { get }
  var statusDriver: Driver<NetworkStatus> { get }
  
}

extension NetworkActivityStatus {
 
  var statusDriver: Driver<NetworkStatus> {
    statusRelay.asDriver()
  }
  
}
