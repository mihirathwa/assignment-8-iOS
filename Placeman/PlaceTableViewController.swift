// Copyright 2017 Mihir Rathwa,
//
// This license provides the instructor Dr. Tim Lindquist and Arizona
// State University the right to build and evaluate the package for the
// purpose of determining grade and program assessment.
//
// Purpose: This file contains the TableView Controller class as described
// in Assignment 8, it displays the list of Places from the App's Core Data
//
// Ser423 Mobile Applications
// see http://pooh.poly.asu.edu/Mobile
// @author Mihir Rathwa Mihir.Rathwa@asu.edu
// Software Engineering, CIDSE, ASU Poly
// @version April 27, 2017
//
//  PlaceTableViewController.swift
//  Placeman
//
//  Created by mrathwa on 4/27/17.
//  Copyright © 2017 mrathwa. All rights reserved.

import UIKit
import CoreData

var _segueIdentity = ""

class PlaceTableViewController: UITableViewController {
    
    var places = [String]()
    var appDelegate: AppDelegate?
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
         navigationItem.leftBarButtonItem = editButtonItem
        
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        context = appDelegate!.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceDescription")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context?.fetch(request)
            
            if (results?.count)! > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        places.append(name)
                    }
                }
            }
            
            self.tableView.reloadData()
        } catch {
            print("Unable to get all Places")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = places[indexPath.row]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceDescription")
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try context?.fetch(request)
                
                if (results?.count)! > 0 {
                    for result in results as! [NSManagedObject] {
                        if let name = result.value(forKey: "name") as? String {
                            if name == places[indexPath.row] {
                                context?.delete(result)
                            }
                            
                        }
                    }
                }
                
                do {
                    try context?.save()
                } catch {
                    print("Error in deleting Core Data")
                }
            } catch {
                print("Error Deleting Place from Core Data")
            }
            
            places.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "goToPlaceView" {
            _segueIdentity = "goToPlaceView"
            let indexPath = self.tableView.indexPathForSelectedRow!
            selectedPlace = places[indexPath.row]
        }
    }
    
    @IBAction func clickedAddButton(_ sender: UIBarButtonItem) {
        _segueIdentity = "addButtonSegue"
        performSegue(withIdentifier: "addButtonSegue", sender: self)
    }
    

}
