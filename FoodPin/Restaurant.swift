//
//  Restaurant.swift
//  FoodPin
//
//  Created by Simon Ng on 19/8/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import Foundation
import CoreData

class Restaurant:NSManagedObject {
    @NSManaged var name:String!
    @NSManaged var type:String!
    @NSManaged var location:String!
    @NSManaged var image:NSData!
    @NSManaged var isVisited:NSNumber!
}