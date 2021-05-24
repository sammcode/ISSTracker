//
//  ImageViewerVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 5/21/21.
//

import UIKit

class ImageViewerVC: UIViewController {

    var nasaImageView = ITNasaImageView(frame: .zero)
    var scrollView = UIScrollView()
    var contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        configureViewController()
        configureScrollView()
        configureNasaImageView()
    }

    func configureViewController(){
        title = "Image Viewer"
        view.backgroundColor = .systemGray6

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton

        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        navigationItem.leftBarButtonItem = shareButton

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]
    }

    func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.pinToEdges(of: view)

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0

        scrollView.decelerationRate = .fast
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false

        scrollView.delegate = self

        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGest)

        let longPressGest = UILongPressGestureRecognizer(target: self, action: #selector(shareImage))
        scrollView.addGestureRecognizer(longPressGest)
    }

    func configureNasaImageView(){
        scrollView.addSubview(nasaImageView)

        NSLayoutConstraint.activate([
            nasaImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            nasaImageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -view.bounds.width * 0.08),
            nasaImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            nasaImageView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.75)
        ])

        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size

        nasaImageView.layer.cornerRadius = 0
        nasaImageView.contentMode = .scaleAspectFit
    }

    @objc func shareImage(){
        let img: UIImage = nasaImageView.image!
        let shareItems: Array = [img]

        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)

        self.present(activityViewController, animated: true)
    }

    @objc func dismissVC(){
        self.dismiss(animated: true)
    }

    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in:recognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = nasaImageView.frame.size.height / scale
        zoomRect.size.width  = nasaImageView.frame.size.width  / scale
        let newCenter = nasaImageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

extension ImageViewerVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nasaImageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > scrollView.maximumZoomScale {
            scrollView.zoomScale = scrollView.maximumZoomScale
        } else if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
    }
}
