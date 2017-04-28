//
//  PlaceDescriptionViewController.swift
//  Placeman
//
//  Created by mrathwa on 4/27/17.
//  Copyright © 2017 mrathwa. All rights reserved.
//

import UIKit
import CoreData

class PlaceDescriptionViewController: UIViewController {
    @IBOutlet weak var UIName: UITextField!
    @IBOutlet weak var UIDescription: UITextView!
    @IBOutlet weak var UICategory: UITextField!
    @IBOutlet weak var UIAddressTitle: UITextField!
    @IBOutlet weak var UIAddressStreet: UITextView!
    @IBOutlet weak var UIElevation: UITextField!
    @IBOutlet weak var UILatitude: UITextField!
    @IBOutlet weak var UILongitude: UITextField!

    @IBOutlet weak var UIDistance: UILabel!
    
    @IBOutlet weak var UIPlacePicker: UIPickerView!
    
    var appDelegate: AppDelegate?
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        context = appDelegate!.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceDescription")
        
        request.returnsObjectsAsFaults = false
        
//        do {
//            let results = try context?.fetch(request)
//            
//            if (results?.count)! > 0 {
//                for result in results as! [NSManagedObject] {
//                    if let name = result.value(forKey: "name") as? String {
//                        
//                        //                        if name == "Colorado" {
//                        //                           context.delete(result)
//                        //                        }
//                        
//                        //                        result.setValue(name + "s", forKey: "name")
//                        //                        editing places if name == "myname"
//                        //                        do {
//                        //                            try context.save()
//                        //                        } catch {
//                        //
//                        //                        }
//                        //
//                        print (name)
//                    }
//                    if let desc = result.value(forKey: "pdescription") as? String {
//                        print (desc)
//                    }
//                }
//            }
//        } catch {
//            
//        }
    }
    
    @IBAction func clickedSaveButton(_ sender: UIButton) {
        let newPlaceName: String = UIName.text!
        let newPlaceDescription: String = UIDescription.text!
        let newPlaceCategory: String = UICategory.text!
        let newPlaceAddressTitle: String = UIAddressTitle.text!
        let newPlaceAddressStreet: String = UIAddressStreet.text!
        let newPlaceElevation: Double = Double(UIElevation.text!)!
        let newPlaceLatitude: Double = Double(UILatitude.text!)!
        let newPlaceLongitude: Double = Double(UILongitude.text!)!
        
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "PlaceDescription", into: context!)
        
        newPlace.setValue(newPlaceName, forKey: "name")
        newPlace.setValue(newPlaceDescription, forKey: "pdescription")
        newPlace.setValue(newPlaceCategory, forKey: "category")
        newPlace.setValue(newPlaceAddressTitle, forKey: "address_title")
        newPlace.setValue(newPlaceAddressStreet, forKey: "address_street")
        newPlace.setValue(newPlaceElevation, forKey: "elevation")
        newPlace.setValue(newPlaceLatitude, forKey: "latitude")
        newPlace.setValue(newPlaceLongitude, forKey: "longitude")
        
        do {
            try context?.save()
            print ("Saved Place to Core Data")
            performSegue(withIdentifier: "goToTableView", sender: self)
        } catch {
            print("Error while saving Place")
        }
    }
    
    @IBAction func clickedDeleteButton(_ sender: UIButton) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
