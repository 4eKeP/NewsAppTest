//
//  NaxtPageNewsRequest.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import Foundation

struct NextPageNewsRequest: NetworkRequest {
    
    let nextPage: String
    
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.baseURL)/api/1/latest?apikey=\(NetworkConstants.apiKey)&language=ru&page=\(nextPage)")
    }
}
