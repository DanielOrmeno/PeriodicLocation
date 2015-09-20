/*******************************************************************************************************************
|   File: locationManager.swift
|   Proyect: swiftLocations cordova plugin
|
|   Description: - Manages location services based on Apple's standard location services from the CoreLocation 
|   framework, this class conforms to the CLLocationManagerDelegate to handle any location updates sent from the OS 
|   and filters them to store periodic location updates in memory, throught a DataManager instance.
*******************************************************************************************************************/

import CoreLocation
import CoreData
import UIKit

class LocationManager : NSObject, CLLocationManagerDelegate {
    
    // =====================================     INSTANCE VARIABLES / PROPERTIES      =============================//
    
    //- Date Format
    let DATEFORMAT : String = "dd-MM-yyyy, HH:mm:ss"
    
    //- Time intervals for scan
    let SixtyMINUTES : NSTimeInterval = 15*60 // Updates are saved to memory if they are >=15 minutes old
    let KeepAliveTimeInterval : Double = 5*60 // App gets a new location every 5 minutes to keep timers alive
    
    //- NSTimer object for scheduling accuracy changes
    var timer = NSTimer()
    
    //- Controls button calls
    var updatesEnabled = false
    
    //- Location Manager - CoreLocation Framework
    let locationManager = CLLocationManager()
    
    //- DataManager Object - Manages data in memory based on the CoreData framework
    let dataManager = DataManager()
    
    //- UIBackgroundTask
    var bgTask = UIBackgroundTaskInvalid
    
    //- NSNotificationCenter to handle changes in App LifeCycle
    var defaultCentre: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    //- NSUserDefaults - LocationServicesControl_KEY to be set to TRUE when user has enabled location services.
    let UserDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let LocationServicesControl_KEY: String = "LocationServices"
    
    // =====================================     CLASS CONSTRUCTORS      =========================================//
    
    override init () {
        
        //- Super Class Constructor
        super.init()
        
        // Location Manager configuration --------------------------------------------------------------------------
        self.locationManager.delegate = self
        
        //- Authorization for utilization of location services for background process
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Authorized) {
            self.locationManager.requestAlwaysAuthorization()
        }
        // END: Location Manager configuration ---------------------------------------------------------------------
        
        //- NSNotificationCenter configuration for handling transitions in the App's Lifecycle
        let terminateSelector: Selector = "appWillTerminate:"
        let relaunchSelector: Selector = "appIsRelaunched:"
        
        self.defaultCentre.addObserver(self, selector: terminateSelector, name: UIApplicationWillTerminateNotification, object: nil)
        self.defaultCentre.addObserver(self, selector: relaunchSelector, name: UIApplicationDidFinishLaunchingNotification, object: nil)
        
        print("Location Manager Instantiated")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =====================================     CLASS METHODS      ===============================================//
    
