//
//  SearchImagesVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 5/21/21.
//

import UIKit

class SearchImagesVC: ITDataLoadingVC {

    enum Section {
        case main
    }

    enum layoutScale {
        case twoColumn
        case threeColumn
        case fourColumn
    }

    let searchController = UISearchController()

    var imageData = [Item]()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var pinchGestureRecognizer: UIPinchGestureRecognizer!
    var currentLayoutScale: layoutScale = .twoColumn

    var emptyStateView: ITEmptyStateView?

    var hasMoreImages = true
    var isLoadingMoreImages = false
    var page = 1

    let q = "international%20space%20station"
    var currentQ = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        currentQ = q + "%202021"
        if imageData.isEmpty { getIssImages(text: currentQ, page: page) }
    }

    func configureViewController(){
        title = "Search Images"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]
    }

    func configureSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search by keywords (e.g. 'Astronauts')"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    func configureCollectionView(){
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: HelpfulFunctions.createColumnFlowLayout(in: view, itemHeightConstant: 0, hasHeaderView: false, columns: CGFloat(3)))
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ITNasaImageCell.self, forCellWithReuseIdentifier: ITNasaImageCell.reuseID)

        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(changeCollectionViewLayout(sender:)))

        collectionView.addGestureRecognizer(pinchGestureRecognizer)

        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            collectionView.heightAnchor.constraint(equalToConstant: view.bounds.height)
        ])
    }

    @objc
    func changeCollectionViewLayout(sender: UIPinchGestureRecognizer){
        guard sender.state == .ended else { return }
        print(pinchGestureRecognizer.scale)
        switch currentLayoutScale {
        case .twoColumn:
            if pinchGestureRecognizer.scale < 1.0 {
                currentLayoutScale = .threeColumn
            }
        case .threeColumn:
            if pinchGestureRecognizer.scale < 1.0 {
                currentLayoutScale = .fourColumn
            } else {
                currentLayoutScale = .twoColumn
            }
        case .fourColumn:
            if pinchGestureRecognizer.scale > 1.0 {
                currentLayoutScale = .threeColumn
            }
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            switch self.currentLayoutScale {
            case .twoColumn:
                self.collectionView.setCollectionViewLayout(HelpfulFunctions.createColumnFlowLayout(in: self.view, itemHeightConstant: 0, hasHeaderView: false, columns: 2), animated: true)
            case .threeColumn:
                self.collectionView.setCollectionViewLayout(HelpfulFunctions.createColumnFlowLayout(in: self.view, itemHeightConstant: 0, hasHeaderView: false, columns: 3), animated: true)
            case .fourColumn:
                self.collectionView.setCollectionViewLayout(HelpfulFunctions.createColumnFlowLayout(in: self.view, itemHeightConstant: 0, hasHeaderView: false, columns: 4), animated: true)
            }
        }
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, image) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ITNasaImageCell.reuseID, for: indexPath) as! ITNasaImageCell
            cell.set(image: image)
            return cell
        })
    }

    func getIssImages(text: String, page: Int){
        self.showLoadingView()
        self.isLoadingMoreImages = true
        
        NetworkManager.shared.conductNASAImageSearch(for: text, page: page) { [weak self] result in
            guard let self = self else { return }

            self.dismissLoadingView()
            self.isLoadingMoreImages = false
            switch result {
            case .success(let searchResults):
                self.updateUI(with: searchResults.collection.items)
            case .failure(let error):
                self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Try again") {
                    self.getIssImages(text: text, page: page)
                }
            }
        }
    }

    func updateUI(with images: [Item]){
        if images.count < 100 { self.hasMoreImages = false }
        self.imageData.append(contentsOf: images)

        if self.imageData.isEmpty {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let message = "No results found for search: \(String(describing: self.searchController.searchBar.text!))"
                self.showEmptyStateView(with: message, in: self.view)
                return
            }
        }
        self.updateData(on: self.imageData)
    }

    func updateData(on images: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(images)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }

    func resetSearch(){
        hasMoreImages = true
        isLoadingMoreImages = false
        page = 1
    }

    @objc func dismissVC(){
        dismiss(animated: true)
    }

    func showEmptyStateView(with message: String, in view: UIView){
        emptyStateView = ITEmptyStateView(message: message)
        emptyStateView!.frame = view.bounds
        view.addSubview(emptyStateView!)
    }
}

extension SearchImagesVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = imageData[indexPath.item]
        let imageViewerVC = ImageViewerVC()
        imageViewerVC.nasaImageView.downloadNasaImage(fromURL: image.links[0].href)
        imageViewerVC.nasaImageDescriptionLabel.text = image.data[0].description
        self.navigationController?.pushViewController(imageViewerVC, animated: true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            print("here")
            guard hasMoreImages, !isLoadingMoreImages else { return }
            page += 1
            getIssImages(text: currentQ, page: page)
        }
    }
}

extension SearchImagesVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchQuery = searchBar.text?.safeSearchQuery(), !searchQuery.isEmpty else {
            searchBar.text = ""
            return
        }

        if emptyStateView != nil { emptyStateView?.removeFromSuperview() }
        imageData.removeAll()
        currentQ = q + "%20" + searchQuery.replacingOccurrences(of: " ", with: "%20")
        resetSearch()
        getIssImages(text: currentQ, page: page)
    }
}
