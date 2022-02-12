//
//  ApiRequests.swift
//  iMusic
//
//  Created by Saffi on 2022/2/13.
//

import Foundation
import Alamofire

enum ApiRequests: URLRequestConvertible {
    case search(term: String)

    // MARK: - Path
    private var path: String {
        switch self {
        case .search:
            return AppConfigs.API.Path.search
        }
    }

    // MARK: - ContentType
    var contentType: String {
        switch self {
        case .search:
            return "application/json"
        }
    }

    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }

    // MARK: - Request parameters
    var parameters: Parameters? {
        switch self {
        case .search(let term):
            let parameters = ["term": term]
            return parameters
        }
    }

    // MARK: - URLRequest
    func asURLRequest() throws -> URLRequest {
        let url = try (AppConfigs.API.baseURL + path).asURL()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
