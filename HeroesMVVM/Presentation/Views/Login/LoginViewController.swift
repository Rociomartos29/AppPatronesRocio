//
//  LoginViewController.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import UIKit

class LoginViewController: UIViewController {
    private var viewModel: LoginViewModel
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var errorEmail: UILabel!
    @IBOutlet weak var ContraseñaTextFile: UITextField!
    @IBOutlet weak var errorContraseña: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedEmail = UserDefaultHelper.shared.savedEmail,
           let savedPassword = UserDefaultHelper.shared.savedPassword {
            Email.text = savedEmail
            ContraseñaTextFile.text = savedPassword
        }
        setObservers()
    }
    
    @IBAction func loginBoton(_ sender: Any) {
        viewModel.login(email: Email.text, password: ContraseñaTextFile.text)
    }
}
extension LoginViewController {
    //Method to observe the view state of the viewModel
    private func setObservers() {
        viewModel.loginState = { [weak self] status in
            switch status {
                
            case .loading(let isLoading):
                self?.loadingView.isHidden = !isLoading
                
            case .loaded:
                self?.loadingView.isHidden = true

                            // Almacena las credenciales si el estado es .loaded
                            if let email = self?.Email.text, let password = self?.ContraseñaTextFile.text {
                                UserDefaultHelper.shared.saveUserCredentials(email: email, password: password)
                            }
                            self?.navigateToHome()

                
            case .showErrorEmail(let error):
                self?.errorEmail.text = error
                self?.errorEmail.isHidden = (error == nil || error?.isEmpty == true)
                
                // Show alert for incorrect email
                if let error = error, !error.isEmpty {
                    self?.showAlert(message: "Email incorrecto. Introduce un email válido")
                }
                
            case .showErrorPassword(let error):
                self?.errorContraseña.text = error
                self?.errorContraseña.isHidden = (error == nil || error?.isEmpty == true)
                
                // Show alert for incorrect password
                if let error = error, !error.isEmpty {
                    self?.showAlert(message: "Contraseña incorrecta")
                }
                
            case .errorNetwork(let errorMessage):
                self?.loadingView.isHidden = true
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    private func navigateToHome() {
        let nextVM = HomeViewModel(homeUseCase: HomeUseCase())
        let nextVC = HomeTableViewController(homeViewModel: nextVM)
        navigationController?.setViewControllers([nextVC], animated: true)
    }
    func showAlert(message: String) {
            let alertController = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
}
