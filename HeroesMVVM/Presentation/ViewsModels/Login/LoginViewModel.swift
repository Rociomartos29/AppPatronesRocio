//
//  LoginViewModel.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import Foundation
class LoginViewModel {
    

    var loginState: ((LoginStatusLoad) -> Void)?
    private let loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }

    func login(email: String?, password: String?) {
       loginState?(.loading(true))
        

        guard let email = email, isValidEmail(email) else {
            loginState?(.loading(false))
            loginState?(.showErrorEmail("Error en el email"))
            return
        }

        guard let password = password, isValidPassword(password) else {
            loginState?(.loading(false))
            loginState?(.showErrorPassword("Error en el password"))
            return
        }
        
       registration(email: email, password: password)
    }
    

    private func isValidEmail(_ email: String) -> Bool {
        return email.isEmpty == false && email.contains("@")
    }
    

    private func isValidPassword(_ password: String) -> Bool {
        return password.isEmpty == false && password.count >= 4
    }
    
    private func registration(email: String, password: String) {
        loginUseCase.Login(username: email, password: password) { [weak self] token in

            DispatchQueue.main.async {
                self?.loginState?(.loaded)
            }
        } onError: { networkError in

            DispatchQueue.main.async {
                var errorMessage = "Error Desconocido"
                switch networkError {
                case .malformedURL:
                    errorMessage = "URL mal formada"
                case .dataFormatting:
                    errorMessage = "Formato de datos incorrecto"
                case .other:
                    errorMessage = "Error desconocido"
                case .noData:
                    errorMessage = "No hay datos disponibles"
                case .errorCode(let error):
                    errorMessage = "Error de código \(error?.description ?? "Desconocido")"
                case .tokenFormatError:
                    errorMessage = "Error de formato de token"
                case .decoding:
                    errorMessage = "Error de decodificación"
                case .unprocessableEntity:
                    print("Error")
                }
                self.loginState?(.errorNetwork(errorMessage))
            }
        }
    }
}
