//
//  PhotosVC.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import UIKit

final class PhotosVC: UIViewController {
    
    private let factory = PhotoCellBuilder()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let itemsPerRow: CGFloat = 3
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        return layout
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Введите тему для поиска и нажмите ввод"
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
               textField.font = UIFont.systemFont(ofSize: 14)
           }
        return searchBar
    }()
    
    private let tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: PhotosVC.self, action: #selector(hideKeyboard))
            gesture.cancelsTouchesInView = false
            return gesture
        }()
    
    private var collectionView: UICollectionView?
    private var networkService = NetworkService()
    private var isLoading = false
    private var query: String = ""
    private var photos: [DetailsPhotoModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupSearchBar()
        addKeyboardObservers()
        setupActivityIndicator()
        getRandomPhotos(completion: {})
        
        activityIndicator.startAnimating()
        getRandomPhotos {
            self.activityIndicator.stopAnimating()
        }
    }
    
    deinit {
        removeKeyboardObservers()
    }
}

extension PhotosVC {
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        guard let collectionView = collectionView else { return }
        
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isUserInteractionEnabled = true
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
    }
        private func setupSearchBar() {
            view.addSubview(searchBar)
            
            searchBar.delegate = self
            
            NSLayoutConstraint.activate([
                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                searchBar.heightAnchor.constraint(equalToConstant: 40),
                
                collectionView?.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
                collectionView?.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
                collectionView?.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
                collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].compactMap { $0 })
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    private func addKeyboardObservers() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    
    private func removeKeyboardObservers() {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
       }
    
    private func getRandomPhotos(completion: @escaping () -> Void) {
        networkService.fetchPhotos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                print("error")
                completion()
            case .success(let photos):
                self.factory.buildCellsModels(from: photos) { photos in
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: photos)
                        completion()
                    }
                }
            }
        }
    }
    
    private func getSearchPhotos(page: Int = 1) {
        networkService.fetchSearchPhoto(query: self.query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                print("error")
            case .success(let photos):
                self.factory.buildCellsModels(from: photos) { photos in
                    DispatchQueue.main.async {
                        self.photos = photos
                    }
                }
            }
        }
    }
    
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
}

extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell
        else { return UICollectionViewCell() }
        
        let urlString = photos[indexPath.item].smallImage?.absoluteString ?? ""
        cell.downloadImage(with: urlString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let infoVC = PhotoDetailsVC(photoModel: photos[indexPath.item])
        let navController = UINavigationController(rootViewController: infoVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
}

extension PhotosVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * (itemsPerRow - 1))
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return flowLayout.sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout.minimumInteritemSpacing
    }
}

extension PhotosVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        query = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getSearchPhotos()
    }
}

extension PhotosVC: UICollectionViewDataSourcePrefetching {
 
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxIndex = indexPaths.last?.item else { return }
        if maxIndex > photos.count - 7, !isLoading {
            isLoading = true
            getRandomPhotos {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}

