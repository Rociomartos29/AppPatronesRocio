//
//  NeteorkError.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import Foundation
enum NetworkError: Error {
    case malformedURL
    case dataFormatting
    case other
    case noData
    case errorCode(Int?)
    case tokenFormatError
    case decoding
    case unprocessableEntity 
}
