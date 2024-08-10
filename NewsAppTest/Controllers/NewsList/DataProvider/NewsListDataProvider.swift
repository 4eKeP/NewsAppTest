//
//  DataProvider.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import Foundation

protocol NewsListDataProviderProtocol: AnyObject {
    func fetchNewsListCollection(completion: @escaping NewsListCompletion )
}

typealias NewsListCompletion = (Result<[NewsListModel], Error>) -> Void
