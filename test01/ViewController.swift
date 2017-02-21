//
//  ViewController.swift
//  test01
//
//  Created by Luis Topiltzin Dominguez Butron on 12/17/16.
//  Copyright © 2016 Luis Topiltzin Dominguez Butron. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    var greetings: [Greeting]? = nil
    let username = "topi"
    let password = "123456"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("--- starting")
        
        self.title = "Greetings"
        
        let securityService = SecurityService.sharedInstance
        
        securityService.login(username: username, password: password) { (loginResponse, error) in
            if error == nil {
                print("response::: \(loginResponse)")
                print("response cookies: \(HTTPCookieStorage.shared.cookies)")
                
                self.fetchGreetings()
            } else {
                
                print("error: \(error)")
                
                var errorDescription: String?
                
                if let se: HttpRequestError = error as? HttpRequestError {
                    errorDescription = se.errorInfo()
                } else {
                    errorDescription = error?.localizedDescription
                }
                
                let alert = UIAlertController(title: "Login Error", message: errorDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        let viewFrame: CGRect = UIScreen.main.bounds
        tableView.frame = CGRect(x: 0, y: 50, width: viewFrame.width, height: viewFrame.height)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        print("DONE")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.greetings == nil {
            return 0
        }
        
        return self.greetings!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        if self.greetings != nil {
            
            let greet = self.greetings?[indexPath.row]
            cell.textLabel?.text = greet?.user
            
//            if let greet = self.greetings?[indexPath.row] != nil {
//                let user = greet.user
//                cell.textLabel?.text = user
//            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.greetings != nil {
            
            let greet = self.greetings?[indexPath.row]
            print("You've selected [\(greet?.user)]: \(greet?.greet)")
            
            let detailViewController = DetailViewController(nibName: nil, bundle: nil)
            detailViewController.userParam = (greet?.user)!
            
            //self.present(detailViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(detailViewController, animated: true)
                        
        }
    }

    func fetchGreetings() {
        
        let greetingService = GreetingService.sharedInstance
        
        greetingService.list { (greetingsResponse, error) in

            if error == nil {
                print("response::: \(greetingsResponse)")
                self.greetings = greetingsResponse
                self.refreshUI()
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
        }
        
    }
    
    func refreshUI() {
        
        DispatchQueue.main.async() {
            self.tableView.reloadData()
        }
    
    }
        
}

