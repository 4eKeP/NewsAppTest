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
    func favButtonPressed()
    func show()
}

final class DetailedViewControllerPresenter: DetailedViewControllerPresenterProtocol {
    var selectedNews: NewsModel
    
    private let cdProvider: CDProviderProtocol
    
    weak var viewController: DetailedViewController?
    
    init(selectedNews: NewsModel, cdProvider: CDProviderProtocol) {
        self.selectedNews = selectedNews
        self.cdProvider = cdProvider
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
        checkFavButtonStatus(news: selectedNews)
    }
    
    func checkFavButtonStatus(news: NewsModel) {
        let status = cdProvider.chekIfInCD(news: news)
        print(status)
        viewController?.setStateOfFavButton(inCD: status)
        
    }
    
    func favButtonPressed() {
        cdProvider.chekIfInCDAndSaveIfNeed(news: selectedNews)
        checkFavButtonStatus(news: selectedNews)
    }
    
}
