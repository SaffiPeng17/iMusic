//
//  NetworkManager.swift
//  iMusic
//
//  Created by Saffi on 2022/2/13.
//

import Foundation
import Alamofire
import RxSwift

enum ApiError: Error {
    case requestFailure, parseFailure
}

class NetworkManager {

    class func fetch<T: Codable>(_ urlRequest: ApiRequests) -> Observable<T> {
        return Observable<T>.create { observer in

            AF.request(urlRequest)
                .response { (response: AFDataResponse<Data?>) in
                    switch response.result {
                    case .success(let data):
                        guard let data = data else {
                            observer.onError(ApiError.requestFailure)
                            return
                        }
                        do {
                            let object = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(object)
                        } catch {
                            observer.onError(ApiError.parseFailure)
                        }

                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}

extension NetworkManager {
    class func fetchSearchResult(searchText: String) -> Observable<SearchResult> {
        return NetworkManager.fetch(.search(term: searchText))
    }
}
