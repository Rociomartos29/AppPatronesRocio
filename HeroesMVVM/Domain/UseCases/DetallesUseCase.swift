//
//  DetallesUseCase.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 28/1/24.
//

import Foundation
  
protocol DetalleslUseCaseProtocol {
    
    func getDetalles(
        onSuccess: @escaping ([Detalles]) -> Void,
        onError: @escaping (NetworkError) -> Void)
    func setHeroName(name: String)
}

final class DetallesUseCase: DetalleslUseCaseProtocol {
    
    private var heroName: String = ""
    
    init(heroName: String = "") {
        self.heroName = heroName
    }
    
    func setHeroName(name: String) {
        self.heroName = name
    }
    
    func getDetalles(
        onSuccess: @escaping ([Detalles]) -> Void,
        onError: @escaping (NetworkError) -> Void) {
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.allHeros.rawValue)") else {
            onError(.malformedURL)
            return
        }
            
        guard let token = UserDefaultHelper.getToken() else {
            onError(.tokenFormatError)
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.post
        urlRequest.setValue("Bearer \(token) ", forHTTPHeaderField: "Authorization")
        urlRequest.setValue(HTTPMethods.contentType, forHTTPHeaderField: "Content-Type")
        struct HeroDetailRequest: Encodable {
            let name: String
        }
        
        let heroRequest = HeroDetailRequest(name: heroName)
        urlRequest.httpBody = try? JSONEncoder().encode(heroRequest)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                onError(.other)
                return
            }
            guard let data = data else {
                onError(.noData)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == HTTPResponseCodes.SUCCESS else {
                onError(.errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }
            
            // Decodificar la respuesta
            guard let heroResponse = try? JSONDecoder().decode([Detalles].self, from: data) else {
                onError(.decoding)
                return
            }
            
            onSuccess(heroResponse)
        }
        task.resume()
    }
}

final class DetallesUseCaseFakeSuccess: DetalleslUseCaseProtocol {
    func getDetalles(onSuccess: @escaping ([Detalles]) -> Void, onError: @escaping (NetworkError) -> Void) {
        
    }
    
    func fetchDetails(
        onSuccess: @escaping ([Detalles]) -> Void,
        onError: @escaping (NetworkError) -> Void) {
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let detalle = Detalles(id: "1", name: "Batman", description: "Dark Knight", photo: "", favorite: true)
            onSuccess([detalle])
        }
    }
    
    func setHeroName(name: String) {
    }
}

final class DetalleUseCaseFakeError: DetalleslUseCaseProtocol {
    func setHeroName(name: String) {
        
    }
    
    func getDetalles(onSuccess: @escaping ([Detalles]) -> Void, onError: @escaping (NetworkError) -> Void) {
        
    }
    
    func fetchDetails(
        onSuccess: @escaping ([Detalles]) -> Void,
        onError: @escaping (NetworkError) -> Void) {
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            onError(.malformedURL)
        }
    }
}




