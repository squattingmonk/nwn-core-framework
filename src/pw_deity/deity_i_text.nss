/*
Filename:           h2_diety_t
System:             Diety
Author:             Edward Beck (0100010)
Date Created:       Sept. 3, 2006
Summary:
HCR2 h2_torch item script.
This is a text script for the diety subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

const string H2_TEXT_DEITY_REZZED = "Your God has heard your prayers and ressurected you!";
const string H2_TEXT_DEITY_NO_REZ = "Your God has refused to hear your prayers.";
const string H2_TEXT_DM_DEITY_REZZED = /*GetName(oPC) + "_" + GetPCPlayerName(oPC) +*/
                                    " was ressurected by their deity: "; /* + GetDiety(oPC)
