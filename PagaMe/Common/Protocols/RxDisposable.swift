//
//  RxDisposable.swift
//  PagaMe
//
//  Created by German on 11/20/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import Foundation
import RxSwift

protocol RxDisposable {
  
  var disposeBag: DisposeBag { get }
  
}
