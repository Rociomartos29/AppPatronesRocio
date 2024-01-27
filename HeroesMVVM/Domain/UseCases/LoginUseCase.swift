//
//  LoginUseCase.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import Foundation
protocol LoginUseCaseProtocol {
    func Login(username: String,
                  
                  password: String,
                  onSuccess: @escaping (String?) -> Void,
                  onError: @escaping (NetworkError) -> Void)
}

final class LoginUseCase: LoginUseCaseProtocol {
    func Login(username: String,
                  password: String,
                  onSuccess: @escaping (String?) -> Void,
                  onError: @escaping (NetworkError) -> Void) {
        // Check URL
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.login.rawValue)") else {
            onError(.malformedURL)
            return
        }
        
        let loginString = String(format: "%@:%@", username, password)
        guard let registrationData = loginString.data(using: .utf8) else {
            onError(.dataFormatting)
            return
        }
        let base64LoginString = registrationData.base64EncodedString()
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.post
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        
        // DataTask
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // Check error
            guard error == nil else {
                onError(.other)
                return
            }
            
            // Check Data
            guard let data = data else {
                onError(.noData)
                return
            }
            
            // Check response
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == HTTPResponseCodes.SUCCESS else {
                onError(.errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }
            
            // Transform data to get the registration token or any relevant information
            guard String(data: data, encoding: .utf8) != nil else {
                onError(.tokenFormatError)
                return
            }
            guard let token = String(data: data, encoding: .utf8) else {
                onError(.tokenFormatError)
                return
            }
            UserDefaultHelper.save(token: token)
            onSuccess(token)
        }
        task.resume()
    }
}

// MARK: - Registration Use Case Fake Success
final class LoginUseCaseFakeSuccess: LoginUseCaseProtocol {
    func Login(username: String, password: String, onSuccess: @escaping (String?) -> Void, onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let registrationToken = "789012"
            onSuccess(registrationToken)
        }
    }
}

// MARK: - Registration Use Case Fake Error
final class LoginUseCaseFakeError: LoginUseCaseProtocol {
    func Login(username: String, password: String, onSuccess: @escaping (String?) -> Void, onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            onError(.tokenFormatError)
        }
    }
}
