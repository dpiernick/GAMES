//
//  DetailVC.swift
//  GAMES!
//
//  Created by Piernick, Dave on 6/12/19.
//  Copyright © 2019 Piernick, Dave. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DetailVC: UIViewController {

    var game = Game()
    var image: UIImage?

    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = game.name

        if let image = image {
            detailImageView.image = image
        } else {
            guard let imageURLValue = game.imageDict?.originalURL else { return }
            guard let imageURL = URL(string: imageURLValue) else { return }
            Networking.getImage(url: imageURL) { (data, error) in
                guard let data = data, let image = UIImage(data: data) else { return }
                self.detailImageView.image = image
            }
        }

        if let description = game.description {
            webview.loadHTMLString(description, baseURL: nil)
        } else {
            descriptionLabel.text = "No Description Available!"
        }
    }
}
