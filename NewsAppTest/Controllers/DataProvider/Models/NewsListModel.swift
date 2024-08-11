//
//  Models.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import Foundation

struct NewsListModel: Codable {
    let results: [NewsModelResult]
    let nextPage: String
}
