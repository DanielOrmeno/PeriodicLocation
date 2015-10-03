/*******************************************************************************************************************
|   File: swiftLocation.js
|   Proyect: swiftLocation cordova plugin
|
|   Description: - Javascript handler of the cordova location plugin
*******************************************************************************************************************/

var exec = require('cordova/exec');

// =====================================     CONSTRUCTOR          ===============================================//

function swiftLocation() {}
// =====================================     PLUGIN METHODS      ===============================================//
/********************************************************************************************************************
METHOD NAME: areLocationUpdatesEnabled
INPUT PARAMETERS: 
RETURNS: confirmation/error message.
    
OBSERVATIONS:
********************************************************************************************************************/
swiftLocation.prototype.areLocationUpdatesEnabled = function(callback) {
    exec(function(result){
        // result handler
        console.log(result)
        if (typeof callback === 'function')
            callback(result);
        return result;
    },
         function(error){
        // error handler
        console.log("Error" + error);
    },
         "swiftLocation",
         "areLocationUpdatesEnabled",
        [keepAliveInterval]);
}
/********************************************************************************************************************
METHOD NAME: getKeepAliveTimeInterval
INPUT PARAMETERS: 
RETURNS: confirmation/error message.
    
OBSERVATIONS:
********************************************************************************************************************/
swiftLocation.prototype.getKeepAliveTimeInterval = function(callback) {
    exec(function(result){
        // result handler
        console.log(result)
        if (typeof callback === 'function')
            callback(result);
        return result;
    },
         function(error){
        // error handler
        console.log("Error" + error);
    },
         "swiftLocation",
         "getKeepAliveTimeInterval",
        [keepAliveInterval]);
}
/********************************************************************************************************************
METHOD NAME: getUpdatesInterval
INPUT PARAMETERS:
RETURNS: confirmation/error message.
    
OBSERVATIONS:
********************************************************************************************************************/
swiftLocation.prototype.getUpdatesInterval = function(callback) {
    exec(function(result){
        // result handler
        console.log(result)
        if (typeof callback === 'function')
            callback(result);
        return result;
    },
         function(error){
        // error handler
        console.log("Error" + error);
    },
         "swiftLocation",
         "getUpdatesInterval",
        [UpdatesInterval]);
}
/********************************************************************************************************************
METHOD NAME: getNumberOfRecords
INPUT PARAMETERS:
RETURNS: confirmation/error message.
    
OBSERVATIONS:
********************************************************************************************************************/
swiftLocation.prototype.getNumberOfRecords = function(callback) {
    exec(function(result){
        // result handler
        console.log(result)
        if (typeof callback === 'function')
            callback(result);
        return result;
    },
         function(error){
        // error handler
        console.log("Error" + error);
    },
         "swiftLocation",
         "getNumberOfRecords",
        [numberOfRecords]);
}
/********************************************************************************************************************
METHOD NAME: setKeepAliveTimeInterval
INPUT PARAMETERS: 
RETURNS: confirmation/error message.
    
OBSERVATIONS:
********************************************************************************************************************/
swiftLocation.prototype.setKeepAliveTimeInterval = function(keepAliveInterval) {
    exec(function(result){
        // result handler
        console.log(result)
    },
         function(error){
        // error handler
        console.log("Error" + error);
    },
         "swiftLocation",
         "setKeepAliveTimeInterval",
        [keepAliveInterval]);
}
/********************************************************************************************************************
METHOD NAME: setUpdatesInterval
INPUT PARAMETERS:
RETURNS: confirmation/error message.
    
OBSERVATIONS:
********************************************************************************************************************/
swiftLocation.prototype.setUpdatesInterval = function(UpdatesInterval) {
    exec(function(result){
        // result handler
        console.log(result)
    },
         function(error){
        // error handler
        console.log("Error" + error);
    },
         "swiftLocation",
         "setUpdatesInterval",
        [UpdatesInterval]);
}
/********************************************************************************************************************
METHOD NAME: setNumberOfRecords
INPUT PARAMETERS:
RETURNS: confirmation/error message.
    
OBSERVATIONS:
********************************************************************************************************************/
swiftLocation.prototype.setNumberOfRecords = function(numberOfRecords) {
    exec(function(result){
        // result handler
        console.log(result)
    },
         function(error){
        // error handler
        console.log("Error" + error);
    },
         "swiftLocation",
         "setNumberOfRecords",
        [numberOfRecords]);
}
/********************************************************************************************************************
METHOD NAME: startLocationUpdates
INPUT PARAMETERS: None - empty args
RETURNS: None
    
OBSERVATIONS: Starts location updates if device is authorized
********************************************************************************************************************/
swiftLocation.prototype.startLocationServices = function() {
    exec(function(result){
        // result handler
        console.log(result)
    },
         function(error){
        // error handler
        console.log("Error" + error);
    },
         "swiftLocation",
         "startLocationServices",
        []);
}
/********************************************************************************************************************
METHOD NAME: stopLocationUpdates
INPUT PARAMETERS: command: None - empty args
RETURNS: None
    
OBSERVATIONS: stops location updates if already running
********************************************************************************************************************/
swiftLocation.prototype.stopLocationServices = function() {
    exec(function(result){
        // result handler
        console.log(result)
    },
         function(error){
        // error handler
        console.log("Error" + error);
    },
         "swiftLocation",
         "stopLocationServices",
        []);
}
/********************************************************************************************************************
METHOD NAME: getLocationRecords
INPUT PARAMETERS: command: None - empty args
RETURNS: None
    
OBSERVATIONS: retrieves location records from memory to be handled by javascript
********************************************************************************************************************/
swiftLocation.prototype.getLocationRecords = function(callback) {
    exec(function(data){
        // result handler
         if (typeof callback === 'function')
            callback(data);
    },
         function(error){
        // error handler
        console.log("Error" + error);
    },
         "swiftLocation",
         "getLocationRecords",
        []);
}

var SurveyLoc = new swiftLocation();
module.exports = SurveyLoc
