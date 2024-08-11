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
    
    weak var newsListController: NewsListViewControllerProtocol?
    
    init(dataProvider: NewsListDataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func viewDidLoad() {
        loadNews()
    }
    
    func newsSelected(atRow: Int) {
        
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
}
