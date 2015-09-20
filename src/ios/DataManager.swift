 /*******************************************************************************************************************
 |   File: DataManager.swift
 |   Proyect: swiftLocations cordova plugin
 |
 |   Description: - DataManager class. Manages the location records in memory through the NSUserDefaults. It handles 
 |   the location updates received by the LocationManager and stores them in memory based on a set of rules.
 |
 |   Only 32 records are stored in memory at all times (4 records per hour for 8 hours). Location records are based 
 |   on the LocationData class, see plugin ios project setup instructions for more information.
 *******************************************************************************************************************/
 
 import CoreData
 import UIKit
 import CoreLocation
 
 class DataManager {
    
    // =====================================     INSTANCE VARIABLES / PROPERTIES      =============================//
    
    //- MaxNumber of records allowed
    let MaxNoOfRecords:Int  = 32
    
    //- Date Format
    let DATEFORMAT = "dd-MM-yyyy, HH:mm:ss"
    
    //- Class keys
    let LocationRecords_Key = "LOCATION_RECORDS"
    let LocationData_Key = "LOCATION_DATA"
    
    //- Array of LocationData encoded objects
    var locationRecords : NSArray?
    
    //- User Defaults
    let UserDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    // =====================================     CLASS CONSTRUCTORS      =========================================//
    
    init () { }
    
    // =====================================     CLASS METHODS      ===============================================//
    
    
    /********************************************************************************************************************
    METHOD NAME: savelocationRecords
    INPUT PARAMETERS: array of LocationData Objects
    RETURNS: None
    
    OBSERVATIONS: Saves an array of LocationData as a NSArray of NSData objects in the NSUserDefaults by deleting old
    instance and saving array from argument.
    ********************************************************************************************************************/
    func saveLocationRecords (records: [LocationData]) {
        //- Create NSArray of NSData
        var NSDataArray: [NSData] = []
        
        //- Populate NSDataArray
        for eachRecord in records {
            
            //- Convert LocationData to NSData
            let Data = NSKeyedArchiver.archivedDataWithRootObject(eachRecord)
            NSDataArray.append(Data)
        }
        
        //- NSArray to comply with NSUserDefaults
        self.locationRecords = NSArray(array: NSDataArray)
        
        //- Update old array from UserDefaults
        self.UserDefaults.removeObjectForKey(LocationRecords_Key)
        self.UserDefaults.setObject(self.locationRecords, forKey: LocationRecords_Key)
        self.UserDefaults.synchronize()
    }
    
    /********************************************************************************************************************
    METHOD NAME: getUpdatedRecords
    INPUT PARAMETERS: NONE
    RETURNS: Array of LOcationData records
    
    OBSERVATIONS: Gets NSArray of NSData objects from NSUserDefaults and returns them as an array of LocationData objects
    ********************************************************************************************************************/
    func getUpdatedRecords () -> [LocationData]? {
        
        // - Fetch all Records in memoryif
        if let RECORDS: [NSData] = self.UserDefaults.arrayForKey(LocationRecords_Key) as? [NSData] {
            
            //- Empty array of LocationData objects
            var locationRecords = [LocationData]()
            
            for eachRecord in RECORDS {
                
                //- Convert from NSData back to LocationData object
                let newRecord = NSKeyedUnarchiver.unarchiveObjectWithData(eachRecord) as! LocationData
                
                //- Append Record
                locationRecords.append(newRecord)
            }
            
            //- Sort Location Records
            locationRecords.sortInPlace({ $0.timestamp.compare($1.timestamp) == NSComparisonResult.OrderedAscending})
            
            //- Return records if any, if not return nil
            return locationRecords
        } else {
            return nil
        }
    }
    
    /********************************************************************************************************************
    METHOD NAME: deleteOldestLocationRecord
    INPUT PARAMETERS: None
    RETURNS: None
    
    OBSERVATIONS: Gets [LocationData] from NSUserDefaults through the getUpdatedRecords method, deletes oldest record and
    saves array to memory through the savelocationRecords method
    ********************************************************************************************************************/
    func deleteOldestLocationRecord() {
        
        //- Fetch records from memory and store on mutable array
        var sortedRecords = [LocationData]()
        
        if let fetchedRecords = self.getUpdatedRecords() {
            
            //- Array needs to be mutable
            sortedRecords = fetchedRecords
            
            //- Delete Oldest Record
            sortedRecords.removeAtIndex(0)
            
            self.saveLocationRecords(sortedRecords)
        }
    }
    
    /********************************************************************************************************************
    METHOD NAME: getLastRecord
    INPUT PARAMETERS: None
    RETURNS: LocationData object
    
    OBSERVATIONS: Gets [LocationData] from NSUserDefaults through the getUpdatedRecords method, and returns the newest
    record if any
    ********************************************************************************************************************/
    func getLastRecord() -> LocationData? {
        
        //- Fetch records from memory and return newest
        if let fetchedRecords = self.getUpdatedRecords() {
            
            let newestRecord = fetchedRecords.last
            
            return newestRecord
        } else {
            return nil
        }
    }
    
    /********************************************************************************************************************
    METHOD NAME: addNewLocationRecord
    INPUT PARAMETERS: CLLocation Object
    RETURNS: None
    
    OBSERVATIONS: Converts CLLocation object to LocationData object, adds new record to [LocationData] from the
    getUpdatedRecords method and saves modified array to memory.
    ********************************************************************************************************************/
    func addNewLocationRecord (newRecord: CLLocation) {
        
        //- Get CLLocation properties
        let lat:NSNumber = newRecord.coordinate.latitude
        let lon: NSNumber = newRecord.coordinate.longitude
        let time: NSDate = newRecord.timestamp
        
        let newLocationDataRecord = LocationData()
        newLocationDataRecord.latitude  = lat
        newLocationDataRecord.longitude = lon
        newLocationDataRecord.timestamp = time
        
        //- Fetch records from memory and store on mutable array
        var sortedRecords = [LocationData]()
        
        if let fetchedRecords = self.getUpdatedRecords() {
            
            for records in fetchedRecords {
                sortedRecords.append(records)
            }
        }
        
        //- Append new record
        sortedRecords.append(newLocationDataRecord)
        
        //- Sort Records
        sortedRecords.sortInPlace({ $0.timestamp.compare($1.timestamp) == NSComparisonResult.OrderedAscending })
        
        //- Save new record
        self.saveLocationRecords(sortedRecords)
        
    }
    
    /********************************************************************************************************************
    METHOD NAME: updateLocationRecords
    INPUT PARAMETERS: CLLocation Object
    RETURNS: None
    
    OBSERVATIONS: Manages number of records when new record is received, only 32 location records are store in memory
    (4 updates per hour, for 8 hours)
    ********************************************************************************************************************/
    func updateLocationRecords (newLocation: CLLocation) {
        
        var numberOfRecords: Int?
        
        //- Perform initial fetch Request
        if let fetchResults = getUpdatedRecords() {
            
            switch fetchResults.count {
                
            case 0...(self.MaxNoOfRecords-1):
                //- Adds new location record if less than 32 records exist
                addNewLocationRecord(newLocation)
                
            case self.MaxNoOfRecords...99:
                //- If six or more records exist, reduce the number of records until size of five has been reached
                repeat {
                    
                    deleteOldestLocationRecord()
                    
                    //- new fetch for updated count result
                    numberOfRecords = getUpdatedRecords()?.count
                    
                } while (numberOfRecords>self.MaxNoOfRecords-1)
                
                //- Adds last knwon location to record
                addNewLocationRecord(newLocation)
                
            default:
                print("Error")
            }
            
        } else { //- NO RECORDS EXIST - CONDITIONAL UNWRAPING
            print("No records exist in memory, adding new record")
            addNewLocationRecord(newLocation)
        }
        
        //- FOR TESTING -----------
        print(":::::: updated records ::::::")
        if let fetchResults = getUpdatedRecords() {
            
            for each in fetchResults {
                print(self.fixDateFormat(each.timestamp))
            }
        }
        print("-----------")
        //- FOR TESTING above -----
    }
    
    /********************************************************************************************************************
    METHOD NAME: fixDateFormat
    INPUT PARAMETERS: NSDate object
    RETURNS: NSstring
    
    OBSERVATIONS: Fixes date format for debuggin and parsing, adds timezone and returns as NSString
    ********************************************************************************************************************/
    func fixDateFormat(date: NSDate) -> NSString {
        
        let dateFormatter = NSDateFormatter()
        //- Format parameters
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        //- Force date format to garantee consistency throught devices
        dateFormatter.dateFormat = DATEFORMAT
        dateFormatter.timeZone = NSTimeZone()
        
        return  dateFormatter.stringFromDate(date)
    }
    
 }
