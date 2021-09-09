//
//  ImageViewerVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 5/21/21.
//

import UIKit

class ImageViewerVC: UIViewController {

    var nasaImageView = ITNasaImageView(frame: .zero)
    var nasaImageDescriptionLabel = ITBodyLabel(textAlignment: .left)
    var scrollView = UIScrollView()
    var contentView = UIView()
    var blurEffectView = UIVisualEffectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        configureViewController()
        configureScrollView()
        configureNASAImageView()
        configureNASADescriptionLabel()
        configureBlurView()
    }

    func configureViewController(){
        view.backgroundColor = .systemGray6

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        let descriptionButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showNASADescription))

        navigationItem.rightBarButtonItems = [doneButton, shareButton, descriptionButton]

        self.navigationController?.navigationBar.prefersLargeTitles = false
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

    func configureNASAImageView(){
        scrollView.addSubview(nasaImageView)

        NSLayoutConstraint.activate([
            nasaImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            nasaImageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -view.bounds.height * 0.1),
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

    func configureNASADescriptionLabel(){
        view.addSubview(nasaImageDescriptionLabel)
        nasaImageDescriptionLabel.numberOfLines = 0
        nasaImageDescriptionLabel.textColor = .white
        nasaImageDescriptionLabel.isHidden = true

        NSLayoutConstraint.activate([
            nasaImageDescriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nasaImageDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nasaImageDescriptionLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            nasaImageDescriptionLabel.heightAnchor.constraint(equalToConstant: 400)
        ])
    }

    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isHidden = true
        scrollView.addSubview(blurEffectView)
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

    @objc func showNASADescription() {
        scrollView.isUserInteractionEnabled.toggle()
        if blurEffectView.isHidden {
            blurEffectView.fadeIn()
            nasaImageDescriptionLabel.fadeIn()
        } else {
            blurEffectView.fadeOut()
            nasaImageDescriptionLabel.fadeOut()
        }
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
