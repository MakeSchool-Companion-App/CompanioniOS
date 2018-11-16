//
//  FacebookServices.swift
//  companion
//
//  Created by Uchenna  Aguocha on 10/25/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

struct FacebookServices {
    
    
    // MARK: - Methods
    
    static func showFacebookUserProfile(completionHandler: @escaping (User?, Error?) -> Void) {
        
        
        let url = URL(string: "https://www.makeschool.com/login.json")
        let keychain = KeychainSwift()
        let session = URLSession.shared
        
        var request = URLRequest(url: url!)
        request.setValue("_makeschool_session=\(keychain.get("cookieValue")!)", forHTTPHeaderField: "Cookie")
        request.httpMethod = "POST"
        request.httpShouldHandleCookies = true
        
        session.dataTask(with: request) { (data, res, err) in
            
            do {
                guard let userData = data,
                    let decodedFacebookUser = try? JSONDecoder().decode(User.self, from: userData) else { return }
               /// make a post request to get user
                UserServices.login(email: decodedFacebookUser.email, password: "", completion: { (user) in
<<<<<<< HEAD
                    if let user = user as? User {
                        return completionHandler(user, nil)
                    }
=======
                    if let user = user as? User{
                       return completionHandler(user, nil)
                    }
                    
>>>>>>> 29d26a2760c87b7da5ffb111bf6dc63a546a2e13
                })
               
            } catch let error {
                return completionHandler(nil, error)
            }
            
        }.resume()
    }
    
}
