//
//  HomeViewModels.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import Foundation

final class HomeViewModel {
    
    var homeStatusLoad: ((SplashStatusLoad) -> Void)?
    
    let homeUseCase: HomeUseCaseProtocol
    
    var heroes: [HeroModel]
    

    init(homeUseCase: HomeUseCaseProtocol = HomeUseCase()) {
        self.homeUseCase = homeUseCase
        self.heroes = []
    }
    

    func loadHero() {
        homeStatusLoad?(.loading)
        homeUseCase.getHeroes { [weak self] heroes in
            DispatchQueue.main.async {
                print(heroes)
                self?.heroes = heroes
                self?.homeStatusLoad?(.loaded)
            }
        } onError: { [weak self] networkError in
            DispatchQueue.main.async {
                self?.homeStatusLoad?(.error)
            }
        }
    }
}
