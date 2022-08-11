//
//  CustomTableViewCell.swift
//  CapstoneProject
//
//  Created by tarik.efe on 25.07.2022.
//

import UIKit
import Kingfisher
import CoreData

class CustomTableViewCell: UITableViewCell {

    var movie: ResultElement?
    
    @IBOutlet weak var voteAverageLabel: UILabel! {
        didSet {
            voteAverageLabel.layer.cornerRadius = voteAverageLabel.frame.width/2
            voteAverageLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var movieImageView: UIImageView! {
        didSet {
            movieImageView.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with movies: ResultElement?) {
        movie = movies
        movieNameLabel.text = movies?.originalTitle ?? "no found"
        movieImageView.kf.setImage(with: URL.init(string: NetworkConstants.poster + ((movies?.posterPath) ?? "no found" )))
        releaseDateLabel.text = movies?.releaseDate ?? "no found"
        voteAverageLabel.text = String(format: "%.1f", movies?.voteAverage ?? "no found")
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        
        if sender.tintColor != UIColor.red {
            sender.tintColor = .red
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let saveData = NSEntityDescription.insertNewObject(forEntityName: "Data", into: context)
            saveData.setValue(movieNameLabel.text, forKey: "name")
            saveData.setValue("", forKey: "image")
            saveData.setValue(releaseDateLabel.text, forKey: "date")
            saveData.setValue(UUID(), forKey: "id")
            do {
                try context.save()
                print("success")
            } catch {
                print("error")
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "newData"), object: nil)
            
        } else {
            
            sender.tintColor = .gray
            
        }
    }
}
