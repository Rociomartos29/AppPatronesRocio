//
//  UserDefaultHelper.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import Foundation
class UserDefaultHelper{
    static let shared = UserDefaultHelper()

    private static let userDefaults = UserDefaults.standard
       private let userEmailKey = "userEmail"
       private let userPasswordKey = "userPassword"

       var savedEmail: String? {
           return UserDefaultHelper.userDefaults.string(forKey: userEmailKey)
       }

       var savedPassword: String? {
           return UserDefaultHelper.userDefaults.string(forKey: userPasswordKey)
       }

       func saveUserCredentials(email: String, password: String) {
           UserDefaultHelper.userDefaults.set(email, forKey: userEmailKey)
           UserDefaultHelper.userDefaults.set(password, forKey: userPasswordKey)
       }

       func clearSavedUserCredentials() {
           UserDefaultHelper.userDefaults.removeObject(forKey: userEmailKey)
           UserDefaultHelper.userDefaults.removeObject(forKey: userPasswordKey)
       }
   
    
    private enum Constant{
        static let tokenKey = "KCToken"
    }
    
    static func getToken() -> String?{
        userDefaults.string(forKey: Constant.tokenKey)!
    }
    static func save (token: String){
        userDefaults.set(token, forKey: Constant.tokenKey)
    }
    static func deleteToken(){
        userDefaults.removeObject(forKey: Constant.tokenKey)
    }
}
