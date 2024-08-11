//
//  NewsListPresenter.swift
//  NewsAppTest
//
//  Created by admin on 11.08.2024.
//

import Foundation

protocol NewsListPresenterProtocol {
    func viewDidLoad()
    func newsSelected(atRow: Int)
}

final class NewsListPresenter: NewsListPresenterProtocol {
    private let dataProvider: NewsListDataProviderProtocol
    
}
