//
//  Networking.swift
//  GAMES!
//
//  Created by Piernick, Dave on 6/12/19.
//  Copyright © 2019 Piernick, Dave. All rights reserved.
//

import Foundation

class Networking {

    static let apiKey = "136a8ff80c965e0b18dacef681fa7ba7434517ea"

    enum Endpoints {
        static let baseURL = "http://www.giantbomb.com/api/search/?api_key=\(Networking.apiKey)&format=json"

        case search(String)

        var urlValue: String {
            switch self {
            case .search(let searchTerm): return Endpoints.baseURL + "&query=\"\(searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")\"&resources=game"
            }
        }
    }

    

}
