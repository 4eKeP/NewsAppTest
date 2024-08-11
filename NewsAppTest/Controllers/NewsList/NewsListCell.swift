//
//  NewsListCell.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import UIKit
import Kingfisher

final class NewsListCell: UITableViewCell, ReuseIdentifying {
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private let cellView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()
    
    lazy var dateLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()
    
    lazy var titleLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    static let newsListCellReuseIdentifier = "NewsListCellReuseIdentifier"
    private let cellImageHeight: CGFloat = 180
    private let cellLabelSpacing: CGFloat = 8
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: NewsListCell.newsListCellReuseIdentifier)
        configCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeCell(news: NewsModel) {
        authorLabel.text = "\(String(localized: "Cell.Author")): \(news.author ?? (String(localized: "Cell.NoAuthor")))"
        dateLabel.text = "\(String(localized: "Cell.Date")): \(dateFormatter.string(from: news.createdAt))"
        titleLabel.text = "\(String(localized: "Cell.Title")): \(news.title)"
        
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
            let errorImage = UIImage(systemName: "photo")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            self.cellImage.image = errorImage
        }
    }
}

private extension NewsListCell {
    func configCell() {
        contentView.addSubview(cellView)
        cellView.addSubview(cellImage)
        cellView.addSubview(authorLabel)
        cellView.addSubview(dateLabel)
        cellView.addSubview(titleLabel)
        contentView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cellLabelSpacing),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -cellLabelSpacing),
            
            cellImage.topAnchor.constraint(equalTo: cellView.topAnchor, constant: cellLabelSpacing),
            cellImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: cellLabelSpacing),
            cellImage.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -cellLabelSpacing),
            cellImage.heightAnchor.constraint(equalToConstant: cellImageHeight),
            
            authorLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: cellLabelSpacing),
            authorLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -cellLabelSpacing),
            authorLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -cellLabelSpacing),
            authorLabel.topAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: cellLabelSpacing),
        
            dateLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: cellLabelSpacing),
            dateLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -cellLabelSpacing),
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: cellLabelSpacing),
            dateLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -cellLabelSpacing),
            
            titleLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: cellLabelSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -cellLabelSpacing),
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: cellLabelSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -cellLabelSpacing)
        ])
    }
}