    /********************************************************************************************************************
    METHOD NAME: startLocationServices
    INPUT PARAMETERS: None
    RETURNS: None
    
    OBSERVATIONS: Starts location services if not enabled already, checks user permissions
    ********************************************************************************************************************/
    func startLocationServices () {
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized){
            
            if (!self.updatesEnabled){
                //- Location Accuracy, properties & Distance filter
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.distanceFilter = kCLDistanceFilterNone
                
                //- Start receiving location updates
                self.locationManager.startUpdatingLocation()
                
                self.updatesEnabled = true;
                
                //- Save Location Services ENABLED to NSUserDefaults
                self.UserDefaults.setBool(true, forKey: self.LocationServicesControl_KEY)
                
            } else {
                print("Location Updates already enabled")
            }
            
        } else {
            
            print("Application is not authorized to use location services")
            //- TODO: Unauthorized, requests permissions again and makes recursive call
        }
    }
    
    /********************************************************************************************************************
    METHOD NAME: stopLocationServices
    INPUT PARAMETERS: None
    RETURNS: None
    
    OBSERVATIONS: Stops location services if not enabled already, checks user permissions
    ********************************************************************************************************************/
    
    func stopLocationServices() {
        
        if(self.updatesEnabled) {
            
            self.updatesEnabled = false;
            self.locationManager.stopUpdatingLocation()
            
            //- Stops Timer
            self.timer.invalidate()
            
            //- Save Location Services DISABLED to NSUserDefaults
            self.UserDefaults.setBool(false, forKey: self.LocationServicesControl_KEY)
            
        } else {
            print("Location updates have not been enabled")
        }
    }
    
    /********************************************************************************************************************
    METHOD NAME: changeLocationAccuracy
    INPUT PARAMETERS: None
    RETURNS: None
    
    OBSERVATIONS: Toggles location manager's accuracy to save battery when waiting for timer to expire
    ********************************************************************************************************************/
    func changeLocationAccuracy (){
        
        let CurrentAccuracy = self.locationManager.desiredAccuracy
        
        switch CurrentAccuracy {
            
        case kCLLocationAccuracyBest: //- Decreses Accuracy
            
            self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            self.locationManager.distanceFilter = 99999
            
        case kCLLocationAccuracyThreeKilometers: //- Increaces Accuracy
            
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            
        default:
            print("Accuracy not Changed")
        }
    }
    
    /********************************************************************************************************************
    METHOD NAME: isUpdateValid
    INPUT PARAMETERS: NSDate object
    RETURNS: Bool
    
    OBSERVATIONS: Returns true newDate input parameter is an NSDate with a time interval difference of 3600 (60 minutes).
    If zero returns true as no other records are in memory. Else returns false (invalid update)
    ********************************************************************************************************************/
    func isUpdateValid (newDate: NSDate) -> Bool{
        
        var interval = NSTimeInterval()
        
        if let newestRecord = self.dataManager.getLastRecord() {
            let Date = newestRecord.timestamp
            interval = newDate.timeIntervalSinceDate(Date)
        }
        
        if ((interval==0)||(interval>=self.SixtyMINUTES)){
            print("Location is VALID with interval:\(interval)")
            return true
        } else {
            return false
        }
    }
    
    // =====================================     NSNotificationCenter Methods (App LifeCycle)  ====================//
    /********************************************************************************************************************
    METHOD NAME: appWillTerminate
    INPUT PARAMETERS: NSNotification object
    RETURNS: None
    
    OBSERVATIONS: The AppDelegate triggers this method when the App is about to be terminated (Removed from memory due to
    a crash or due to the user killing the app from the multitasking feature). This call causes the plugin to stop
    standard location services if running, and enable significant changes to re-start the app as soon as possible.
    ********************************************************************************************************************/
    func appWillTerminate (notification: NSNotification){
        
        let ServicesEnabled = self.UserDefaults.boolForKey(self.LocationServicesControl_KEY)
        
        //- Stops Standard Location Services if they have been enabled by the user
        if ServicesEnabled {
            
            //- Stop Location Updates
            self.locationManager.stopUpdatingLocation()
            
            //- Stops Timer
            self.timer.invalidate()
            
            //- Enables Significant Location Changes services to restart the app ASAP
            self.locationManager.startMonitoringSignificantLocationChanges()
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    /********************************************************************************************************************
    METHOD NAME: appIsRelaunched
    INPUT PARAMETERS: NSNotification object
    RETURNS: None
    
    OBSERVATIONS: This method is called by the AppDelegate when the app starts. This method will stop the significant
    change location updates and restart the standard location services if they where previously running (Checks saved
    NSUserDefaults)
    ********************************************************************************************************************/
    func appIsRelaunched (notification: NSNotification) {
        
        //- Stops Significant Location Changes services when app is relaunched
        self.locationManager.stopMonitoringSignificantLocationChanges()
        
        let ServicesEnabled = self.UserDefaults.boolForKey(self.LocationServicesControl_KEY)
        
        //- Re-Starts Standard Location Services if they have been enabled by the user
        if (ServicesEnabled) {
            self.startLocationServices()
        }
    }
    
    // =====================================     CLLocationManager Delegate Methods    ===========================//
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]!) {
        
        self.bgTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            UIApplication.sharedApplication().endBackgroundTask(self.bgTask)
            self.bgTask = UIBackgroundTaskInvalid
        })
        
        //- parse last known location
        let newLocation = locations.last!
        
        // Filters bad location updates cached by the OS -----------------------------------------------------------
        let Interval: NSTimeInterval = newLocation.timestamp.timeIntervalSinceNow
        
        let accuracy = self.locationManager.desiredAccuracy
        
        if ((abs(Interval)<5)&&(accuracy != kCLLocationAccuracyThreeKilometers)) {
            
            //- Updates Persistent records through the DataManager object
            if isUpdateValid(newLocation.timestamp) {
                dataManager.updateLocationRecords(newLocation)
            }
            
            /* Timer initialized everytime an update is received. When timer expires, reverts accuracy to HIGH, thus
            enabling the delegate to receive new location updates */
            self.timer = NSTimer.scheduledTimerWithTimeInterval(self.KeepAliveTimeInterval, target: self, selector: Selector("changeLocationAccuracy"), userInfo: nil, repeats: false)
            
            //- Lowers accuracy to avoid battery drainage
            self.changeLocationAccuracy()
            
        } else {
            //println("Dismissed location record")
        }
        // END: Filters bad location updates cached by the OS ------------------------------------------------------
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location update error: \(error.localizedDescription)")
    }
}