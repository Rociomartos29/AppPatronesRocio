//
//  SplashViewModel.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import Foundation
final class SplashViewModel {

    var modelStatusLoad: ((SplashStatusLoad) -> Void)?
    
    func simulationLoadData() {
       
        modelStatusLoad?(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
           
            self?.modelStatusLoad?(.loaded)
        }
    }
}
