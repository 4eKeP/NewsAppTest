//
//  DitaledViewController.swift
//  NewsAppTest
//
//  Created by admin on 11.08.2024.
//

import UIKit

protocol DetailedViewControllerProtocol {
    func show(selectedNews: NewsModel)
}

final class DetailedViewController: UIViewController {
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private lazy var favButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "star"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(favButtonPressed))
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var coverImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var authorLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var descriptionLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var sourceLinkLabel = {
        let label = UILabel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authorLinkTapped))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .systemBlue
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backButtonTapped))
        return button
    }()
    
    private let presenter: DetailedViewControllerPresenterProtocol
    
    init(presenter: DetailedViewControllerPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.show()
        setupUI()
    }
    
    @objc func favButtonPressed() {
        favButton.isEnabled = false
        presenter.favButtonPressed()
    }
    
    @objc func authorLinkTapped() {
        presenter.authorLinkTapped()
    }
    
    @objc private func backButtonTapped() {
        presenter.backButtonTapped()
    }
    
    func configNavBackButton() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setStateOfFavButton(inCD: Bool) {
        if inCD {
            favButton.image = UIImage(systemName: "star.fill")
        } else {
            favButton.image = UIImage(systemName: "star")
        }
        favButton.isEnabled = true
    }
}

extension DetailedViewController: DetailedViewControllerProtocol {
    func show(selectedNews: NewsModel) {
        authorLabel.text = "\(String(localized: "Cell.Author")): \(selectedNews.author ?? (String(localized: "Cell.NoAuthor")))"
        dateLabel.text = "\(String(localized: "Cell.Date")): \(dateFormatter.string(from: selectedNews.createdAt))"
        titleLabel.text = "\(String(localized: "Cell.Title")): \(selectedNews.title)"
        descriptionLabel.text = "\(String(localized: "Cell.Description")): \(selectedNews.description ?? (String(localized: "Cell.NoDescription")))"
        sourceLinkLabel.text = "\(String(localized: "Detail.link")): \(selectedNews.sourceLink)"
        
        if selectedNews.image != nil {
            coverImageView.kf.setImage(with: selectedNews.image) { [weak self] result in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    let errorImage = UIImage(systemName: "photo")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                    self?.coverImageView.image = errorImage
                }
            }
        } else {
            let errorImage = UIImage(systemName: "photo")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            self.coverImageView.image = errorImage
        }
    }
}



private extension DetailedViewController {
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        [ coverImageView,
          authorLabel,
          dateLabel,
          titleLabel,
          descriptionLabel,
          sourceLinkLabel
        ].forEach { containerView.addSubview($0) }
        
        navigationItem.rightBarButtonItem = favButton
        
        view.backgroundColor = .systemBackground
        
        let safeArea = view.safeAreaLayoutGuide
        
        let smallSpacing: CGFloat = 8
        let coverImageHeight: CGFloat = 300
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: smallSpacing),
            coverImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -smallSpacing),
            coverImageView.heightAnchor.constraint(equalToConstant: coverImageHeight),
            
            authorLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: smallSpacing),
            authorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: smallSpacing),
            authorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -smallSpacing),
            
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: smallSpacing),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: smallSpacing),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -smallSpacing),
            
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: smallSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: smallSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -smallSpacing),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: smallSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: smallSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -smallSpacing),
            
            sourceLinkLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: smallSpacing),
            sourceLinkLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: smallSpacing),
            sourceLinkLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -smallSpacing),
            sourceLinkLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -smallSpacing)
            
        ])
        
    }
}
