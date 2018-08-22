//
//  ViewController.swift
//  Assignment_Flickr
//
//  Created by Nishu Priya on 8/21/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import UIKit

class ShowPhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var viewModel: ShowPhotosViewModel = ShowPhotosViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        configureViewModel()
    }
    
    // MARK: Private methods
    private func configureViewModel() {
        viewModel.photosFetchFailureHandler = { [weak self] in
            self?.infoLabel.isHidden = false
            self?.infoLabel.text = self!.viewModel.kNoResutsText
            self?.collectionView.reloadData()
            self?.collectionView.isHidden = true
        }
        
        viewModel.photosFetchSuccessHandler = { [weak self] in
            self?.collectionView.isHidden = false
            self?.infoLabel.isHidden = true
            self?.collectionView.reloadData()
        }
        viewModel.nextBatchOfPhotosFetchSuccessHandler = { [weak self] indexPaths in
            self?.collectionView.isHidden = false
            self?.infoLabel.isHidden = true
            self?.collectionView.insertItems(at: indexPaths)
        }
    }
    private func configureCollectionView() {
        collectionView.collectionViewLayout = flowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func flowLayout() -> UICollectionViewFlowLayout {
        let sizeRect = UIScreen.main.bounds
        let deviceWidth = sizeRect.size.width - 4//leading trailing
        let cellSide = (deviceWidth - 4)/3
        let customFlowLayout = UICollectionViewFlowLayout()
        customFlowLayout.scrollDirection = .vertical
        customFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        customFlowLayout.minimumInteritemSpacing = 0
        customFlowLayout.minimumLineSpacing = 2
        customFlowLayout.itemSize = CGSize(width: cellSide, height: cellSide)
        return customFlowLayout
    }
    
    
    // MARK: UIScrollViewDelegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            if scrollView.isAlmostAtBottom {
                viewModel.fetchPhotos(searchText: searchBar.text!)
            }
        }
    }
    
    // MARK: UICollectionViewDelegate and dataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.kResuseIdentifier, for: indexPath) as? PhotoCollectionViewCell
        cell?.imageView.image = nil
        
        return cell ?? UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = viewModel.photos[indexPath.row]
        let id = ImageDownloader.downloadImage(url: URL(string: photo.url)!) { (image) in
            DispatchQueue.main.async {
                let updatedCell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell
                if let updatedCell = updatedCell {
                    updatedCell.imageView.image = image
                }
            }
        }
        self.viewModel.taskIdenfiers[indexPath.row] = id
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.taskIdenfiers.indices.contains(indexPath.row) {
            if let taskId = viewModel.taskIdenfiers[indexPath.row] {
                ImageDownloader.cancelTaskWith(identifier: taskId)
            }
        }
    }
    
    // MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.pageNum = 0
        viewModel.fetchPhotos(searchText: searchBar.text!)
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != "" {
            searchBar.showsCancelButton = true
        } else {
            searchBar.showsCancelButton = false
        }
    }
}

