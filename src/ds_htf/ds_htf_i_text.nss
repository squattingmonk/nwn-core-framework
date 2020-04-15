/*
Filename:           dksn_hungerthrst_t
System:             Dark Sun hunger and thirst add-ons to the HCR HT system
Author:             tinygiant
Date Created:       20200125
Summary:
dksn_hungerthrst_t text script.
This is a text script for the Dark Sun hunger and thirst subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

//There are extra spaces on this simply to make the Bars aligned since letters widths are not constant
//in the client text feedback.

const string DKSN_TEXT_NO_WATER_TO_BE_FOUND = "Unfortunately, there doesn't seem to be any water here.";
const string DKSN_TEXT_PC_FAILED_TO_FIND_WATER = "You failed to find water!";
const string DKSN_TEXT_CANTEEN_NOT_FOUND_PREFIX = "You are not carrying a canteen, so the ";
const string DKSN_TEXT_CANTEEN_NOT_FOUND_SUFFIX = " units of water you found are reabsorbed into the ground at your feet.";
const string DKSN_TEXT_CANTEEN_FULL_PREFIX = "You have no remaining canteen space, so the extra ";
const string DKSN_TEXT_CANTEEN_FULL_SUFFIX = " units of water you found are reabsorbed into the ground at your feet.";
const string DKSN_TEXT_PC_FIND_WATER_PREFIX = "Success! You found ";
const string DKSN_TEXT_PC_FIND_WATER_SUFFIX = " units of water!";

const string DS_TEXT_BRACKET_L = "[";
const string DS_TEXT_BRACKET_R = "]";
const string DS_TEXT_DELIMITER = "|";