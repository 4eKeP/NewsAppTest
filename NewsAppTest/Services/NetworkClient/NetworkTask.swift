//
//  NetworkTask.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import Foundation

protocol NetworkTask {
    func cancel()
}

struct DefaultNetworkTask: NetworkTask {
    let dataTask: URLSessionDataTask

    func cancel() {
        dataTask.cancel()
    }
}
