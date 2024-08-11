//
//  NewModel.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import Foundation

struct NewsModelResult: Codable {
    
    static let dateFormatter = ISO8601DateFormatter()
    
    let articleID: String
    let imageUrl: URL?
    let title: String
    let creator: String?
    let pubDate: String?
    let description: String?
    let link: URL
    
    func asDomain() -> NewsModel {
        let news = NewsModel(newsID: self.articleID,
                             image: self.imageUrl, 
                             title: self.title,
                             author: self.creator,
                             createdAt: self.makeDate(body: self),
                             description: self.description,
                             sourceLink: self.link)
        return news
    }
    
    private func makeDate(body: NewsModelResult) -> Date? {
        return body.pubDate.flatMap { NewsModelResult.dateFormatter.date(from: $0) }
    }
}

