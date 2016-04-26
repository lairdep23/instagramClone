//
//  UserListsVC.swift
//  InstagramClone
//
//  Created by Evan on 4/25/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserListsVC: UITableViewController {
    
    var usernames = [""]
    var userIds = [""]
    var isfollowing = ["":false]
    
    var refresher: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        refresh()
        
        
        
        let query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            
            
            if let users = objects {
                
                self.usernames.removeAll(keepCapacity: true)
                self.userIds.removeAll(keepCapacity: true)
                self.isfollowing.removeAll(keepCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId != PFUser.currentUser()?.objectId {
                            self.usernames.append(user.username!)
                            self.userIds.append(user.objectId!)
                            
                            let query = PFQuery(className: "followers")
                            
                            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) in
                                
                                if let objects = objects {
                                    
                                    if objects.count > 0 {
                                    
                                        self.isfollowing[user.objectId!] = true
                                    } else {
                                        self.isfollowing[user.objectId!] = false
                                    }
                                }
                                
                                if self.isfollowing.count == self.usernames.count {
                                
                                    self.tableView.reloadData()
                                    
                                }
                            })
                        }
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = usernames[indexPath.row]
        
        let followedObjectId = userIds[indexPath.row]
        
        if isfollowing[followedObjectId] == true {
        
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }

        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let followedObjectId = userIds[indexPath.row]
        
        if isfollowing[followedObjectId] == false {
            
            isfollowing[followedObjectId] = true
        
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
            let following = PFObject(className: "followers")
            following["following"] = userIds[indexPath.row]
            following["follower"] = PFUser.currentUser()?.objectId
            
            following.saveInBackground()
        
        } else {
            isfollowing[followedObjectId] = false
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            let query = PFQuery(className: "followers")
            
            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
            query.whereKey("following", equalTo: userIds[indexPath.row])
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) in
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        object.deleteInBackground()
                    }
                }
                
            })

        }
    }
    
    func refresh() {
        
        let query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            
            
            if let users = objects {
                
                self.usernames.removeAll(keepCapacity: true)
                self.userIds.removeAll(keepCapacity: true)
                self.isfollowing.removeAll(keepCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId != PFUser.currentUser()?.objectId {
                            self.usernames.append(user.username!)
                            self.userIds.append(user.objectId!)
                            
                            let query = PFQuery(className: "followers")
                            
                            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) in
                                
                                if let objects = objects {
                                    
                                    if objects.count > 0 {
                                        
                                        self.isfollowing[user.objectId!] = true
                                    } else {
                                        self.isfollowing[user.objectId!] = false
                                    }
                                }
                                
                                if self.isfollowing.count == self.usernames.count {
                                    
                                    self.tableView.reloadData()
                                    self.refresher.endRefreshing()
                                    self.tableView.sendSubviewToBack(self.refresher)
                                }
                            })
                        }
                    }
                }
            }
        })
    }

}
