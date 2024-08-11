//
//  CDProvider.swift
//  NewsAppTest
//
//  Created by admin on 11.08.2024.
//

import UIKit
import CoreData

enum NewsCDError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidTitle
    case decodingErrorInvalidDate
    case decodingErrorInvalidSourceLink
    case decodingError
}

final class CDProvider: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<NewsModelCD>
    
    var savedNews: [NewsModel]?
    
    convenience override init() {
        guard let application = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("не удалось получить application в CDProvider")
        }
        let context = application.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request = NewsModelCD.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \NewsModelCD.createdAt, ascending: true)
        ]
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        self.fetchedResultsController = controller
        super.init()
        controller.delegate = self
        try? controller.performFetch()
        savedNews = fetchNewsCD()
    }
    
    func fetchNewsCD() -> [NewsModel] {
        guard let objects = self.fetchedResultsController.fetchedObjects,
              let news = try? objects.map({try self.news(from: $0)}) else { return [] }
        return news
    }
    
    func news(from newsCD: NewsModelCD) throws -> NewsModel {
        
        guard let newsID = newsCD.newsID else { throw
            NewsCDError.decodingErrorInvalidId
        }
        
        guard let title = newsCD.title else { throw
            NewsCDError.decodingErrorInvalidTitle
        }
        
        guard let createdAt = newsCD.createdAt else { throw
            NewsCDError.decodingErrorInvalidDate
        }
        
        guard let sourceLink = newsCD.sourceLink else { throw
            NewsCDError.decodingErrorInvalidSourceLink
        }
        
        return NewsModel(newsID: newsID,
                  image: newsCD.image,
                  title: title,
                  author: newsCD.author,
                  createdAt: createdAt,
                  description: newsCD.newsDescription,
                  sourceLink: sourceLink)
    }
    
    func addNew(news: NewsModel) throws {
        let newsInCD = NewsModelCD(context: context)
        newsInCD.newsID = news.newsID
        newsInCD.author = news.author
        newsInCD.createdAt = news.createdAt
        newsInCD.image = news.image
        newsInCD.newsDescription = news.description
        newsInCD.sourceLink = news.sourceLink
        newsInCD.title = news.title
        saveContext()
    }
    
    func deleteNewsBy(news: NewsModel) {
        self.fetchedResultsController.fetchedObjects?.filter { $0.newsID == news.newsID}.forEach { context.delete($0)}
        saveContext()
    }
}

extension CDProvider: NSFetchedResultsControllerDelegate {
    
}

//MARK: - Save Context
private extension CDProvider {
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("не удалось сохранить context в CDProvider с ошибкой \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
