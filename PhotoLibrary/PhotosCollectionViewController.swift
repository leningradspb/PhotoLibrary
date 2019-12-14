//
//  PhotosCollectionViewController.swift
//  PhotoLibrary
//
//  Created by Eduard Sinyakov on 20/08/2019.
//  Copyright © 2019 Eduard Sinyakov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotosCell"

class PhotosCollectionViewController: UICollectionViewController {
    
    var networdDataFetcher = NetworkDataFetcher()
    
    private var timer: Timer?
    
    private var photos = [UnsplashPhoto]()
    
    // выбранные картинки для отправки
    private var selectedImages = [UIImage]()
   
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    // сколько рядов
    private let itemsPerRow: CGFloat = 2
    private var sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        setupCollectionView()
        setupSearchBar()
        setupNavigationBar()
        updateNavigationButtonState()
        

        
    } // end viewDidLoad
    
    func updateNavigationButtonState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    // MARK: - Функция для обновления UI (чтобы спадали выбранные картинки после отправки через activity
    func refresh() {
        self.selectedImages.removeAll()
        // чтобы коллекшн вью был опять вверху
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavigationButtonState()
    }
    
    
    private func setupCollectionView() {
        
        collectionView.backgroundColor = .white
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseID)
        
        // методы делегата flowLayout
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        // возможность выбирать несколько ячеек
        collectionView.allowsMultipleSelection = true
    }
    
     private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }
    
    // MARK: - Navigation objc methods
    
    @objc func addBarButtonTapped() {
        
    }
    
    @objc func actionBarButtonTapped(sender: UIBarButtonItem) {
        
        let sharedController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        
        sharedController.completionWithItemsHandler = {_, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        
        // две строчки нужны, чтобы хорошо отображалось на iPad
        sharedController.popoverPresentationController?.barButtonItem = sender
        sharedController.popoverPresentationController?.permittedArrowDirections = .any
        present(sharedController, animated: true, completion: nil)
    }
    
    // MARK: SearchBar
     func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
    }

  

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseID, for: indexPath) as! PhotosCell
    
        // конкретная фотография (в tv вместо row item)
        let unsplashedPhoto = photos[indexPath.item]
        
        cell.unsplashPhoto = unsplashedPhoto
        
       // cell.backgroundColor = .blue
    
        return cell
    }
    
    // MARK: - проверяем выбрана ячейка или выбор отменен
    
    // добавляем
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        updateNavigationButtonState()
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else {return}
        
        
        selectedImages.append(image)
        
    }
    
    // убираем
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        updateNavigationButtonState()
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else {return}
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }


    }

} // end of class

// MARK: UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networdDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                
//                searchResults?.results.map({ (photo) in
//                    print(photo.urls["small"])
//                })
                guard let searchedPhotos = searchResults else {return}
                self?.photos = searchedPhotos.results
                self?.collectionView.reloadData()
                self?.refresh()
            }
        })
        
       
        
 
           // print(searchText)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: - Размер конкретной ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let paddigSpace = sectionInserts.left * (itemsPerRow + 1)
        let avaliableWidth = view.frame.width - paddigSpace
        let widthPerItem = avaliableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
