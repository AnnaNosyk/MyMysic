//
//  NetworkService.swift
//  MyMysic
//
//  Created by Anna Nosyk on 21/07/2022.
//

import UIKit
import Alamofire

class NetworkManager {
    
    func getData(text: String, completion: @escaping (SongsResponse?)-> Void) {
        let url = "https://itunes.apple.com/search"
        let parametrs = ["term":"\(text)",
                         "limit":"50",
                         "media":"music"]
        // get request
        AF.request(url, method: .get, parameters: parametrs, encoding: URLEncoding.default, headers: nil).responseData { data in
            if let error = data.error {
                print("Error received requestiong data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data.data else { return }
            //decode data
            let decoder = JSONDecoder()
            do {
                let items = try decoder.decode( SongsResponse.self, from: data)
                completion(items)
            } catch let error  {
                print("Failed to decode JSON", error )
                completion(nil)
            }
        }
    }
}
