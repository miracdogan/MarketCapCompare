//
//  APICaller.swift
//  MarketCapCompare
//
//  Created by Miraç Doğan on 16.06.2024.
//

import Foundation

class APICaller {
    
    static let shared = APICaller()

    private init() {}

    func fetchCoinNames(completion: @escaping ([String]) -> Void) {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/list")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data")
                return
            }

            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                let coinNames = coins.map { $0.name }
                completion(coinNames)
            } catch {
                print("Error decoding JSON")
            }
        }.resume()
    }
}

struct Coin: Codable {
    let id: String
    let name: String
}
