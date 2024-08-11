//
//  NewsModel.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import Foundation

struct NewsModel: Codable, Hashable {
    let newsID: String
    let image: URL?
    let title: String
    let author: String?
    let createdAt: Date
    let description: String?
    let sourceLink: URL
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(newsID)
    }
}
