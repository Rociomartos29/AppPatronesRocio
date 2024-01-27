//
//  HomeUseCase.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import Foundation
protocol HomeUseCaseProtocol {
    func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void)
}

final class HomeUseCase: HomeUseCaseProtocol {
    func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
        
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.allHeros.rawValue)") else {
            onError(.malformedURL)
            return
        }
        print("URL para obtener héroes:", url)
        
        guard let token = UserDefaultHelper.getToken() else {
            onError(.tokenFormatError)
            return
        }
        
        // Crear Request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.post
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue(HTTPMethods.contentType, forHTTPHeaderField: "Content-Type")
        struct HeroRequest: Encodable{
            let name : String
        }
        let heroRequest = HeroRequest(name: "")
        urlRequest.httpBody = try? JSONEncoder().encode(heroRequest)
        // Task
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print("Error durante la solicitud de red:", error)
                onError(.other)
                return
            }
            
            // Verificar Data
            guard let data = data else {
                print("No se recibieron datos")
                onError(.noData)
                return
            }
            
            // Verificar respuesta
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error HTTP: No se recibió una respuesta válida")
                onError(.other)
                return
            }
            
            if httpResponse.statusCode == HTTPResponseCodes.SUCCESS {
                // Decodificar la respuesta
                do {
                    let heroes = try JSONDecoder().decode([HeroModel].self, from: data)
                    onSuccess(heroes)
                } catch {
                    print("Error de decodificación:", error)
                    onError(.decoding)
                }
            } else {
                // Manejo específico del código de estado 422
                if httpResponse.statusCode == 422 {
                    print("Error HTTP 422: Datos no procesables")
                    // Puedes mostrar un mensaje específico al usuario o realizar otras acciones según tu lógica de negocio.
                    // Por ejemplo, puedes llamar a la cláusula onError con un tipo de error específico.
                    onError(.unprocessableEntity)
                } else {
                    // Otros códigos de error
                    print("Error HTTP: \(httpResponse.statusCode)")
                    onError(.errorCode(httpResponse.statusCode))
                }
            }
        }
        
        task.resume()
    }
}
