//
//  SplashViewController.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var ActivateIndicator: UIActivityIndicatorView!
    private var viewModel: SplashViewModel
    init(viewModel: SplashViewModel = SplashViewModel()) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setObservers()
            viewModel.simulationLoadData()
        }
    }

    // MARK: - Extension -
    extension SplashViewController {
        private func showLoading(show: Bool) {
            // Customize this method based on your needs
        }

        private func setObservers() {
           viewModel.modelStatusLoad = { [weak self] status in
                switch status {
                case .loading:
                    self?.showLoading(show: true)
                case .loaded:
                    self?.showLoading(show: false)
                    self?.navigateToNextScreen()
                case .error:
                    print("Error Custom")
                case .none:
                    print("None Custom")
                }
            }
        }

        private func navigateToNextScreen() {
            let nextVM = LoginViewModel()
            let nextVC = LoginViewController(viewModel: nextVM)
            navigationController?.setViewControllers([nextVC], animated: false)
        }
    }
