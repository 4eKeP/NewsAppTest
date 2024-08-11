//
//  DataProvider.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import Foundation

protocol NewsListDataProviderProtocol: AnyObject {
    func fetchNewsListCollection(requestType: RequestType, completion: @escaping NewsListCompletion)
    func emptyNewsList()
    var newsList: [NewsModel] { get }
    var nextPageID: String { get }
}

enum RequestType {
    case initialRequest
    case nextPageRequest
}

typealias NewsListCompletion = (Result<NewsListModel, Error>) -> Void

final class NewsListDataProvider: NewsListDataProviderProtocol {
    
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
            case .nextPageRequest:
                NextPageNewsRequest(nextPage: nextPageID)
            }
        }
        networkClient.send(request: request, type: NewsListModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                nextPageID = list.nextPage
                list.results.forEach { news in
                    self.newsList.append(news.asDomain())
                }
                completion(.success(list))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func emptyNewsList() {
        newsList = []
    }
    
}
