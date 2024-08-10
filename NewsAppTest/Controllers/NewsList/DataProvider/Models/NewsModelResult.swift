//
//  NewModel.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import Foundation

struct NewsModelResult {
    
    static let dateFormatter = ISO8601DateFormatter()
    
    let newsID: String
    let image: URL?
    let author: String
    let createdAt: String?
    let description: String
    let sourceLink: URL
    
    func asDomain() -> NewsModel {
        let news = NewsModel(newsID: self.newsID,
                             image: self.image,
                             author: self.author,
                             createdAt: self.makeDate(body: self),
                             description: self.description,
                             sourceLink: self.sourceLink)
        return news
    }
    
    private func makeDate(body: NewsModelResult) -> Date? {
        return body.createdAt.flatMap { NewsModelResult.dateFormatter.date(from: $0) }
    }
}

