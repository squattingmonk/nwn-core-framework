// -----------------------------------------------------------------------------
//    File: rest_i_const.nss
//  System: Rest (constants)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Constants for PW Subsystem.
// -----------------------------------------------------------------------------
// Builder Use:
//  None!  Leave me alone.
// -----------------------------------------------------------------------------
// Acknowledgment:
// -----------------------------------------------------------------------------
//  Revision:
//      Date:
//    Author:
//   Summary:
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

// ----- Items -----

// If H2_REQUIRE_REST_TRIGGER_OR_CAMPFIRE (rest_i_config) is set to TRUE, the item
//  associated with H2_CAMPFIRE will be used to determine rest allowance/distance.
const string H2_CAMPFIRE = "h2_campfire";
const string H2_FIREWOOD = "h2_firewood";

// ----- Variables -----

// If H2_REQUIRES_REST_TRIGGER_OR_CAMPFIRE (rest_i_config) is set to TRUE, the
//  trigger associated with H2_REST_TRIGGER will be used to determine rest
//  allowance/distance.
const string H2_REST_TRIGGER = "H2_REST_TRIGGER";
const string H2_LAST_PC_REST_TIME = "H2_LAST_PC_RESTTIME";
const string H2_IGNORE_MINIMUM_REST_TIME = "H2_IGNORE_MINIMUM_REST_TIME";
const string H2_REST_FEEDBACK = "H2_REST_FEEDBACK";
const string H2_CAMPFIRE_BURN = "H2_CAMPFIRE_BURN";
const string H2_CAMPFIRE_START_TIME = "H2_CAMPFIRE_START_TIME";

// Custom Events
const string REST_EVENT_ON_TRIGGER_CLICK = "Rest_OnTriggerClick";
const string REST_EVENT_ON_TRIGGER_ENTER = "Rest_OnTriggerEnter";
const string REST_EVENT_ON_TRIGGER_EXIT = "Rest_OnTriggerExit";
const string REST_EVENT_ON_TRIGGER_HEARTBEAT = "Rest_OnTriggerHeartbeat";
const string REST_EVENT_ON_TRIGGER_USERDEFINED = "Rest_OnTriggerUserDefined";
