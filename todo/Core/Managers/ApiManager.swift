//
//  ApiManager.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import Foundation
import Alamofire

class ApiManager {
    static let shared: ApiManager = ApiManager()
    
    private let baseUrl = "https://dummyjson.com"
    private let session: Session
    
    private init() {
        session = Session()
    }
    
    func get<TRes: Decodable>(path: String, completion: @escaping (Result<TRes, Error>) -> Void) {
        guard let baseUrl = URL(string: baseUrl) else {
            completion(.failure(NSError(domain: "Invalid base URL", code: -1, userInfo: nil)))
            
            return
        }
        
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        urlComponents?.path.append(path)
        
        guard let url = urlComponents?.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            
            return
        }
        
        session.request(url).validate(statusCode: 200..<300).responseDecodable(of: TRes.self) { response in
            switch response.result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                print(error)
                
                completion(.failure(error))
            }
        }
    }
}
