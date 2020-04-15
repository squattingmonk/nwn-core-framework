/*
Filename:           h2_pccorse_c
System:             pc corpse (user configuration script)
Author:             Edward Beck (0100010)
Date Created:       Mar. 26, 2006
Summary:

This script is consumed by h2_pccorpse_i as an include directive.

Contains user definable toggles and settings for the pccorpse subsystem.
Should contains include directives for additional files needed by the user,
and any _t scripts (text string definition scripts).

This script is freely editable by the mod builder. It should not contain any h2 functions that should
not be overrideable by the user, put those in h2_core_i or h2_bleedsystem_i.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date: Aug. 30, 2006
Revision Author: Edward Beck
Revision Summary: v1.3
Added include reference to h2_pccorpse_t

Revision Date: Dec 31st, 2006
Revision Author: Edward Beck (0100010)
REvision Summary: v1.5
Added H2_GOLD_COST_FOR_RAISE_DEAD and H2_GOLD_COST_FOR_RESSURECTION as
user configurable variables.

*/

//You may swap the below #include "hc2_pccorpse_t" text directives for an equivalant language specific
//one. (All variable names must match however for it to compile properly.)
#include "h2_pccorpse_t"


//All below functions and constants may be overriden by the user, but do not alter the function signature
//or the name of the constant.
//Begin function and constant declarations.

//User defined event number sent to an NPC when a corpse token is activated on them.
//Pick any integer value that is not being used for another event number.
const int H2_PCCORPSE_ITEM_ACTIVATED_EVENT_NUMBER = 2147483500;

//Can be TRUE or FALSE.
//Set this to FALSE if you do not want to allow PC's to ressurect a corpse token at all.
//Default value is TRUE.
const int H2_ALLOW_CORPSE_RESS_BY_PLAYERS = TRUE;

//Can be TRUE or FALSE.
//Set this to TRUE if you want the raised PC to endure the PHB XP loss upon being raised or ressurected.
const int H2_APPLY_XP_LOSS_FOR_RESS = TRUE;

//Can be TRUE or FALSE.
//Set this to TRUE if you want the caster to lose gold according to the amount the PHB says is required
//for the cast spell.
const int H2_REQUIRE_GOLD_FOR_RESS = TRUE;

//The cost in gold for the raise dead spell. (must be a positive value)
//This only applies if H2_REQUIRE_GOLD_COST_FOR_RESS = TRUE;
const int H2_GOLD_COST_FOR_RAISE_DEAD = 5000;

//The cost in gold for the ressurection spell. (must be a positive value)
//This only applies if H2_REQUIRE_GOLD_COST_FOR_RESS = TRUE;
const int H2_GOLD_COST_FOR_RESSURECTION = 10000;


//End function and constant declarations.
