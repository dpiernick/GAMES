//
//  Networking.swift
//  GAMES!
//
//  Created by Piernick, Dave on 6/12/19.
//  Copyright © 2019 Piernick, Dave. All rights reserved.
//

import Foundation
import Network
import SystemConfiguration

class Networking {

    static let apiKey = "136a8ff80c965e0b18dacef681fa7ba7434517ea"

    enum Endpoints {
        // NOTE: Used this enum to store URL parts and concatenate them.  Just looks kinda funny when there is only one URL piece.
        static let baseURL = "https://www.giantbomb.com/api/search/?api_key=\(Networking.apiKey)&format=json"

        case search(String)

        var stringValue: String {
            switch self {
            case .search(let searchTerm): return Endpoints.baseURL + "&query=\(searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&resources=game"
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }

    class func search(searchTerm: String, completion: @escaping ([Game], Error?) -> Void) -> URLSessionTask {
        let url = Networking.Endpoints.search(searchTerm).url
        let request = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let loldata = data else {
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(SearchResponse.self, from: loldata)
                let games = decodedResponse.results
                DispatchQueue.main.async {
                    completion(games, nil)
                }
            } catch {
                completion([], error)
            }
        }
        request.resume()
        return request
    }


    class func getImage(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        task.resume()
    }

    // NOTE: Could not get this function to work.  Would have called from SearchViewController and DetailVC on all network calls.

    class func isConnectedToInternet() -> Bool {
        var connected = false
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                connected = true
            } else {
                connected = false
            }
        }
        return connected
    }

}
