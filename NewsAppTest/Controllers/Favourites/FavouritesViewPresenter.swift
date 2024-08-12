//
//  FavouritesViewPresenter.swift
//  NewsAppTest
//
//  Created by admin on 12.08.2024.
//

import Foundation

protocol FavouritesViewPresenterProtocol {
    func loadFavNews()
    func newsSelected(atRow: Int) -> NewsModel
}

final class FavouritesViewPresenter: FavouritesViewPresenterProtocol {
    
    private let dataProvider: CDProviderProtocol
    
    weak var controller: FavouritesViewControllerProtocol?
    
    init(dataProvider: CDProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func newsSelected(atRow: Int) -> NewsModel {
        dataProvider.savedNews[atRow]
    }
    
    func loadFavNews() {
        let savedNews = dataProvider.savedNews
        controller?.updateData(with: savedNews)
    }
}
