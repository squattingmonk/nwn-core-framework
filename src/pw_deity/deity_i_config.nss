/*
Filename:           h2_deity_c
System:             Deity (user configuration include script)
Author:             Edward Beck (0100010)
Date Created:       Sept. 3, 2006
Summary:
HCR2 Diety variable user-configuration variable settings.
This script is consumed by h2_deity_i as an include directive.

This contains user definable toggles and settings for the diety system.

This script is freely editable by the mod builder. It should not contain any h2 functions or constants
that should not be overrideable by the user, please put those in h2_diety_i.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

//You may swap the below #include "h2_torchlantrn_t"  text directives for an equivalant language specific
//one. (All variable names must match however for it to compile properly.)
#include "h2_deity_t"

//All below functions and constants may be overriden by the user, but do not alter the function signature
//or the name of the constant.

//Begin user configurable constant declarations.

//Base percentage chance that a player will be ressurected by their deity.
//This value is added to the percentage per level defined in the next setting.
//
//Allowed values (0 - 100)
//Default value = 5.0
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
