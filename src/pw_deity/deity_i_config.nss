// -----------------------------------------------------------------------------
//    File: deity_i_config.nss
//  System: Deity Resurrection (configuration)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Configuration File for PW Subsystem.
// -----------------------------------------------------------------------------
// Builder Use:
//  Set the variables below as directed in the comments for each variable.
// -----------------------------------------------------------------------------
// Acknowledgment:
// -----------------------------------------------------------------------------
//  Revision:
//      Date:
//    Author:
//   Summary:
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                                   Variables
// -----------------------------------------------------------------------------

// This is the base percentage change a PC will be resurrected by their deity.
//  Value range is 0.0-100.0
// Default value: 5.0
const float H2_BASE_DEITY_REZ_CHANCE = 5.0;

//Percentage chance per level that a player will be ressurected by their deity
//(H2_DIETY_REZ_CHANCE_PER_LEVEL ^ playerlevel) + H2_BASE_DEITY_REZ_CHANCE equal total
//percentage chance the player's diety will ressurect them.
//
//Allowed values (0 - 100)
//Default value = 0.0
const float H2_DEITY_REZ_CHANCE_PER_LEVEL = 0.0;

//This is the tag of a way point used as the generic location
//that a player ressurected by their deity will be jumped to.
//This waypoint will be used if a deity-specifc waypoint is not found.
const string H2_GENERAL_DEITY_REZ_WAYPOINT = "H2_WP_DIETY_REZ";
