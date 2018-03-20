//
//  FASwiftViewController.swift
//  FAJsonParser_Example
//
//  Created by Fadi Abuzant on 2/26/18.
//  Copyright © 2018 fadizant. All rights reserved.
//

import UIKit
import FAJsonParser

class FASwiftViewController: UIViewController {

    // MARK:- UI
    @IBOutlet weak var previewTextView: UITextView!
    
    // MARK:- Override
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // get JSON from file
        let dict = JSONFromFile()
        
        // parse JSON to object
        let object = FAObject_Swift()
        
        // fill JSON to object
        dict.fillThisObject(object)
        
        // Save object in UserDefaults
        print("Object saved ? \(object.save(withKey: "objectKey_swift") ? "True" : "False")")
        
        //load object from UserDefaults
        let newObject = FAObject_Swift()
        print("Object loaded ? \(newObject.load(withKey: "objectKey_swift") ? "True" : "False")")
        
        // generate dictionary from object
        let dictFromObject = newObject.dictionary()
        
        // print dictionary
        previewTextView.text = dictFromObject?.description
        print(dictFromObject?.description ?? "")
        
        /* with error to return if happend
        do{
            try dict.fillThisObject(object)
            
            // generate dictionary from object
            do{
                let dictFromObject = try object.dictionary()
                previewTextView.text = dictFromObject.description
            }
            catch let error as NSError{
                print(error.userInfo)
            }
        }
        catch let error as NSError{
            print(error.userInfo)
        }
        */

    }
    
    func JSONFromFile() -> NSDictionary {
        if let path = Bundle.main.path(forResource: "Data", ofType: "geojson") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    // do stuff
                    return jsonResult as NSDictionary
                }
            } catch {
                // handle error
            }
        }
        return NSDictionary()
    }
}
