//
//  ViewController.swift
//  CapstoneProject
//
//  Created by tarik.efe on 25.07.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var navigationLabel: UINavigationItem!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.register(UINib(nibName: String(describing: CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CustomTableViewCell.self))
        }
    }
    
    private var movies: [ResultElement]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var pagination = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        
        Network.shared.getMovies(_type: Movie.self, with: NetworkConstants.baseURL + NetworkConstants.popularMovie + NetworkConstants.apiKey) { (result) in
            switch result {
            case .success(let response):
                self.movies = response.results
            case .failure(let error):
                print(error)
            }
        }
        tableView.delegate = self
        
        navigationLabel.title = NSLocalizedString("Movies", comment: "")
        
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomTableViewCell.self), for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies?[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: DetailsViewController.self)) as? DetailsViewController else {
            return
        }
        detailsViewController.resultElement = movies?[indexPath.row]
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
                    self.movies?.append(contentsOf: response.results ?? [])
                case .failure(let error):
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
    }
}




