//
//  FavoritesVC.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import UIKit

final class FavoritesVC: UIViewController {
    
    private var photos: [DetailsPhotoModel] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isUserInteractionEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photos = Favorites.shared.favorites
        tableView.reloadData()
    }
}

extension FavoritesVC {
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.register(
            FavoritePhotoCell.self,
            forCellReuseIdentifier: FavoritePhotoCell.identifier
        )
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePhotoCell.identifier,
                                                       for: indexPath) as? FavoritePhotoCell
        else { return UITableViewCell() }
        cell.configure(with: photos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoVC = PhotoDetailsVC(photoModel: photos[indexPath.row])
        let navController = UINavigationController(rootViewController: infoVC)
        navController.modalPresentationStyle = .fullScreen
        tableView.deselectRow(at: indexPath, animated: true)
        self.present(navController, animated: true)
    }
}
