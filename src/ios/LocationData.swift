/*******************************************************************************************************************
|   File: LocationData.swift
|   Proyect: swiftLocations cordova plugin
|
|   Description: - LocationData class. Object representation of the location records stored in NSUserDefault,
|   conforms to the NSCoding protocol.
*******************************************************************************************************************/

import Foundation
import CoreData

@objc(LocationData) class LocationData : NSObject, NSCoding {
    
    // =====================================     INSTANCE VARIABLES / PROPERTIES      ============================//
    var latitude : NSNumber!
    var longitude: NSNumber!
    var timestamp: NSDate!
    
    // =====================================     NSCoding PROTOCOL METHODS            ============================//
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        
        self.latitude  = aDecoder.decodeObjectForKey("latitude") as! NSNumber?
        self.longitude = aDecoder.decodeObjectForKey("longitude") as! NSNumber?
        self.timestamp = aDecoder.decodeObjectForKey("timestamp") as! NSDate?
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.latitude, forKey: "latitude")
        aCoder.encodeObject(self.longitude, forKey:"longitude")
        aCoder.encodeObject(self.timestamp, forKey:"timestamp")
    }
}
