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

    var imageData: [Item]!
    var filteredImageData: [Item] = []
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var pinchGestureRecognizer: UIPinchGestureRecognizer!
    var currentLayoutScale: layoutScale = .twoColumn

    var hasMoreImages = true
    var isSearching = false
    var isLoadingMoreImages = false
    var isSetToFilter = false
    var page = 1

    var waitAsecond = false

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
    }

    func configureViewController(){
        title = "ISS Images"

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]
    }

    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search by keyword (Ex: 'Astronauts')"
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .bookmark, state: .normal)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    func createTwoColumnFlowLayout(in view: UIView, itemHeightConstant: CGFloat, hasHeaderView: Bool) -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing)
        let itemWidth                   = availableWidth / 2

        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding*2, left: padding, bottom: padding*4, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + itemHeightConstant)

        if hasHeaderView { flowLayout.headerReferenceSize = CGSize(width: width, height: 160) }

        return flowLayout
    }

    func createThreeColumnFlowLayout(in view: UIView, itemHeightConstant: CGFloat, hasHeaderView: Bool) -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                   = availableWidth / 3

        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding*2, left: padding, bottom: padding*4, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + itemHeightConstant)

        if hasHeaderView { flowLayout.headerReferenceSize = CGSize(width: width, height: 160) }

        return flowLayout
    }

    func createFourColumnFlowLayout(in view: UIView, itemHeightConstant: CGFloat, hasHeaderView: Bool) -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 3)
        let itemWidth                   = availableWidth / 4

        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding*2, left: padding, bottom: padding*4, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + itemHeightConstant)

        if hasHeaderView { flowLayout.headerReferenceSize = CGSize(width: width, height: 160) }

        return flowLayout
    }

    func configureCollectionView(){
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: createTwoColumnFlowLayout(in: view, itemHeightConstant: 0, hasHeaderView: false))
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
                self.collectionView.setCollectionViewLayout(self.createTwoColumnFlowLayout(in: self.view, itemHeightConstant: 0, hasHeaderView: false), animated: true)
            case .threeColumn:
                self.collectionView.setCollectionViewLayout(self.createThreeColumnFlowLayout(in: self.view, itemHeightConstant: 0, hasHeaderView: false), animated: true)
            case .fourColumn:
                self.collectionView.setCollectionViewLayout(self.createFourColumnFlowLayout(in: self.view, itemHeightConstant: 0, hasHeaderView: false), animated: true)
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
                print(searchResults)
                self.updateUI(with: searchResults.collection.items)

            case .failure(let error):
                print(error.rawValue)
            }
        }
    }

    func updateUI(with images: [Item]){
        if images.count < 100 { self.hasMoreImages = false }
        self.imageData.append(contentsOf: images)
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
        isSearching = false
        isLoadingMoreImages = false
        page = 1
    }

    @objc func dismissVC(){
        dismiss(animated: true)
    }
}

extension SearchImagesVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredImageData : imageData
        let image = activeArray?[indexPath.item]

        let imageViewerVC = ImageViewerVC()
        imageViewerVC.nasaImageView.downloadNasaImage(fromURL: image!.links[0].href)
        let navController = UINavigationController(rootViewController: imageViewerVC)
        self.present(navController, animated: true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        print("HERE")

        if offsetY > contentHeight - height {
            guard hasMoreImages, !isLoadingMoreImages else { return }
            page += 1
            getIssImages(text: currentQ, page: page)
        }
    }
}

extension SearchImagesVC: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {

        guard let filter = searchController.searchBar.text, !filter.isEmpty, isSetToFilter else {
            filteredImageData.removeAll()
            updateData(on: imageData)
            isSearching = false
            return
        }
        isSearching = true

        filteredImageData = imageData.filter {
            var result = false
            let searchWords = filter.components(separatedBy: " ")
            for word in searchWords {
                if $0.data[0].description != nil {
                    if $0.data[0].description!.lowercased().contains(word.lowercased()){
                        result = true
                        print("contains \(word)")
                    }else {
                        result = false
                    }
                }else{
                    if $0.data[0].title.lowercased().contains(word.lowercased()){
                        result = true
                        print("contains \(word)")
                    }else {
                        result = false
                    }
                }
            }
            return result
        }
        updateData(on: filteredImageData)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HELLOOOOOO")
        guard let filter = searchBar.text, !filter.isEmpty, !isSetToFilter else {
            return
        }
        isSearching = true

        imageData.removeAll()
        currentQ = q + "%20" + filter.replacingOccurrences(of: " ", with: "%20")
        print(currentQ)
        resetSearch()
        getIssImages(text: currentQ, page: page)
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        isSetToFilter.toggle()
        searchController.searchBar.placeholder = isSetToFilter ? "Filter \(imageData.count) results" : "Search ISS Images"

        let img = !isSetToFilter ? UIImage(systemName: "line.horizontal.3.decrease") : UIImage(systemName: "line.horizontal.3.decrease.circle.fill")
        searchController.searchBar.setImage(img, for: .bookmark, state: .normal)
    }
}
