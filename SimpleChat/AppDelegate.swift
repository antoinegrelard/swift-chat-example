//
//  AppDelegate.swift
//  SimpleChat
//
//  Created by Antoine Grélard on 12/02/2015.
//  Copyright (c) 2015 Antoine Grélard. All rights reserved.
//

import UIKit
import MultipeerConnectivity

let serviceType = "simple-chat2"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MCSessionDelegate, MCAdvertiserAssistantDelegate {
    let peerImage:UIImage = UIImage(named: "me.png")!
    let defaultImage:UIImage = UIImage(named: "profile.png")!
    var window: UIWindow?
    var session: MCSession?
    var advertiserAssistant : MCAdvertiserAssistant?
    
    var objects = NSMutableArray()
    var user = NSMutableDictionary()
    
    class func getObjects() -> NSMutableArray {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        return delegate.objects
    }

    class func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    class func sharedSession() -> MCSession? {
        return self.appDelegate().session
    }

    // MARK: - UIApplicationDelegate
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let peerID = MCPeerID(displayName: "Antoine")
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .Required)
        session?.delegate = self
        
        dispatch_async(dispatch_get_main_queue()) {
            self.advertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: self.session!)
            self.advertiserAssistant!.start()
            println("Start advertising")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - MCSessionDelegate
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        println("didReceiveData")
        let image = UIImage(data: data)
        user.setObject(image!, forKey: peerID.displayName)
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        println("didStartReceivingResourceWithName")
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        println("didFinishReceivingResourceWithName")
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        println("didReceiveStream")
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        println("peerID: \(peerID) didChangeState: \(state)")
        if state.rawValue == 2 {
            var imageData = UIImagePNGRepresentation(peerImage)
            var error: NSError?
            session.sendData(imageData, toPeers: [peerID], withMode: .Reliable, error: &error)
            user[peerID.displayName] = defaultImage
            objects.addObject(user)
        }
    }

}

