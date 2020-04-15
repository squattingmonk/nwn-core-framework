/*
Filename:           h2_pccorpse_t
System:             pc corpse (text include script)
Author:             Edward Beck (0100010)
Date Created:       Aug. 30, 2006
Summary:
HCR2 String constants
This file holds the various strings associated with the HCR2 pccorpse subsystem

To make an alternate language version of this script, save this script with a different name,
and translate all of the below text. Then in h2_pccorpse_c, replace [#include "h2_pccorpse_t"]
with [#include "your new language text script name"].

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

const string H2_TEXT_CLERIC_RES_GOLD_COST = "I can cast raise dead for 5000 coins, or resurrection for 10000.";
const string H2_TEXT_CLERIC_NOT_ENOUGH_GOLD = "I'm sorry you do not have enough gold for me to aid you.";
const string H2_TEXT_OFFLINE_RESS_CASTER_FEEDBACK = "The player is offline but will be ressurected when they next log in.";
const string H2_TEXT_YOU_HAVE_BEEN_RESSURECTED = "You have been ressurected.";
const string H2_TEXT_OFFLINE_RESS_LOGIN = /*GetName(oPC)+"_"+GetPCPlayerName(oPC)+*/" offline ressurection login.";
const string H2_TEXT_RESS_PC_CORPSE_ITEM = /*GetName(oCaster)+"_"+GetPCPlayerName(oCaster)+*/
                                           " cast raise dead/ressurection on corpse token of: ";
                                           /*+GetName(oDeadPlayer)+"_"+GetPCPlayerName(oDeadPlayer)  OR +H2_TEXT_OFFLINE_PLAYER+" "+uniquePCID*/

const string H2_TEXT_CORPSE_TOKEN_USED_BY = /*"NPC " + GetName(oCaster) + " ("*/
                                            "token used by: ";
                                            /*+") " + GetName(oTokenUser) + "_" + GetPCPlayerName(oTokenUser)*/

const string H2_TEXT_CORPSE_OF = "Corpse of "; //"Corpse of " + GetName(oDeadPC)
