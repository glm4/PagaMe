//
//  ListViewController.swift
//  PagaMe
//
//  Created by German on 11/21/20.
//  Copyright © 2020 German Lopez. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

internal class ListViewController: UIViewController,
  ContinueButtonPresentable, ActivityIndicatorPresenter {
  
  private(set) var disposeBag = DisposeBag()
  
  lazy var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView()
    
    indicator.hidesWhenStopped = true
    indicator.color = .brand
    
    return indicator
  }()
  
   // MARK: - Properties
  
  @IBOutlet weak var continueButton: UIButton!
    
  @IBOutlet weak var instructionLabel: UILabel! {
    didSet {
      instructionLabel.text = instructionsLocalizationKey.localized
      
      instructionLabel.numberOfLines = 2
      instructionLabel.font = .defaultRegular
      instructionLabel.textColor = .body
    }
  }
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.separatorStyle = .none
    }
  }

  // MARK: - Child controllers must override this properties
  
  var instructionsLocalizationKey: String {
    ""
  }
  
  var validationDriver: Driver<Bool> {
    .just(true)
  }
  
  var statusDriver: Driver<NetworkStatus> {
    .just(.idle)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    setupLayout()
    setupBindings()
  }
  
  func setupUI() {
    stylizeContinueButton()
  }
  
  func setupLayout() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    instructionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      //Instructions Label
      instructionLabel.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: AtomicLayout.defaultMargins
      ),
      instructionLabel.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: AtomicLayout.defaultMargins
      ),
      instructionLabel.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -AtomicLayout.defaultMargins
      ),
      
      // Table View
      tableView.topAnchor.constraint(
        equalTo: instructionLabel.bottomAnchor,
        constant: AtomicLayout.defaultMargins
      ),
      tableView.bottomAnchor.constraint(
        equalTo: continueButton.topAnchor,
        constant: -AtomicLayout.defaultMargins
      ),
      tableView.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: -AtomicLayout.defaultMargins
      ),
      tableView.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: AtomicLayout.defaultMargins
      )
    ])
    
    setupButtonLayoutConstraints()
  }
  
  func setupBindings() {
    setupButtonBindings()
    
    statusDriver
      .map { $0 == .loading }
      .drive(onNext: { [weak self] isLoading in
        self?.showActivityIndicator(isLoading)
      }).disposed(by: disposeBag)
  }
  
  /// Child must override with custom behavior
  func continueButtonTapped() {}
  
}
