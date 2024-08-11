//
//  NewsListPresenter.swift
//  NewsAppTest
//
//  Created by admin on 11.08.2024.
//

import Foundation

protocol NewsListPresenterProtocol {
    func loadInitialNews()
    func newsSelected(atRow: Int) -> NewsModel
    func fetchNextPageIfNeeded(indexPath: IndexPath)
}

final class NewsListPresenter: NewsListPresenterProtocol {
    
    private let dataProvider: NewsListDataProviderProtocol
    
    weak var newsListController: NewsListViewControllerProtocol?
    
    init(dataProvider: NewsListDataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func loadInitialNews() {
        dataProvider.emptyNewsList()
        loadNews()
    }
    
    func newsSelected(atRow: Int) -> NewsModel {
        dataProvider.newsList[atRow]
    }
    
    private func loadNews() {
        UIBlockingProgressHUD.show()
        dataProvider.fetchNewsListCollection(requestType: .initialRequest) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(_):
                newsListController?.updateData(with: self.dataProvider.newsList)
            case .failure(_):
                newsListController?.showError(ErrorModel {[weak self] in self?.loadNews()
                })
            }
        }
    }
    
    func fetchNextPageIfNeeded(indexPath: IndexPath) {
        if indexPath.row + 1 == dataProvider.newsList.count {
            dataProvider.fetchNewsListCollection(requestType: .nextPageRequest) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self else { return }
                switch result {
                case .success(_):
                    newsListController?.updateData(with: self.dataProvider.newsList)
                case .failure(_):
                    newsListController?.showError(ErrorModel {[weak self] in self?.loadNews()
                    })
                }
            }
        }
    }
}
