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
    let imageURL: URL?
    let title: String
    let creator: [String]?
    let pubDate: String?
    let description: String?
    let link: URL
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case imageURL = "image_url"
        case title, link, creator, description, pubDate
    }
    
    func asDomain() -> NewsModel {
        let news = NewsModel(newsID: self.articleID,
                             image: self.imageURL,
                             title: self.title,
                             author: self.creator?.joined(),
                             createdAt: self.makeDate(body: self),
                             description: self.description,
                             sourceLink: self.link)
        return news
    }
    
    
    private func makeDate(body: NewsModelResult) -> Date {
        let dateValue = body.pubDate.flatMap { NewsModelResult.dateFormatter.date(from: $0) }
        guard let dateValue = dateValue else { return Date()}
        return dateValue
    }
}

