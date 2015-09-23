# PeriodicLocation Cordova Plugin

##Overview ##


## SETUP instructions: ##

**1.-** Create new cordova project or clone down existing project from a repo: 

```
    $ cordova create myLocationApp com.ex.ample periodicUpdates
```
**2.-** Add iOs platform in the project's directory: 

```
    $ cd SurveyApp
    $ cordova platforms add ios
```

**3.-** In finder, navigate to the iOs directory of the project (periodicUpdates/platforms/ios) and open the XCode project.

**4.-** Before installing the plugin, we need to add a bridging header file to allow our swift classes to coexist with the Cordova generated Objective-C code. The Bridging Header File needs to be added to the plugins directory. 

The easiest way to achieve this is to navigate to the plugins directory in the XCode's project navigator and add a swift file, this will cause XCode ask you if you want to include the needed Bridging Header file, accept and delete the newly created Swift file from this directory. Add the following line to the Bridging Header File:

```
    #import <Cordova/CDV.h>
```

**Note:** Alternatively, you can manually add the Bridging Header File as explained [in Apple's documentation](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html#//apple_ref/doc/uid/TP40014216-CH10-XID_79)

**5 -** Change the deployment targets to the latest iOS (Swift is only compatible with iOs 7 onwards). 

**Note:** *Change the deployment targets both the root project and in the CordovaLib.xcodeproj nested project. These can be found in Xcode's project navigator*


**6.-** Quit Xcode

**7.-** Install the surveyLocation plugin from the repo, navigate to your project's root directory and install the plugin via the CLI.
```
    $ cordova plugin add https://github.com/DanielOrmeno/PeriodicLocation.git
```

**8.-** Prepare and Build the project through the CLI
```
    $ cordova prepare ios    
    $ crodova build ios
```
**9.-** Open XCode and run the project.

## About the Plugin ##

### Plugin Methods 

* startLocationUpdates: Starts updating the user's location based on the Standard Location Service from the CoreLocation framework, logging location records to memory every hour. When Invoked the NSUserDefault setting "LocationUpdates" is set to True to relaunch the app if killed.

* stopLocationUpdates: Stops updating the user's location and kills the related timers. When Invoked the NSUserDefault setting "LocationUpdates" is set to false to prevent the system of relaunching the app if killed.

* getLocationRecords: Fetches the location records from memory and presents them to Javascript as an array of JSON objects

* getFormattedLocationRecords: Fetches the location records from memory and presents them to Javascript as an array of formatted strings, as folows:

```
    lat:-27.962901
    lon:153.380976
    timestamp:13-1-2015
```

### Plugin Features ###

* It makes use of the iOs location update background mode to get the user's current location even when in the background.
* When the App is killed by the user (through the multitasking feature) or by the OS, the app will invoke the selector method for the class's NSNotification Observer to start the Significant Location Change service form the CoreLocation framework, this service will relaunch the app on the background and restart the Standard Location Service to resume the hourly updates. To Debbug this functionality follow the instructions [in this post.](http://pawanpoudel.svbtle.com/how-to-debug-significant-location-change-code-in-ios)
* When the startLocationServices method is called, the application will log the users location every hour, and will mantain in memory only the records corresponding to the last 6 hours.

### Testing ###
To test the significant change location services waking up the app after its being killed: 

Add the following line to the end of the didFinishLaunchingWithOptions method of the AppDelegate.m file before installing the plugin.

```
[application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
```

And uncomment the section of the code between the two TODO tags in locationManager.swift / appIsRelaunched method.

```
   func appIsRelaunched (notification: NSNotification) {
        
        //- Stops Significant Location Changes services when app is relaunched
        self.locationManager.stopMonitoringSignificantLocationChanges()
        
        let ServicesEnabled = self.UserDefaults.boolForKey(self.LocationServicesControl_KEY)
        
        //- Re-Starts Standard Location Services if they have been enabled by the user
        if (ServicesEnabled) {
            
            //- TODO: Remove below after testing.
            var localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Application is running"
            localNotification.alertBody = "I'm Alive!"
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            //- TODO: Remove above after testing.
            self.startLocationServices()
        }
    }
```
This will cause a local notification to be triggered when the app is woken up by the Significant changes method after being killed by the user (Will Only work if the location services have been enabled)

## Troubleshooting. ##

### Cordova Plugin ###

**Error:** If app loads but is unable to find the plugin's class: 

 
```
2015-01-07 17:03:50.106 newtest[22748:8411909] ERROR: Plugin 'surveyLocation' not found, or is not a CDVPlugin. Check your plugin mapping in config.xml.
2015-01-07 17:03:50.106 newtest[22748:8411909] -[CDVCommandQueue executePending] [Line 158] FAILED pluginJSON = [
  "surveyLocation130086363",
  "surveyLocation",
  "startLocationServices", [  ]]

```

**Suggestion:** Check that the building dependencies are correct. In the Xcode project, navigate to each of the classes described below and check that the target is selected in the Utilities section of the IDE, (right hand side of the window), under the Target Membership section. The following files should be included in the building dependencies of the project:
	surveyLocation.swift
	LocationManager.swift
	DataManager.swift
	LocationData.swift

*Also,*

Make sure that the Cordova import statement is in the bridging header BEFORE installing plugin and building ios through the Cordova CLI commands.

**Error:**  If app does not reload UIWebView (Connect to device) 
**Suggestion:**  This might be due to an error in the Javascript code of the plugin, it does not show errors when it fails to compile the Javascript files, check console outputs for any errors.


### CoreLocation Framework ###

**Error:** App does not detect any location updates.

**Suggestions:**  If testing with the simulator, simulate location changes by going to  the IOS Simulator -> Debug -> Location -> City Bicycle Ride.
*Or*
Make sure the NSLocationAlwaysUsageDescription key pair has been included in your project's projectName-info.plist file.

# Android Coming soon ... #

```

