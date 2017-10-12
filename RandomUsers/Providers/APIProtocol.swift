//
//  API.swift
//  RandomUsers
//
//  Created by Norbert Szydłowski on 10/10/2017.
//  Copyright © 2017 Norbert Szydłowski. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

protocol APIProtocol {
    func users(size: Int, success: @escaping (Array<UserProtocol>) -> Void, failed: @escaping (String) -> Void) -> DataRequest;
}

class API: APIProtocol {
    static let responseConstants = "results"
    static let errorConstants = "error"
    
    private static let seed = "norbert"

    let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    
    func users(size: Int, success: @escaping (Array<UserProtocol>) -> Void, failed: @escaping (String) -> Void) -> DataRequest {
        
        return self.sessionManager.request(Router.users(seed: API.seed, size: size)).responseObject { (response: DataResponse<UsersResponse>) in
            
            switch response.result {
            case .success:
                let baseResponse = response.result.value
                
                if let error = baseResponse?.error {
                    failed(error)
                } else {
                    let users = baseResponse?.results
                    success(users!)
                }
                
            case .failure(let error):
                failed(error.localizedDescription)
                
            }
            
        }
    }
    
}

private class UsersResponse: Mappable {

    var results: [UserJson]?
    var error: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        results <- map[API.responseConstants]
        error <- map[API.errorConstants]
    }
}

private enum Router: URLRequestConvertible {
    
    private static let paramSeed = "seed"
    private static let paramResults = "results"

    case users(seed: String, size: Int)
    
    static let baseURLString = "http://randomuser.me/api"
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        
        switch self {
        case .users(let seed, let size):
            return [Router.paramSeed : seed, Router.paramResults : size]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")

        return try! Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
