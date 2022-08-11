//
//  DetailsViewController.swift
//  CapstoneProject
//
//  Created by tarik.efe on 27.07.2022.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var overviewText: UITextView!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var nameLabel: UINavigationItem!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var originalLanguage: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var revenue: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var production: UILabel!
    
    var movie: MovieResult?
    var resultElement: ResultElement?
    var array: [ProductionCompany] = []
    var genreArray: [Genre] = []
    var movieCast: [CastElement]? = [] {
        didSet {
            castCollectionView.reloadData()
        }
    }
    var movieCastElement: CastElement?
    var castArray: Cast?
    var recommendationsMovie: [ResultElement]? = [] {
        didSet {
            recommendationsCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        recommendationsCollectionView.delegate = self
        recommendationsCollectionView.dataSource = self
        castCollectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastCollectionViewCell")
        recommendationsCollectionView.register(UINib(nibName: "RecommendationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendationsCollectionViewCell")
        configure(with: resultElement)
        
        Network.shared.getMovies(_type: Cast.self, with: NetworkConstants.baseURL + NetworkConstants.allMovie + "\(resultElement?.id ?? 0)" + NetworkConstants.credits + NetworkConstants.apiKey) { (result) in
            switch result {
            case .success(let response):
                self.movieCast = response.cast
            case .failure(let error):
                print(error)
            }
        }
        
        Network.shared.getMovies(_type: Movie.self, with: NetworkConstants.baseURL + NetworkConstants.allMovie + "\(resultElement?.id ?? 0)" + NetworkConstants.recommendations + NetworkConstants.apiKey) { (result) in
            switch result {
            case .success(let response):
                print( NetworkConstants.baseURL + NetworkConstants.allMovie + "\(self.resultElement?.id ?? 0)" + NetworkConstants.recommendations + NetworkConstants.apiKey)
                self.recommendationsMovie = response.results
            case .failure(let error):
                print(error)
            }
        }
        
        overviewLabel.text = NSLocalizedString("Overview", comment: "")
        originalTitle.text = NSLocalizedString("Original Title", comment: "")
        originalLanguage.text = NSLocalizedString("Original Language", comment: "")
        releaseDate.text = NSLocalizedString("Release Date", comment: "")
        budget.text = NSLocalizedString("Budget", comment: "")
        revenue.text = NSLocalizedString("Revenue", comment: "")
        genres.text = NSLocalizedString("Genres", comment: "")
        runtime.text = NSLocalizedString("Runtime", comment: "")
        production.text = NSLocalizedString("Production", comment: "")
        
    }
    
    func configure(with resultElement: ResultElement?) {
        
        Network.shared.getMovies(_type: MovieResult.self, with: NetworkConstants.baseURL + NetworkConstants.allMovie + "\(resultElement?.id ?? 0)" + NetworkConstants.apiKey) { (result) in
            switch result {
            case .success(let response):
                self.movie = response
                self.originalTitleLabel.text = self.movie?.originalTitle
                self.nameLabel.title = self.movie?.originalTitle ?? "no found"
                self.detailImageView.kf.setImage(with: URL.init(string: NetworkConstants.poster + ((self.movie?.posterPath) ?? "no found" )))
                self.originalLanguageLabel.text = self.movie?.originalLanguage ?? "no found"
                self.overviewText.text = self.movie?.overview ?? "no found"
                self.originalTitleLabel.text = self.movie?.originalTitle ?? "no found"
                self.releaseDateLabel.text = self.movie?.releaseDate ?? "no found"
                self.budgetLabel.text = String(describing: self.movie?.budget ?? 0)
                self.revenueLabel.text = String(describing: self.movie?.revenue ?? 0)
                self.genreArray = self.movie?.genres ?? []
                var genresArray: String = ""
                
                for genres in self.genreArray {
                    genresArray += (genres.name ?? "") + ", "
                }
                self.genresLabel.text = genresArray
                
                self.runtimeLabel.text = String(describing: self.movie?.runtime ?? 0)
                
                self.array = self.movie?.productionCompanies ?? []
                var productArray: String = ""
                
                for product in self.array {
                    productArray += (product.name ?? "") + ", "
                }
                self.productLabel.text = productArray
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.castCollectionView {
            return movieCast?.count ?? 0
        } else {
            return recommendationsMovie?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.castCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CastCollectionViewCell.self), for: indexPath) as? CastCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureCast(with: movieCast?[indexPath.row])
            return cell
        } else {
            guard let recommendationsCell = recommendationsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecommendationsCollectionViewCell.self), for: indexPath) as? RecommendationsCollectionViewCell else {
                return UICollectionViewCell()
            }
            recommendationsCell.configureRecommendations(with: recommendationsMovie?[indexPath.row])
            return recommendationsCell
        }
    }
}
