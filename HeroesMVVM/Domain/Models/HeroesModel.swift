//
//  HeroesModel.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import Foundation
struct HeroModel: Decodable{
    let id: String
    let name: String
    let description:String
    let photo: String
    let favorite: Bool
}
struct Detalles:Decodable{
    let id: String
    let name: String
    let description:String
    let photo: String
    let favorite: Bool
    
}
                        
