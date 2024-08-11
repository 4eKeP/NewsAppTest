//
//  DetailScreenAssembler.swift
//  NewsAppTest
//
//  Created by admin on 11.08.2024.
//

import Foundation

final class DetailScreenAssembler {
    func setupDetailScreen(selectedNews: NewsModel) -> DetailedViewController {
        let detailPresenter = DetailedViewControllerPresenter(selectedNews: selectedNews)
        let controller = DetailedViewController(presenter: detailPresenter)
        detailPresenter.viewController = controller
        
        return controller
    }
}
