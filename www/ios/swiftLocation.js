/*******************************************************************************************************************
|   File: locationManager.js
|   Proyect: swiftLocation cordova plugin
|
|   Description: - Javascript handler of the cordova location plugin
*******************************************************************************************************************/

var exec = require('cordova/exec');

// =====================================     CONSTRUCTOR          ===============================================//

function swiftLocation() {}
// =====================================     PLUGIN METHODS      ===============================================//

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

        //- New Array for storing JSON Objects
        var JSONlocations= [];
        
         for (i=0; i< data.length; i++) {
            var jsonObj = JSON.parse(data[i]);
            JSONlocations[i] = jsonObj;
            if(i === data.length-1)
                callback(JSONlocations);
         }
         
         for (i=0; i<JSONlocations.length; i++){
            console.log(JSONlocations[i]);
         }
    },
         function(error){
        // error handler
        console.log("Error" + error);
    },
         "swiftLocation",
         "getLocationRecords",
        []);
}

/********************************************************************************************************************
METHOD NAME: getFormattedLocationRecords
INPUT PARAMETERS: command: None - empty args
RETURNS: None
    
OBSERVATIONS: retrieves location records from memory for usability, records are returned as an array of strings
********************************************************************************************************************/
swiftLocation.prototype.getFormattedLocationRecords = function(callback) {
    exec(function(data){
        // result handler

        //- New Array for storing JSON Objects
        var locations= [];
         
         for (i=0; i<data.length; i++){
            console.log(data[i]);
            if(i === data.length-1)
                callback(data);
         }
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
