//
//  Network.swift
//  CapstoneProject
//
//  Created by tarik.efe on 25.07.2022.
//

import Foundation
import Alamofire

struct NetworkConstants {
    static let apiKey = "?api_key=38ac70407c33cd8f7220e46418ca5b14"
    static let baseURL = "https://api.themoviedb.org/3"
    static let popularMovie = "/movie/popular"
    static let poster = "https://image.tmdb.org/t/p/w500"
    static let pageNumber = "&page="
    static let query = "&query="
    static let searchMovie = "/search/movie"
    static let allMovie = "/movie/"
    static let credits = "/credits"
    static let recommendations = "/recommendations"
    static let languageEN = "&language=en-US"
    static let languageTR = "&language=tr"
}

class Network {
    static let shared = Network()
    let language = Locale.current.languageCode == "tr" ? NetworkConstants.languageTR: NetworkConstants.languageEN
    
    func getMovies<T>(_type: T.Type, with urlString: String ,completion: @escaping (Result<T, AFError>) -> Void) where T:Codable {
        AF.request("\(urlString)\(language)", method: .get).responseDecodable(of: T.self) { response in
                completion(response.result)
            }
        }
  }


