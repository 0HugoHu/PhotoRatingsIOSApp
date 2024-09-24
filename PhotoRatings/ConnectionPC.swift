//
//  ConnectionPC.swift
//  PhotoRatings
//
//  Created by Hugooooo on 9/21/24.
//

import Foundation
import UIKit

var authToken: String?

func login(completion: @escaping (Bool) -> Void) {
    guard let url = URL(string: PC_IP + LOGIN) else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = ["username": HTTP_USER_NAME, "password": HTTP_PASSWORD]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error during login:", error)
            completion(false)
        } else if let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let token = json["token"] as? String {
            authToken = token
            print("Login successful, token received:", token)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    task.resume()
}
