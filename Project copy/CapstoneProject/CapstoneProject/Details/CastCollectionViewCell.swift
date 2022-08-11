//
//  CastCollectionViewCell.swift
//  CapstoneProject
//
//  Created by tarik.efe on 9.08.2022.
//

import UIKit
import Kingfisher

class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var castNameCell: UILabel!
    
    func configureCast(with castMovie: CastElement?) {
        self.nameCell.text = castMovie?.name
        self.castNameCell.text = castMovie?.character
        self.imageViewCell.kf.setImage(with: URL.init(string: NetworkConstants.poster + ((castMovie?.profilePath) ?? "no found" )))
    }

}
