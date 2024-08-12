//
//  DetailScreenAssembler.swift
//  NewsAppTest
//
//  Created by admin on 11.08.2024.
//

import Foundation

final class DetailScreenAssembler {
    func setupDetailScreen(selectedNews: NewsModel) -> DetailedViewController {
        let cdProvider = CDProvider()
        let detailPresenter = DetailedViewControllerPresenter(selectedNews: selectedNews, cdProvider: cdProvider)
        let controller = DetailedViewController(presenter: detailPresenter)
        detailPresenter.viewController = controller
        
        return controller
    }
}
