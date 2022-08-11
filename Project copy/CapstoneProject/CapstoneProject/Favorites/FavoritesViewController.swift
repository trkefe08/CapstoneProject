//
//  FavoritesViewController.swift
//  CapstoneProject
//
//  Created by tarik.efe on 4.08.2022.
//

import UIKit
import CoreData


class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var favoritesItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.register(UINib(nibName: String(describing: FavoritesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FavoritesTableViewCell.self))
        }
    }
    
    var favoriteMovies: [ResultElement]?
    var nameArray = [String]()
    var idArray = [UUID]()
    var sourceID = UUID?.self
    var imageArray = [String]()
    var dateArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        
        favoritesItem.title = NSLocalizedString("Favorites", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    
    @objc func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                
                if let name = result.value(forKey: "name") as? String {
                    self.nameArray.append(name)
                    
                }
                
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                
                if let imageData = result.value(forKey: "image") as? String {
                    self.imageArray.append(imageData)
                    
                }
                
                if let date = result.value(forKey: "date") as? String {
                    self.dateArray.append(date)
                }
                self.tableView.reloadData()
            }
            
        } catch {
            print("error")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
            cell.movieNameLabel.text = nameArray[indexPath.row]
            cell.movieReleaseDateLabel.text = dateArray[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        let idString = idArray[indexPath.row].uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let _ = result.value(forKey: "id") as? UUID {
                    context.delete(result)
                    nameArray.remove(at: indexPath.row)
                    idArray.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    
                    do {
                        try context.save()
                    } catch {
                        
                    }
                }
            }
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: DetailsViewController.self)) as? DetailsViewController else {
            return
        }
        detailsViewController.resultElement = favoriteMovies?[indexPath.row]
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

