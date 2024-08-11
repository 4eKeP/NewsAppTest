//
//  DataProvider.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import Foundation

protocol NewsListDataProviderProtocol: AnyObject {
    func fetchNewsListCollection(requestType: RequestType, completion: @escaping NewsListCompletion)
 //   func fetchNewsInitialListCollection(completion: @escaping NewsListCompletion )
    var newsList: [NewsModel] { get }
    var nextPageID: String { get }
}

enum RequestType {
    case initialRequest
    case nextPageReqoest
}

typealias NewsListCompletion = (Result<NewsListModel, Error>) -> Void

final class NewsListDataProvider: NewsListDataProviderProtocol {
    
 //   var newsListResult: [NewsModelResult] = []
    
    var newsList: [NewsModel] = []
    
    var nextPageID: String = ""
    
    let networkClient: DefaultNetworkClient
    
    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchNewsListCollection(requestType: RequestType, completion: @escaping NewsListCompletion) {
        var request: NetworkRequest {
            switch requestType {
            case .initialRequest:
                InitialNewsRequest()
            case .nextPageReqoest:
                NextPageNewsRequest(nextPage: nextPageID)
            }
        }
        networkClient.send(request: request, type: NewsListModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
//                print(list.results)
//                print(list.nextPage)
         //       newsListResult = list.newsList
                nextPageID = list.nextPage
                list.results.forEach { news in
                    self.newsList.append(news.asDomain())
                }
               // print(newsList)
                completion(.success(list))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
//    func fetchNewsInitialListCollection(completion: @escaping NewsListCompletion) {
//        networkClient.send(request: InitialNewsRequest(), type: NewsListModel.self) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let list):
//                newsListResult = list.newsList
//                nextPageID = list.nextPageID
//                completion(.success(list))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
}
