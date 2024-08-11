//
//  DetailedViewControllerPresenter.swift
//  NewsAppTest
//
//  Created by admin on 11.08.2024.
//

import Foundation
import SafariServices

protocol DetailedViewControllerPresenterProtocol {
    var selectedNews: NewsModel { get }
    func backButtonTapped()
    func authorLinkTapped()
    func show()
}

final class DetailedViewControllerPresenter: DetailedViewControllerPresenterProtocol {
    var selectedNews: NewsModel
    
    weak var viewController: DetailedViewController?
    
    init(selectedNews: NewsModel) {
        self.selectedNews = selectedNews
    }
    
    func authorLinkTapped() {
        let url = selectedNews.sourceLink
        let safaryVC = SFSafariViewController(url: url)
        viewController?.configNavBackButton()
        viewController?.navigationController?.present(safaryVC, animated: true)
    }
    
    func backButtonTapped() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func show(){
        viewController?.show(selectedNews: selectedNews)
    }
    
}
