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
    
    lazy var authorLabel = {
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
    private let cellImageHeight: CGFloat = 140
    private let cellLabelSpacing: CGFloat = 8
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: NewsListCell.newsListCellReuseIdentifier)
        configCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeCell(news: NewsModel) {
        authorLabel.text = news.author
        dateLabel.text = news.createdAt?.description
        descriptionLabel.text = news.description
        
        if news.image != nil {
            cellImage.kf.setImage(with: news.image) { [weak self] result in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    let errorImage = UIImage(systemName: "photo")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                    self?.cellImage.image = errorImage
                }
            }
        } else {
            cellImage.isHidden = true
        }
    }
}

private extension NewsListCell {
    func configCell() {
        contentView.addSubview(cellImage)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        contentView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellImage.heightAnchor.constraint(equalToConstant: cellImageHeight),
            
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: cellLabelSpacing),
        
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: cellLabelSpacing),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: cellLabelSpacing)
        ])
    }
}
