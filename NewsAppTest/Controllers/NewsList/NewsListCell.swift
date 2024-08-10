//
//  NewsListCell.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import UIKit
import Kingfisher

final class NewsListCell: UITableViewCell, ReuseIdentifying {
    
    lazy var cellImage = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.backgroundColor = .secondarySystemBackground
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var autorLabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    lazy var dateLabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    lazy var descriptionLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    static let newsListCellReuseIdentifier = "NewsListCellReuseIdentifier"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: NewsListCell.newsListCellReuseIdentifier)
        configCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewsListCell {
    func configCell() {
        
    }
}
