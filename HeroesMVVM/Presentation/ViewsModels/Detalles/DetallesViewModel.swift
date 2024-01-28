//
//  DetallesViewModel.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 28/1/24.
//

import Foundation
final class DetallesViewModel {
    
    var detallesStatusLoad: ((SplashStatusLoad) -> Void)?
    

    let detallesUseCase: DetallesUseCase
    
    var detalles: [Detalles] = []
    var heroName: String

    init(detallesUseCase: DetallesUseCase = DetallesUseCase(),  heroName: String) {
        self.detallesUseCase = detallesUseCase
        self.heroName = heroName
    }
    

    func loadDetalle() {
        detallesStatusLoad?(.loading)
        detallesUseCase.setHeroName(name: heroName )
        detallesUseCase.getDetalles{ [weak self] detalles in
            DispatchQueue.main.async {
                print(detalles)
                self?.detalles = detalles
                self?.detallesStatusLoad?(.loaded)
            }
        } onError: { [weak self] networkError in
            DispatchQueue.main.async {
                self?.detallesStatusLoad?(.error)
            }
        }
    }
}
