//
//  ViewController.swift
//  SimpleChat
//
//  Created by Antoine Grélard on 12/02/2015.
//  Copyright (c) 2015 Antoine Grélard. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, UITableViewDelegate {
    
    var objects = AppDelegate.getObjects()
    
    @IBOutlet weak var peerList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    @IBAction func invite(sender: UIButton) {
        if let session = AppDelegate.sharedSession() {
            let browserViewController = MCBrowserViewController(serviceType: serviceType, session: session)
            browserViewController.delegate = self
            
            presentViewController(browserViewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        println("browserViewControllerDidFinish")
        
        dismissViewControllerAnimated(true, completion: nil)
        dispatch_async(dispatch_get_main_queue()) {
            self.peerList.reloadData()
        }
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        println("browserViewControllerWasCancelled")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let object = objects[indexPath.row] as NSDictionary
        for (mKey,mValue) in object{
            cell.textLabel!.text = mKey as? String
            cell.imageView!.image = mValue as? UIImage
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {

        }
    }

}

