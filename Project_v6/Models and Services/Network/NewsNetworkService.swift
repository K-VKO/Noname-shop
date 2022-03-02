//
//  NewsNetworkService.swift
//  Project_v6
//
//  Created by Константин Вороненко on 24.02.22.
//

import Foundation
import UIKit

final class NewsNetworkService {
    func getNews(completion: @escaping (([Article]?) -> Void) ) {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=tech&apiKey=163c1a2a8e6e41aab21a445ba4c58afb") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { responseData, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = responseData {
                let news = try? JSONDecoder().decode(ArticleResults.self, from: data).articles
                DispatchQueue.main.async {
                    completion(news)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
