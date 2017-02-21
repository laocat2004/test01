//
//  DetailViewController.swift
//  test01
//
//  Created by Luis Topiltzin Dominguez Butron on 12/19/16.
//  Copyright © 2016 Luis Topiltzin Dominguez Butron. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var creationDateLabel: UILabel = UILabel()
    var greetLabel: UILabel = UILabel()
    var idLabel: UILabel = UILabel()
    var userLabel: UILabel = UILabel()
    
    var creationDate: UITextField = UITextField()
    var greet: UITextField = UITextField()
    var id: UITextField = UITextField()
    var user: UITextField = UITextField()
    
    var greeting: Greeting? = nil
    var userParam: String? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        print("init")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        print("userParam: \(userParam)")
        
        self.fetchGreeting(user: userParam)
        print("viewWillAppear loaded")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        
        self.title = "Greet"
        
        let nav = self.navigationController
        print("--- nav controller: \(nav)")

        let frame = nav?.navigationBar.frame
        print("--- frame: \(frame)")
        
        self.view.backgroundColor = UIColor.white

        
        let x = 0
        var y:Int = Int((frame?.height)!) + 10
        print("-- y: \(y)")
        let width = 320
        let height = 50
        
        y = y+10
        userLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        userLabel.text = "User"
        userLabel.textColor = UIColor.darkGray
        y = y+50
        user.frame = CGRect(x: x, y: y, width: width, height: height)
        user.text = "-"
        
        y = y+50
        greetLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        greetLabel.text = "Greet"
        greetLabel.textColor = UIColor.darkGray
        y = y+50
        greet.frame = CGRect(x: x, y: y, width: width, height: height)
        greet.text = "-"
        
        y = y+50
        idLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        idLabel.text = "ID"
        idLabel.textColor = UIColor.darkGray
        y = y+50
        id.frame = CGRect(x: x, y: y, width: width, height: height)
        id.text = "-"
        
        y = y+50
        creationDateLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        creationDateLabel.text = "Date"
        creationDateLabel.textColor = UIColor.darkGray
        y = y+50
        creationDate.frame = CGRect(x: x, y: y, width: width, height: height)
        creationDate.text = "dd-MM-yyyy"
        
        
        self.view.addSubview(creationDateLabel)
        self.view.addSubview(creationDate)
        self.view.addSubview(greetLabel)
        self.view.addSubview(greet)
        self.view.addSubview(idLabel)
        self.view.addSubview(id)
        self.view.addSubview(userLabel)
        self.view.addSubview(user)
        
        print("user: \(self.user)")
        
    }
    
    func fetchGreeting(user: String?) {
        
        let greetingService = GreetingService.sharedInstance
        
        
        greetingService.get(name: user!, onCompletion: {(greetingResponse, error) in
            
            if error == nil {
                
                print("response::: \(greetingResponse)")
                self.greeting = greetingResponse
                self.populate()
                print("TOKITO!!!")
                
            } else {
                
                print("error: \(error)")
                
                var errorDescription: String?
                
                if let se: HttpRequestError = error as? HttpRequestError {
                    errorDescription = se.errorInfo()
                } else {
                    errorDescription = error?.localizedDescription
                }
                
                let alert = UIAlertController(title: "Request Error", message: errorDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

        })
        
    }
    
    func populate() {
        
        print("populate")
        
        if self.greeting != nil {

            DispatchQueue.main.async() {
                print("populate \(self.greeting)")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                self.creationDate.text = dateFormatter.string(from: (self.greeting?.creationDate)!)
                self.greet.text = self.greeting?.greet
                self.id.text = self.greeting?.id.uuidString
                self.user.text = self.greeting?.user
            }
            
        } else {
            print("greeting still null")
        }
        
        
    }
    
}
