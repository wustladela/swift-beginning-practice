//
//  MealTableViewController.swift
//  MyFoodTracker
//
//  Created by Adela Gao on 1/11/16.
//  Copyright © 2016 Adela Gao. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
//you can now define a property to store a list of Meal objects.
    
    // MARK: Properties
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            loadSampleMeals()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        saveMeals()
    }

    func loadSampleMeals(){
        let photo1 = UIImage(named: "photo1")
        let meal1 = Meal(name: "Salads", photo: photo1, rating: 4)!
        let photo2 = UIImage(named: "photo2")
        let meal2 = Meal(name: "Sandwiches", photo: photo2, rating: 5)!
        let photo3 = UIImage(named: "photo3")
        let meal3 = Meal(name: "Noodles", photo: photo3, rating: 3)!
        meals+=[meal1, meal2, meal3]
        
        
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // This code fetches the appropriate meal in the meals array.
        let meal = meals[indexPath.row]
        // Configure the cell...
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    /* you don't need this for now... right?
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    */
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            meals.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        saveMeals()
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetail" {
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)
                let selectedMeal = meals[indexPath!.row]
                mealDetailViewController.meal = selectedMeal
            }
        } else if segue.identifier == "AddItem" {
            print ("Adding new meal.")
        }
        
    }
    
    
    @IBAction func unwindToMeallist(sender: UIStoryboardSegue){

        if let sourceViewController = sender.sourceViewController as?
            MealViewController, meal = sourceViewController.meal {
                // if editing an existing meal, update it
                if let selectedIndexPath = tableView.indexPathForSelectedRow{
                    meals[selectedIndexPath.row] = meal
                    tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Automatic)
                }
            // add a new meal
                else {
                    let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                    meals.append(meal)
                    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                }
        } 
        
    }
    
    // MARK: NSCoding
    
    func saveMeals(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        if !isSuccessfulSave {
            let alert = UIAlertController(title: "Attention", message: "Meals cannot be saved due to some error. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Success", message: "Meals updated successfully!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
    }
    
    // Logan's comments: for larger scale save, disconnect the save barButton from the exit,
    // and make another class that handles the database and make another view controller from that class that calls saveMeals()
    
    
}


