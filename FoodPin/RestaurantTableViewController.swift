//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 11/8/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    var restaurants:[Restaurant] = []
    
    var fetchResultController:NSFetchedResultsController!
    
    var searchController: UISearchController!
    
    var searchResults: [Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Empty back button title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        // Self Sizing Cells
        self.tableView.estimatedRowHeight = 80.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        var fetchRequest = NSFetchRequest(entityName: "Restaurant")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as
            AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            var e: NSError?
            var result = fetchResultController.performFetch(&e)
            restaurants = fetchResultController.fetchedObjects as [Restaurant]
            
            if result != true {
            println(e?.localizedDescription)
            }
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController.hidesBarsOnSwipe = true
        navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if searchController.active {
         return searchResults.count
        } else {
        return self.restaurants.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CustomTableViewCell
        
        // Configure the cell...
        let restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.name
        cell.thumbnailImageView.image = UIImage(data: restaurant.image)
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        cell.favorIconImageView.hidden = !restaurant.isVisited.boolValue

        // Circular image
        cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2
        cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
    
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: nil)
            let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default, handler: nil)
            let emailAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(facebookAction)
            shareMenu.addAction(emailAction)
            shareMenu.addAction(cancelAction)
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
            }
        )
    
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete",handler: {
            (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            // Delete the row from the data source
                if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
                
                let restaurantToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as Restaurant
                managedObjectContext.deleteObject(restaurantToDelete)
                
                var e: NSError?
                if managedObjectContext.save(&e) != true {
                println("delete error:  + \(e!.localizedDescription)")
                }
                
                }
            }
        )

        deleteAction.backgroundColor = UIColor(red: 230.0/255.0, green: 74.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        shareAction.backgroundColor = UIColor(red: 114.0/255.0, green: 114.0/255.0, blue: 114.0/255.0, alpha: 1.0)

        return [deleteAction, shareAction]
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showRestaurantDetail" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationController = segue.destinationViewController as DetailViewController
                destinationController.restaurant = (searchController.active) ? searchResults[row] : restaurants[row]
            }
        }
    }


    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {

    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
            tableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!,
            atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType,
            newIndexPath: NSIndexPath!) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            tableView.reloadData()
            }
        restaurants = controller.fetchedObjects as [Restaurant]
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
            tableView.endUpdates()
    }
    
    func filterContentForSearchText(searchText: String) {
        searchResults = restaurants.filter({ (restaurant: Restaurant) -> Bool in
            let nameMatch = restaurant.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            return nameMatch != nil
        })
        
        searchResults += restaurants.filter({ (restaurant: Restaurant) -> Bool in
            let locationMatch = restaurant.location.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            return locationMatch != nil
        })

    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        filterContentForSearchText(searchText)
        
        tableView.reloadData()
    }

}
