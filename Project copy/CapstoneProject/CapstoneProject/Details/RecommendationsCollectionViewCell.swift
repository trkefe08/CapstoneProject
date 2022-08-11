//
//  RecommendationsCollectionViewCell.swift
//  CapstoneProject
//
//  Created by tarik.efe on 9.08.2022.
//

import UIKit
import Kingfisher

class RecommendationsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    
    func configureRecommendations(with recommendationsElement: ResultElement?) {
        
        self.imageCell.kf.setImage(with: URL.init(string: NetworkConstants.poster + ((recommendationsElement?.posterPath) ?? "no found" )))
    }
}
