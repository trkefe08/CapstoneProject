//
//  SearchViewController.swift
//  CapstoneProject
//
//  Created by tarik.efe on 30.07.2022.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var searchNavigationItem: UINavigationItem!
    private var search: [ResultElement]? {
        didSet {
            table.reloadData()
        }
    }
    
    @IBOutlet var table: UITableView! {
        didSet {
            table.dataSource = self
            table.register(UINib(nibName: String(describing: CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CustomTableViewCell.self))
        }
    }
    
    private var pagination = 0
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        title = "Search"
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchNavigationItem.title = NSLocalizedString("Search", comment: "")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        Network.shared.getMovies(_type: Movie.self, with: NetworkConstants.baseURL + NetworkConstants.searchMovie + NetworkConstants.apiKey + NetworkConstants.query + "\(searchController.searchBar.text ?? "")") { (result) in
            switch result {
            case .success(let response):
                self.search = response.results
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomTableViewCell.self), for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = search?[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: DetailsViewController.self)) as? DetailsViewController else {
            return
        }
        detailsViewController.resultElement = search?[indexPath.row]
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            pagination += 1
            Network.shared.getMovies(_type: Movie.self, with: NetworkConstants.baseURL + NetworkConstants.popularMovie + NetworkConstants.apiKey + NetworkConstants.pageNumber + "\(pagination)") { (result) in
                switch result {
                case .success(let response):
                    self.search?.append(contentsOf: response.results ?? [])
                case .failure(let error):
                    print(error)
                }
            }
            self.table.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}


