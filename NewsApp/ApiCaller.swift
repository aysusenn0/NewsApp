//
//  ApiCaller.swift
//  NewsApp
//
//  Created by Aysu on 19.02.2026.
//

import Foundation

final class ApiCaller {
    static let shared = ApiCaller()
    
    struct Constants {
        static let topHeadlinesUrl = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=18349628f3194b8194cfb15aca128f38"
)
    }
    private init() {}
    
    public func getTopStories (completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesUrl else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from:data)
                    print("Articles : \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
            
        }
        task.resume()
    }
}
//MODELS

struct ApiResponse :Codable {
    let articles : [Article]
}

struct Article :Codable {
    let title : String
    let url : String
    let urlToImage : String
    let publishedAt : String?
    let description : String
    let source : Source
}

struct Source :Codable {
    let name : String
    let id : String?
}
