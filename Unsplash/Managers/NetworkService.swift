//
//  NetworkService.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import Foundation
enum ServiceError: Error {
    case urlError
    case serverError
    case notData
    case decodeError
}

enum NetworkError: String, Error {
    case unableToComplete = "Unable to complete request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The server responded with no data. Please try again."
}

final class NetworkService {
    
    private let baseURL = "https://api.unsplash.com/"


    
    private let session: URLSession
    private let apiKey = "5jlAU8eaPloXwSv-pZZWSbfS6QKoMd_ThmWOoKVsuTg"
//    private let apiKey = "abJkwyDqWWX7I4GyOYr7ZJTyy2VVIfTNr7llbfipywg"
    private let item = 30
    
    private var components = URLComponents()
    
    init () {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        components.scheme = "https"
        components.host = "api.unsplash.com"
    }
    
    private func fetchURL(path: String, parameters: [String:String]) -> URL? {
        components.path = path
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url
    }
    
    
    func fetchPhotos(completion: @escaping (Result<[PhotoModel], ServiceError>) -> Void) {
        let path = "/photos/random"
        let parameters: [String:String] = ["count": "\(item)", "client_id": "\(apiKey)"]
        guard let url = fetchURL(path: path, parameters: parameters) else { return }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError))
                debugPrint(String(describing: error))
                return
            }
            
            guard let data = data else {
                completion(.failure(.notData))
                debugPrint(String(describing: error))
                return
            }
            
            do {
                let result = try JSONDecoder().decode([PhotoModel].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodeError))
                debugPrint("Failed to decode...")
            }
        }
        
        task.resume()
    }
    

    
    func fetchSearchPhoto(query: String, page: Int = 1, perPage: Int = 30 , completion: @escaping (Result<[PhotoModel], ServiceError>) -> Void) {
        let path = "/search/photos"
        let parameters: [String: String] = [
            "query": query,
            "client_id": apiKey,
            "page": "\(page)",       // добавляем параметры для пагинации
            "per_page": "\(perPage)" // количество изображений на странице
        ]
        
        guard let url = fetchURL(path: path, parameters: parameters) else { return }
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.serverError))
                debugPrint(String(describing: error))
                return
            }
            
            guard let data = data else {
                completion(.failure(.notData))
                debugPrint(String(describing: error))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ResultsPhotosModel.self, from: data)
                completion(.success(result.results ?? []))
            } catch {
                completion(.failure(.decodeError))
                debugPrint("Failed to decode...")
            }
        }
        
        task.resume()
    }
}
