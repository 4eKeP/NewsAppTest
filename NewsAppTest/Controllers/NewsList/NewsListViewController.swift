//
//  ViewController.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import UIKit
import Kingfisher

protocol NewsListViewControllerProtocol: AnyObject, ErrorView {
    func updateData(with news: [NewsModel])
}

class NewsListViewController: UIViewController, ErrorView {
    
    private let presenter: NewsListPresenterProtocol
    
    enum Section {
        case main
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, NewsModel> = {
        UITableViewDiffableDataSource<Section, NewsModel>(
            tableView: tableView,
            cellProvider: {[weak self] (tableView, indexPath, news) -> UITableViewCell? in
                guard let self else { return UITableViewCell()}
                let cell: NewsListCell = tableView.dequeueReusableCell()
                cell.makeCell(news: news)
                cell.selectionStyle = .default
                return cell
            })
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsListCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let tableViewSpacing: CGFloat = 16
    
    init(presenter: NewsListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        refresh()
    }
    
    @objc func refresh() {
        presenter.loadInitialNews()
        refreshControl.endRefreshing()
    }
}



//MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.newsSelected(atRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.fetchNextPageIfNeeded(indexPath: indexPath)
    }
}

//MARK: - NewsListViewControllerProtocol

extension NewsListViewController: NewsListViewControllerProtocol {
    func updateData(with news: [NewsModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(news)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - UIConfig
extension NewsListViewController {
    func configUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.refreshControl = refreshControl
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: tableViewSpacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tableViewSpacing),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tableViewSpacing),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tableViewSpacing),
        ])
        
     //   tableView.estimatedRowHeight = 44
      //  tableView.rowHeight = UITableView.automaticDimension
    }
}


