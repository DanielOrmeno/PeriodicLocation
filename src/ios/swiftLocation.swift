/*******************************************************************************************************************
|   File: swiftLocation.swift
|
|   Description: - swiftLocation class (swift). Main class for iOs cordova location plugin.
|
|   Copyright (c) 2014 AppFactory. All rights reserved.
*******************************************************************************************************************/

import Foundation

@objc(swiftLocation) class swiftLocation : CDVPlugin {
    
    // =====================================     INSTANCE VARIABLES / PROPERTIES      =============================//
    
    let locationManager : LocationManager = LocationManager()
    
    // =====================================     PLUGIN METHODS      ===============================================//
    /********************************************************************************************************************
    METHOD NAME: areLocationUpdatesEnabled
    INPUT PARAMETERS: command: CDVInvokedURLCommand
    RETURNS:
    
    OBSERVATIONS:
    ********************************************************************************************************************/
    func areLocationUpdatesEnabled (command: CDVInvokedUrlCommand) {

        var pluginResult: CDVPluginResult;
        let locationUpdatesEnabled = "{enabled: true}"
        let locationUpdatesDisabled = "{enabled: false}"
        let errorMessage = "Unable to get status of location updates"
        
        let status = self.locationManager.areUpdatesEnabled()

        let message = status ? locationUpdatesEnabled : locationUpdatesDisabled

        if (message != "") {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
        }
        else{
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorMessage)
        }
        
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
    /********************************************************************************************************************
    METHOD NAME: getKeepAliveTimeInterval
    INPUT PARAMETERS: command: CDVInvokedURLCommand
    RETURNS:
    
    OBSERVATIONS:
    ********************************************************************************************************************/
    func getKeepAliveTimeInterval (command: CDVInvokedUrlCommand) {

        var pluginResult: CDVPluginResult;
        let errorMessage = "Could not retrieve Keep Alive interval"
        let keepAliveInterval = self.locationManager.getKeepAlive()

        if (keepAliveInterval >= 0) {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "{value: \(keepAliveInterval)}")
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorMessage)
        }
        
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
    /********************************************************************************************************************
    METHOD NAME: getUpdateIntervals
    INPUT PARAMETERS: command: CDVInvokedURLCommand
    RETURNS:
    
    OBSERVATIONS:
    ********************************************************************************************************************/
    func getUpdateIntervals (command: CDVInvokedUrlCommand) {

        var pluginResult: CDVPluginResult;
        let errorMessage = "Could not retrieve Updates interval"
        let updatesInterval = self.locationManager.getIntervals()

        if (updatesInterval >= 0) {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "{value: \(updatesInterval)}")
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorMessage)
        }
        
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
    /********************************************************************************************************************
    METHOD NAME: getMaxNumberOfRecords
    INPUT PARAMETERS: command: CDVInvokedURLCommand
    RETURNS:
    
    OBSERVATIONS:
    ********************************************************************************************************************/
    func getMaxNumberOfRecords (command: CDVInvokedUrlCommand) {

        var pluginResult: CDVPluginResult;
        let errorMessage = "Could not retrieve max number of records"
        let numberOfRecords = self.locationManager.dataManager.getNumberOfRecords()

        if (numberOfRecords >= 0) {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "{value: \(numberOfRecords)}")
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorMessage)
        }
        
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
    /********************************************************************************************************************
    METHOD NAME: setKeepAliveTimeInterval
    INPUT PARAMETERS: command: CDVInvokedURLCommand
    RETURNS:
    
    OBSERVATIONS:
    ********************************************************************************************************************/
    func setKeepAliveTimeInterval (command: CDVInvokedUrlCommand) {

        var pluginResult: CDVPluginResult;
        let args: Double? = (command.arguments.first as! NSString).doubleValue
        let successMessage = "Keep Alive Interval updated to \(args) seconds"
        let errorMessage = "Could not update Keep Alive interval to \(args) seconds"
        
        self.locationManager.setKeepAlive(args!)

        if (self.locationManager.getKeepAlive() == args){
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: successMessage)
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorMessage)
        }
        
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
    /********************************************************************************************************************
    METHOD NAME: setUpdateIntervals
    INPUT PARAMETERS: command: CDVInvokedURLCommand
    RETURNS:
    
    OBSERVATIONS:
    ********************************************************************************************************************/
    func setUpdatesIntervals (command: CDVInvokedUrlCommand) {

        var pluginResult: CDVPluginResult;
        let args:NSTimeInterval? = (command.arguments.first as! NSString).doubleValue
        let successMessage = "Updates Interval updated to \(args) seconds"
        let errorMessage = "Could not update interval to \(args) seconds"
        
        self.locationManager.setIntervals(args!)

        if (self.locationManager.getIntervals() == args){
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: successMessage)
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorMessage)
        }
        
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
    /********************************************************************************************************************
    METHOD NAME: setNumberOfRecords
    INPUT PARAMETERS: command: CDVInvokedURLCommand
    RETURNS:
    
    OBSERVATIONS:
    ********************************************************************************************************************/
    func setNumberOfRecords (command: CDVInvokedUrlCommand) {

        var pluginResult: CDVPluginResult;
        let args: Int? = Int(command.arguments.first as! String)
        let message = "Numer of records updated to \(args)"
        let errorMessage = "unable to update number of records to \(args)"
        
        self.locationManager.dataManager.setNumberOfRecords(args!)

        if (self.locationManager.dataManager.getNumberOfRecords() == args){
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorMessage)
        }
        
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
    /********************************************************************************************************************
    METHOD NAME: startLocationUpdates
    INPUT PARAMETERS: command: CDVInvokedURLCommand
    RETURNS: None
    
    OBSERVATIONS: This method starts the location update services through the SurveyLocationManager object of the class
    (locationManager). Location services will only start if they are NOT already working and if the user has provided
    permisions for the use of location services (CLAuthorizationStatus.Authorized). Any updates in the user's location
    are handled by the locationManager property. If succesful this method parses a "Location Updates Initiated" message
    to the javascrip side of the cordova plugin.
    ********************************************************************************************************************/
    func startLocationServices (command: CDVInvokedUrlCommand) {
        
        self.locationManager.startLocationServices()
        
        let message = "Location Updates initiated"
        
        let pluginResult: CDVPluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
        
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
    /********************************************************************************************************************
    METHOD NAME: startLocationUpdates
    INPUT PARAMETERS: command: CDVInvokedURLCommand
    RETURNS: None
    
    OBSERVATIONS: This method stops the location update services through the SurveyLocationManager object of the class
    (locationManager). Location services will only stop if they are already working. If succesful this method parses a
    "Location Updates Disabled" message to the javascrip side of the cordova plugin.
    ********************************************************************************************************************/
    func stopLocationServices (command: CDVInvokedUrlCommand){
        
        self.locationManager.stopLocationServices()
        
        let message = "Location Updates Disabled"
        
        let pluginResult: CDVPluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
        commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
    }
    /********************************************************************************************************************
    METHOD NAME: getLocationRecords
    INPUT PARAMETERS: command: CDVInvokedURLCommand
    RETURNS: None
    
    OBSERVATIONS: If succesful this method parses an array of strings to the javascrip side of the cordova plugin, these
    strings are in the format below to be parsed as json objects in javascript.
    
    [{"lat":" latValue ","lon":" lonValue ","timestamp":" timeValue as dd-MM-yyyy, HH:mm:ss"},{...},{...},{...}]
    ********************************************************************************************************************/
    func getLocationRecords (command: CDVInvokedUrlCommand){
        
        var locationRecords = [String]()
        
        //- Optional CDVPluginResult.
        var pluginResult: CDVPluginResult?
        
        //- Fetches location records if any and appends to array.
        if let locations = self.locationManager.dataManager.getUpdatedRecords() {
            
            for loc in locations {
                let timestamp = fixDateFormat(loc.timestamp)
                let jsonString = "{\"timestamp\":\"\(timestamp)\",\"lat\":\"\(loc.latitude)\",\"lon\":\"\(loc.longitude)\"}"
                locationRecords.append(jsonString)
            }
        }
        
        //- If array contains records -> CDVCommandStatus_OK else CDVCommandStatus_Error
        if (locationRecords.count>0){
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArray: locationRecords)
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "No location records found")
        }
        
        //- Returns CDVCommandStatus value and location records if any to javascript handler
        commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
    }
    /********************************************************************************************************************
    METHOD NAME: fixDateFormat
    INPUT PARAMETERS: NSDate object
    RETURNS: NSstring
    
    OBSERVATIONS: Fixes date format for debuggin and parsing, adds timezone and returns as NSString
    ********************************************************************************************************************/
    func fixDateFormat(date: NSDate) -> NSString {
        
        //- Date Format
        let DATEFORMAT = "dd-MM-yyyy, HH:mm:ss"
        
        let dateFormatter = NSDateFormatter()
        //- Format parameters
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle //Set date style
        
        //- Force date format to garantee consistency throught devices
        dateFormatter.dateFormat = DATEFORMAT
        dateFormatter.timeZone = NSTimeZone()
        
        return  dateFormatter.stringFromDate(date)
    }
}