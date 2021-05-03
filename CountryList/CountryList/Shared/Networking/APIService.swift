//
//  APIService.swift
//  CountryList
//
//  Created by Jonathan Hoche on 03/05/2021.
//

import Foundation

struct APIService {

    func getCountries(completion: @escaping (_ countries: [Country]?, _ error: Error?) -> Void) {
        if let url = URL(string: "https://restcountries.eu/rest/v2/all?fields=name;nativeName;borders;area;alpha3Code") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let countries = try JSONDecoder().decode([Country].self, from: data)
                        DispatchQueue.main.async {
                            completion(countries, nil)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, nil)
                    }
                }
            }.resume()
        }
    }
}
