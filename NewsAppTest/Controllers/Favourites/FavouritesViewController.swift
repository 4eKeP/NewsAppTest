//
//  FavoritesViewController.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import UIKit
import Kingfisher

#warning Добрый день тот кто будет это смотреть, надеюсь данный ворнинг проявит себя рано и с экономит время. Так вот, часть с CoreData работает хорошо, новости сохраняются в долгосрочную память и удаляются при нажатии на кнопку избранного, сетевой клиент работает и новости догружаются при пролистывании ленты. Теперь о плохом там где мне не хватило времени все доделать: к сожалению кнопка лайка не отображается корректно при добавлении в избранное она становиться закрашенной только после выхода на окно ленты и обратно в подробный просмотр, при удалении работает корректно, самой большой проблемой оказалось добаление и удаление с экрана избранного, в этот раз впервые решил попробовать "UITableViewDiffableDataSource" оказалось очень удобно и чистенько, но вот с удалением данных проблема, TableView просто ломается, еще я так много потратил время на починку TableView что не успел отладить кордату что бы все чистенько обновлялось, так что для обновления списка избранного надо перезапускать приложение, но опять же удаление и добавление в CoreData работают корректно. Спасибо если Ты дочитал до сюда, если возможно, буду рад любой критике особенно конструктивной и подсказки как довезти до ума это приложение, Заранее спасибо.


protocol FavouritesViewControllerProtocol: AnyObject, ErrorView {
    func updateData(with news: [NewsModel])
}

class FavouritesViewController: UIViewController, ErrorView {
    
    private let presenter: FavouritesViewPresenterProtocol
    
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
    
    init(presenter: FavouritesViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        refresh()
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
        presenter.loadFavNews()
        refreshControl.endRefreshing()
    }
}



//MARK: - UITableViewDelegate
extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = DetailScreenAssembler().setupDetailScreen(selectedNews: presenter.newsSelected(atRow: indexPath.row))
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     //   presenter.fetchNextPageIfNeeded(indexPath: indexPath)
    }
}

//MARK: - NewsListViewControllerProtocol

extension FavouritesViewController: FavouritesViewControllerProtocol {
    func updateData(with news: [NewsModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(news)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - UIConfig
extension FavouritesViewController {
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
    }
}
