//
//  SearchViewController.swift
//  GAMES!
//
//  Created by Piernick, Dave on 6/12/19.
//  Copyright © 2019 Piernick, Dave. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var games = [Game]()
    var request: URLSessionTask?
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        navigationItem.title = "Search For A Game!"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailVC =  segue.destination as! DetailVC
            detailVC.game = games[selectedIndex]
        }
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if Networking.isConnectedToInternet() {
            request?.cancel()
            request = Networking.search(searchTerm: searchText) { (games, error) in
                self.games = games
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
//        } else {
//            let alertController = UIAlertController(title: "AHHHH!", message: "You don't have internet bro.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(okAction)
//            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
//        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell")!

        var game = games[indexPath.row]

        cell.textLabel?.text = "\(game.name ?? "")"
        cell.imageView?.image = UIImage(named: "ImagePlaceholder")

        guard let imageURLValue = game.imageDict?.originalURL else { return cell }
        guard let imageURL = URL(string: imageURLValue) else { return cell }
        Networking.getImage(url: imageURL) { (data, error) in
            if let data = data, let image = UIImage(data: data) {
                game.image = image
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
