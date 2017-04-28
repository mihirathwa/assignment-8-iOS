//
//  PlaceDescriptionViewController.swift
//  Placeman
//
//  Created by mrathwa on 4/27/17.
//  Copyright © 2017 mrathwa. All rights reserved.
//

import UIKit
import CoreData

var selectedPlace = ""

class PlaceDescriptionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var places = [String]()
    var firstLatitude = 0.0
    var firstLongitude = 0.0
    
    @IBOutlet weak var UIName: UITextField!
    @IBOutlet weak var UIDescription: UITextView!
    @IBOutlet weak var UICategory: UITextField!
    @IBOutlet weak var UIAddressTitle: UITextField!
    @IBOutlet weak var UIAddressStreet: UITextView!
    @IBOutlet weak var UIElevation: UITextField!
    @IBOutlet weak var UILatitude: UITextField!
    @IBOutlet weak var UILongitude: UITextField!

    @IBOutlet weak var UIDistance: UILabel!
    @IBOutlet weak var UIBearing: UILabel!
    
    @IBOutlet weak var UIPlacePicker: UIPickerView!
    
    var appDelegate: AppDelegate?
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        context = appDelegate!.persistentContainer.viewContext
        
        if _segueIdentity == "goToPlaceView" {
            setUIWithCoreData()
            getAllPlaces()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return places.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return places[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var secondLatitude: Double = 0.0
        var secondLongitude: Double = 0.0
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceDescription")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context?.fetch(request)
            
            if (results?.count)! > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        
                        if name == places[row] {
                            secondLatitude = (result.value(forKey: "latitude") as? Double)!
                            secondLongitude = (result.value(forKey: "longitude") as? Double)!
                        }
                        
                    }
                }
            }
            
            let greatCircle = calculateGreatCircle(firstLatitude: firstLatitude, firstLongitude: firstLongitude, secondLatitude: secondLatitude, secondLongitude: secondLongitude)
            let initialBearing = calculateInitialBearing(firstLatitude: firstLatitude, firstLongitude: firstLongitude, secondLatitude: secondLatitude, secondLongitude: secondLongitude)
            
            UIDistance.text = "Distance: " + String(greatCircle)
            UIBearing.text = "Initial Bearing: " + String(initialBearing)
        } catch {
            print("Unable to get all Places")
        }
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
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceDescription")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context?.fetch(request)
            
            if (results?.count)! > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        if name == selectedPlace {
                            context?.delete(result)
                        }
                        
                    }
                }
            }
            
            do {
                try context?.save()
                performSegue(withIdentifier: "goToTableView", sender: self)
            } catch {
                print("Error in deleting Core Data")
            }
        } catch {
            print("Error Deleting Place from Core Data")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUIWithCoreData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceDescription")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context?.fetch(request)
            
            if (results?.count)! > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        if name == selectedPlace {
                            UIName.text = result.value(forKey: "name") as? String
                            UIDescription.text = result.value(forKey: "pdescription") as? String
                            UICategory.text = result.value(forKey: "category") as? String
                            UIAddressTitle.text = result.value(forKey: "address_title") as? String
                            UIAddressStreet.text = result.value(forKey: "address_street") as? String
                            
                            let firstElevation = result.value(forKey: "elevation") as? Double
                            firstLatitude = (result.value(forKey: "latitude") as? Double)!
                            firstLongitude = (result.value(forKey: "longitude") as? Double)!
                            
                            UIElevation.text = "\(firstElevation)"
                            UILatitude.text = "\(firstLatitude)"
                            UILongitude.text = "\(firstLongitude)"
                        }
                    }
                }
            }
        } catch {
            print("Error getting Place Description Details")
        }
    }
    
    func getAllPlaces() {
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
        } catch {
            print("Unable to get all Places")
        }
    }
    
    func calculateGreatCircle(firstLatitude: Double,
                              firstLongitude: Double,
                              secondLatitude: Double,
                              secondLongitude: Double) -> Double{
        var greatDistance: Double
        let toRadians: Double = M_PI / 180
        
        let rValue: Double = 6371 * pow(10, 3)
        
        let phi1: Double = firstLatitude * toRadians
        let phi2: Double = secondLatitude * toRadians
        
        let deltaPhi: Double = (secondLatitude - firstLatitude) * toRadians
        let deltaLambda: Double = (secondLongitude - firstLongitude) * toRadians
        
        let aValue: Double = sin(deltaPhi / 2) * sin(deltaPhi / 2) + cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2)
        
        let cValue: Double = 2 * atan2(sqrt(aValue), sqrt(1-aValue))
        
        greatDistance = rValue * cValue
        
        return greatDistance
    }
    
    func calculateInitialBearing(firstLatitude: Double,
                                 firstLongitude: Double,
                                 secondLatitude: Double,
                                 secondLongitude: Double) -> Double{
        var bearing: Double
        
        let toRadians: Double = M_PI / 180
        
        let phi1: Double = firstLatitude * toRadians
        let lambda1: Double = firstLongitude * toRadians
        
        let phi2: Double = secondLatitude * toRadians
        let lambda2: Double = secondLongitude * toRadians
        
        let yValue: Double = sin(lambda2 - lambda1) * cos(phi2)
        let xValue: Double = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(lambda2 - lambda1)
        
        let aTan2Value: Double = atan2(yValue, xValue)
        
        bearing = aTan2Value * ( 180 / M_PI )
        
        return bearing
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
