/*
Filename:           h2_core_i
System:             core (include script)
Author:             Edward Beck (0100010)
Date Created:       Aug. 27, 2005
Summary:
HCR2 core function definitions.
This file holds the commonly used functions
used throughout the core HCR2 system.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date: Jun 30th 2006
Revision Author: Edward Beck (0100010)
Revision Summary: v1.2
Added code to handle new OnSpellHook event in h2_CopyEventVariablesToCoreDataPoint.
Fixed h2_SetPlayerHitPointsToSavedValue so it will not attempt to apply zero or negative
damage to the PC.
Altered h2_OpenRestDialog so it doesn't clear the skip cancel rest flag. this is now done
at the end of the rest cancel section in h2_playerrest_e. This fix now ensures that
the rest cancel hook in scripts are properly skipped when rest is cancelled as a result of the
rest conversation dialag being brought up. This fix along with the above set player hit point
fix, correct the 1 HP damage on open rest dialog bug.

Revision Date: Aug 30th, 2006
Revision Author: Edward Beck (0100010)
Revision Summary: v1.3
Added new function h2_RunAreaEventScripts to handle area event hooks.
Added code to handle new area events in h2_CopyEventVariablesToCoreDataPoint.
Adjusted h2_GetCurrentGameTime to have more readable output. (by Katy)
Added h2_RemoveEffectType function
Added h2_ColorText function
Alter h2_OpenRestDialog because condition checking is now done outside the function.

Revision Date: Nov 15th, 2006
Revision Author: Edward Beck (0100010)
Revision Summary: v1.4
Added new functions to handle Feat use per day tracking.
Fixed a bug where a PC's spells would reset to full without restriction if the
PC was completely exhausted of spells and either rested or relogged.

Revision Date: Dec 31st, 2006
Revision Author: Edward Beck (0100010)
Revision Summary: v1.5
Altered h2_MoveEquippedItems to not move or destory cursed/undroppable equipped item.
Seperated pre and post rest Feat and Spell recovery into their own functions.
Moved h2_GetSecondsSinceServerStarted from h2_timers_i.
Added h2_StartCharExportTimer function.
*/

#include "h2_timers_i"
#include "h2_persistence_c"
#include "x3_inc_string"

//This function runs all of the scripts of the given event type in order of the index they were given
//as was set on the variables in Module Properties.
//When calling this function, sEventType should be one of the H2_EVENT_* constants as defined in h2_constants_i.
void h2_RunModuleEventScripts(string sEventType);

//This functions runs all of the scripts of the given event type in order of the index they were given
//as set on the variables in Area properties.
//When calling this function, sEventType should be one of the H2_AREAEVENT_* constants as defined in
//h2_constants_i. All script assigned as variables on the area are fired before
//global area scripts, which are defined on the module.
//Global area event scripts are fired for all areas.
void h2_RunAreaEventScripts(string sEventType);

//Returns the number of seconds elapsed since the server was started.
int h2_GetSecondsSinceServerStart();

//Returns TRUE or FALSE depending on if location loc is valid.
int h2_GetIsLocationValid(location loc);

//Returns a string consisting of the constant H2_TEXT_CURRENT_GAME_DATE_TIME (defined in h2_core_t)
//followed by a datetime format MM/DD/YYYY HH:MM (if bDayBeforeMonth is FALSE)
//or the format DD/MM/YYYY HH:MM (if bDayBeforeMonth is TRUE) (to support other cultural date formats)
//The default value of bDayBeforeMonth is FALSE.
string h2_GetCurrentGameTime(int bDayBeforeMonth = FALSE);

//This function copies an item equipped in slot invSlot (one of the INVENTORY_SLOT_* constants) of oPossessor,
//into the inventory of the object designated by oReceivingObject (if oReceivingObject is valid)
//Local variables on the equipped item are copied. The item equipped on oPossessor is then destroyed.
//If either oPossessor or no item is equipped in the given slot, this function does nothing.
void h2_MoveEquippedItem(object oPossessor, int invSlot, object oReceivingObject =  OBJECT_INVALID);

//This function copies all of the items in oPossessor's inventory into the inventory of oReceivingObject
//if oReceivingObject is valid. if bMoveGold is true, the gold is transfered as well.
//Local variables on items are also copied. The items in oPossessor's inventory are then destroyed.
//This function will NOT copy or destroy items that have been marked as cursed (not droppable) on their palette.
//If oPossessor is invalid, this function does nothing.
void h2_MovePossessorInventory(object oPossessor, int bMoveGold = FALSE, object oReceivingObject = OBJECT_INVALID);

//This function copies all equipped items from oPossessor into the inventory of oReceivingObject
//if oReceivingObject is valid.Local variables on the equipped items are copied.
//The items equipped on oPossessor are then destroyed.
//Item located in any of the creature slots are neither copied or destoyed.
//If oPossessor is invalid, this function does nothing.
void h2_MoveEquippedItems(object oPossessor, object oReceivingObject = OBJECT_INVALID);

//Destoys all items in oPossessor's inventory that have the Cursed (no drop) flag checked.
void h2_DestroyNonDroppableItemsInInventory(object oPossessor);

//This function boots the player oPC after the number of seconds indicated by delay has passed.
//If sMessage is not empty, the it will be send to the oPC prior to the boot.
//The PCPlayerName of oPC and sMessage are sent to the DM channel and written to the server logs.
//If oPC is invalid this function does nothing.
void h2_BootPlayer(object oPC, string sMessage = "", float delay = 0.0);

//This function bans a player by their public CDKey.
//It writes the ban information to the external database then boots the
//player with the "You are Banned" message.
void h2_BanPlayerByCDKey(object oPC);

//This function bans a player by their IP Address.
//It writes the ban information to the external database then boots the
//player with the "You are Banned" message.
void h2_BanPlayerByIPAddress(object oPC);

//This function removes all effects from oCreature. It does nothing if oCreature is invalid.
void h2_RemoveEffects(object oCreature);

//This function removes all effects of type nEffectType. It does nothing if oCreature is invalid.
void h2_RemoveEffectType(object oCreature, int nEffectType);

//This function lowers the value of oPC's current hitpoint to the value saved as H2_PLAYER_HP on oPC.
//This function does nothing if oPC is invalid or oPC's current hit points are less than or equal to the saved
//value.
void h2_SetPlayerHitPointsToSavedValue(object oPC);

//This function decrements remaining spell uses to values stored as H2_SPELL_TRACK on oPC.
//this function does nothing if oPC is invalid.
void h2_SetAvailableSpellsToSavedValues(object oPC);

//This function decrements remaining feat uses to values stored as H2_FEAT_TRACK on oPC.
//this function does nothing if oPC is invalid.
void h2_SetAvailableFeatsToSavedValues(object oPC);

//Saves oPCs hitpoints to a local variable H2_PLAYER_HP on oPC.
void h2_SavePCHitPoints(object oPC);

//Saves the values of the remaining uses of oPC's current spells to H2_SPELL_TRACK on oPC.
void h2_SavePCAvailableSpells(object oPC);

//Saves the values of the remaining uses of oPC's current feats to H2_FEAT_TRACK on oPC.
void h2_SavePCAvailableFeats(object oPC);

//Drops all henchman from oPC.
void h2_DropAllHenchmen(object oPC);

//Searchs the logged in PCs and returns the PC with the matching uniquePCID.
//Returns OBJECT_INVALID if not found.
object h2_FindPCWithGivenUniqueID(string uniquePCID);

//Rolls a standard skill check for nSkill for oUser.
//The return value is d20 + rank + modifiers.
//If nBroadCastLevel = 0, only the DM channel gets the results.
//If nBroadCastLevel = 1, the skill user gets the results as well.
//If nBroadCastLevel = 2, then in addtion to the above, all nearby PCs also get the result.
int h2_SkillCheck(int nSkill, object oUser, int nBroadCastLevel = 1);

//Adds a color token  to sText from the given RGB values
//string h2_ColorText(string sText, int nRed=255, int nGreen=255, int nBlue=255);
string h2_ColorText(string sText, string sColor);

//Saves the current in game month, day, year, hour and minute to the external database.
void h2_SaveCurrentCalendar();

//Saves the current location of oPC to oPC's data item, if oPC is not invalid.
void h2_SavePCLocation(object oPC);

//This creates a waypoint at the module starting location that is used to store core framework
//variables so that it does not have to relay on using the over-used module object to store things.
void h2_CreateCoreDataPoint();

//This sets the current game calendar and time to the data and time values last saved in the
//external database.
void h2_RestoreSavedCalendar();

//Call this after the game date and time has been restored with h2_RestoreSavedCalendar.
//This saved the current date and time as the server start time. Used in calculated the elapsed time
//passed for timers and various other effects.
void h2_SaveServerStartTime();

//This copies all of the module event variables that the mod builder included
//over to the core data waypoint object. This is merely to take them off the
//over-used module object and increase the access time somewhat.
//sEventType in used internally for recursion, to not alter it from the default.
void h2_CopyEventVariablesToCoreDataPoint(string sEventType = "");

//This creates a menu item in the conversation that is opened when the 'Player Info and Action Item'
//is activated by the PC. sMenuText is the text you want to appear to the user for that menu choice.
//sConvResRef is the resref of a conversation file that will be opened as a result
//of the PC choosing that menu. Note that all of the conversations are opened as if the PC
//is conversing with themselves, private conversation is true, and play hello is false.
//If sMenuText is an empty string nothing will be added.
//Only a maximum of 20 menu items can be added, if you exceed this amount the menu item
//is not added, instead a log file is generated stating that the maximim number of items was exceeded.
//This function should only be called from a module load hook-in script.
void h2_AddPlayerDataMenuItem(string sMenuText, string sConvResRef);

//This creats the player data item which can hold persistant info pertaining to that oPC
//which will survive server resets.
void h2_CreatePlayerDataItem(object oPC);

//Retrieves the next unused Unique Identifier ID for assignment to oPC.
//The unique ID is the hexstring conversion (making it a string of length 10) of a uniquely assigned integer
//(which even only counting positive integer values, allows for 2147483647 unique PCs over the life of your mod)
string h2_GetNewUniquePCID();

//Sends oPC to their last saved location.
//Does nothing if oPC is invalid.
void h2_SendPCToSavedLocation(object oPC);

//Registers the PCs. by incrementing the players registered character count
//and sending appropraite feedback.
void h2_RegisterPC(object oPC);

//Performs important set up activity on oPC's first login
//including getting and setting the unique player ID and other player persistant
//information.
void h2_InitializePC(object oPC);

//Strips oPC of all items on their first login then sets the flag H2_STRIPPED to TRUE
//so subsequent logins will not strip this PC.
//This function is only ran if H2_STRIP_ON_FIRST_LOGIN = TRUE.
void h2_StripOnFirstLogin(object oPC);

//Checks if oPC has been assigned a uniquePCID (a hexstring based on a unique interger value)
//If oPC does not have one, a new one is obtained and assigned.
void h2_SetPlayerID(object oPC);

//Returns TRUE if the number of non-DM PCs currently online equal the value set to H2_MAXIMUM_PLAYERS
//This function is used in determining if enough slots remain open for the DM Reserve amount.
int h2_MaximumPlayersReached();

//Saves various Persistent PC data. This function is ran during the client leave event.
void h2_SavePersistentPCData(object oPC);

//Returns a TRUE or FALSE value that says whether or not rest should be allowed (TRUE)
//or not allowed (FALSE) for oPC.
int h2_GetAllowRest(object oPC);

//bAllowRest should be TRUE or FALSE.
//This sets a variable than when read by h2_GetAllowRest, returns the value of bAllowRest.
//This should be set to FALSE if oPC should not be allowed to rest on their next rest action.
void h2_SetAllowRest(object oPC, int bAllowRest);

//Returns a TRUE or FALSE value indicating whether or not Spells should allowed to be
//properly recovered after the oPC's next rest if finished.
int h2_GetAllowSpellRecovery(object oPC);

//Returns a TRUE or FALSE value indicating whether or not Feats should allowed to be
//properly recovered after the oPC's next rest if finished.
int h2_GetAllowFeatRecovery(object oPC);

//bAllowRecovery should be TRUE or FALSE
//This set a variable than when read by h2_GetAllowSpellRecovery, returns the value of bAllowRecovery.
//This should be set to FALSE if oPC should not be allowed to recover spells after their
//next rest action is finished.
void h2_SetAllowSpellRecovery(object oPC, int bAllowRecovery);

//bAllowRecovery should be TRUE or FALSE
//This set a variable than when read by h2_GetAllowFeatRecovery, returns the value of bAllowRecovery.
//This should be set to FALSE if oPC should not be allowed to recover feats after their
//next rest action is finished.
void h2_SetAllowFeatRecovery(object oPC, int bAllowRecovery);

//Returns an integer that indiated that amount of HitPoints oPC should be allowed to regain
//after their next rest action is finished.
int h2_GetPostRestHealAmount(object oPC);

//This sets the amount of HitPoints oPC will be allowed to regain
//after their next rest action is finished.
void h2_SetPostRestHealAmount(object oPC, int amount);

//This function opens the rest dialog for the PC if h2_GetAllowRest returns TRUE.
void h2_OpenRestDialog(object oPC);

//This makes oPC actually rest. It will not open the rest dialog
//when the rest occurs. Run this from a node that allows rest in the rest
//conversation dialogue.
void h2_MakePCRest(object oPC);

//Sets up a Rest Menu Item that will be displayed in the rest conversation dialogue for oPC.
//oPC is the player that is about to rest.
//sMenuText is the text of the option and sActionScript is the name of the script
//that will get executed if the option is selected.
//The OBJECT_SELF for the action script is oPC.
//If sMenuText is empty the rest menu option will not be added.
//A maximum of 10 menu items can be added, and one of those is added by default, leaving only 9 additional
//ones available to customize. Attempting to add more will have no effect, beyond a log entry being made.
//This should only be called from rest started event hook-in scripts.
void h2_AddRestMenuItem(object oPC, string sMenuText, string sActionScript = H2_REST_MENU_DEFAULT_ACTION_SCRIPT);

//This function uses the value from h2_GetPostRestHealAmount to restricted
//the amount of HitPoints gained after oPC's rest is finished.
//It should be called from rest event finished script hook-ins.
void h2_LimitPostRestHeal(object oPC, int postRestHealAmt);

//general functions
void h2_RunModuleEventScripts(string sEventType)
{
    int index = 1;
    string scriptname = h2_GetModLocalString(sEventType + IntToString(index));
    while (scriptname != "")
    {
        ExecuteScript(scriptname, OBJECT_SELF);
        index++;
        scriptname = h2_GetModLocalString(sEventType + IntToString(index));
    }
}

void h2_RunAreaEventScripts(string sEventType)
{
    int index = 1;
    string scriptname = GetLocalString(OBJECT_SELF, sEventType + IntToString(index));
    while (scriptname != "")
    {
        ExecuteScript(scriptname, OBJECT_SELF);
        index++;
        scriptname = GetLocalString(OBJECT_SELF, sEventType + IntToString(index));
    }
    h2_RunModuleEventScripts(sEventType);
}

int h2_GetSecondsSinceServerStart()
{
    // get start date and time
    int nStartYr = h2_GetModLocalInt(H2_SERVER_START_YEAR);
    int nStartMn = h2_GetModLocalInt(H2_SERVER_START_MONTH);
    int nStartDy = h2_GetModLocalInt(H2_SERVER_START_DAY);
    int nStartHr = h2_GetModLocalInt(H2_SERVER_START_HOUR);

    // get current date and time
    int nCurYr = GetCalendarYear();
    int nCurMn = GetCalendarMonth();
    int nCurDy = GetCalendarDay();
    int nCurHr = GetTimeHour();
    int nCurMi = GetTimeMinute();
    int nCurSc = GetTimeSecond();

    // get the real time to game Time Conversion Factor (TCF)
    int nTCF = FloatToInt(HoursToSeconds(1));

    // calculate difference between now and then
    int nElapsed = nCurYr - nStartYr;                       // years
    nElapsed = (nElapsed * 12) + (nCurMn - nStartMn);       // to months
    nElapsed = (nElapsed * 28) + (nCurDy - nStartDy);       // to days
    nElapsed = (nElapsed * 24) + (nCurHr - nStartHr);       // to hours
    nElapsed = (nElapsed * nTCF) + (nCurMi * 60) + nCurSc;  // to seconds

    // return the total
    return nElapsed;
}


int h2_GetIsLocationValid(location loc)
{
    object oArea = GetAreaFromLocation(loc);
    vector v = GetPositionFromLocation(loc);
    if (GetIsObjectValid(oArea) == FALSE || v.x < 0.0 || v.y < 0.0)
        return FALSE;
    return TRUE;
}

string h2_GetCurrentGameTime(int bDayBeforeMonth = FALSE)
{
    int rl_minutes = GetTimeMinute();
    int rl_minutes_per_hour = FloatToInt(HoursToSeconds(1) / 60);
    int game_minutes_per_hour = 60 / rl_minutes_per_hour;
    int game_minutes = rl_minutes * game_minutes_per_hour;
    string s_minutes = IntToString(game_minutes);
    if (game_minutes < 10)
        s_minutes = "0" + s_minutes;

    string currentTime = H2_TEXT_CURRENT_GAME_DATE_TIME + IntToString(GetCalendarMonth()) + "/" +
                            IntToString(GetCalendarDay()) + "/" + IntToString(GetCalendarYear()) + " " +
                            IntToString(GetTimeHour()) + ":" + s_minutes;
    if (bDayBeforeMonth)
        currentTime = H2_TEXT_CURRENT_GAME_DATE_TIME + IntToString(GetCalendarDay()) + "/" +
                            IntToString(GetCalendarMonth()) + "/" + IntToString(GetCalendarYear()) + " " +
                            IntToString(GetTimeHour()) + ":" + s_minutes;
    return currentTime;
}

void h2_MoveEquippedItem(object oPossessor, int invSlot, object oReceivingObject =  OBJECT_INVALID)
{
    if (!GetIsObjectValid(oPossessor))
        return;
    object oItem = GetItemInSlot(invSlot, oPossessor);
    if (GetIsObjectValid(oItem))
    {
        if (GetIsObjectValid(oReceivingObject) && !GetItemCursedFlag(oItem))
            CopyItem(oItem, oReceivingObject, TRUE);
        if (!GetItemCursedFlag(oItem))
            DestroyObject(oItem);
    }
}

void h2_MovePossessorInventory(object oPossessor, int bMoveGold = FALSE, object oReceivingObject = OBJECT_INVALID)
{
    if (!GetIsObjectValid(oPossessor))
        return;
    if (GetLocalInt(oPossessor, H2_MOVING_ITEMS))
        return;
    SetLocalInt(oPossessor, H2_MOVING_ITEMS, 1);
    if (bMoveGold)
    {
        int nGold = GetGold(oPossessor);
        if (nGold)
        {
            if (GetIsObjectValid(oReceivingObject))
                AssignCommand(oReceivingObject, TakeGoldFromCreature(nGold, oPossessor));
            else
                AssignCommand(oPossessor, TakeGoldFromCreature(nGold, oPossessor, TRUE));
        }
    }
    object oItem = GetFirstItemInInventory(oPossessor);
    while (GetIsObjectValid(oItem))
    {
        if (!GetItemCursedFlag(oItem))
        {
            if (GetIsObjectValid(oReceivingObject))
                CopyItem(oItem, oReceivingObject, TRUE);
            DestroyObject(oItem);
        }
        oItem = GetNextItemInInventory(oPossessor);
    }
    DeleteLocalInt(oPossessor, H2_MOVING_ITEMS);
}

void h2_MoveEquippedItems(object oPossessor, object oReceivingObject = OBJECT_INVALID)
{
    if (!GetIsObjectValid(oPossessor))
        return;
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_ARMS, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_ARROWS, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_BELT, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_BOLTS, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_BOOTS, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_BULLETS, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_CHEST, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_CLOAK, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_HEAD, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_LEFTHAND, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_LEFTRING, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_NECK, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_RIGHTHAND, oReceivingObject);
    h2_MoveEquippedItem(oPossessor, INVENTORY_SLOT_RIGHTRING, oReceivingObject);
}

void h2_DestroyNonDroppableItemsInInventory(object oPossessor)
{
    object oItem = GetFirstItemInInventory(oPossessor);
    while (GetIsObjectValid(oItem))
    {
        if (GetItemCursedFlag(oItem))
            DestroyObject(oItem);
        oItem = GetNextItemInInventory(oPossessor);
    }
}

void h2_BootPlayer(object oPC, string sMessage = "", float delay = 0.0)
{
    if (!GetIsObjectValid(oPC))
        return;
    if (sMessage != "")
        SendMessageToPC(oPC, sMessage);
    sMessage = GetPCPlayerName(oPC) + " BOOTED: " + sMessage;
    SendMessageToAllDMs(sMessage);
    WriteTimestampedLogEntry(sMessage);
    DelayCommand(delay, BootPC(oPC));
}

void h2_BanPlayerByCDKey(object oPC)
{
    string sMessage = GetName(oPC) + "_" + GetPCPlayerName(oPC) + " banned by: " + GetName(OBJECT_SELF) + "_" + GetPCPlayerName(OBJECT_SELF);
    h2_SetExternalString(H2_BANNED_PREFIX + GetPCPublicCDKey(oPC), sMessage);
    SendMessageToAllDMs(sMessage);
    WriteTimestampedLogEntry(sMessage);
    h2_BootPlayer(oPC, H2_TEXT_YOU_ARE_BANNED);
}

void h2_BanPlayerByIPAddress(object oPC)
{
    string sMessage = GetName(oPC) + "_" + GetPCPlayerName(oPC) + " banned by: " + GetName(OBJECT_SELF) + "_" + GetPCPlayerName(OBJECT_SELF);
    h2_SetExternalString(H2_BANNED_PREFIX + GetPCIPAddress(oPC), sMessage);
    SendMessageToAllDMs(sMessage);
    WriteTimestampedLogEntry(sMessage);
    h2_BootPlayer(oPC, H2_TEXT_YOU_ARE_BANNED);
}

void h2_RemoveEffects(object oCreature)
{
    if (!GetIsObjectValid(oCreature))
        return;
    effect eff = GetFirstEffect(oCreature);
    while (GetEffectType(eff) != EFFECT_TYPE_INVALIDEFFECT)
    {
        RemoveEffect(oCreature, eff);
        eff = GetNextEffect(oCreature);
    }
}

void h2_RemoveEffectType(object oCreature, int nEffectType)
{
    if (!GetIsObjectValid(oCreature))
        return;
    effect eff = GetFirstEffect(oCreature);
    while (GetEffectType(eff) != EFFECT_TYPE_INVALIDEFFECT)
    {
        if (GetEffectType(eff) == nEffectType)
            RemoveEffect(oCreature, eff);
        eff = GetNextEffect(oCreature);
    }
}

void h2_SetPlayerHitPointsToSavedValue(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    int currHP = GetCurrentHitPoints(oPC);
    int savedHP = GetLocalInt(oPC, H2_PLAYER_HP);
    int damage = currHP - savedHP;
    if (damage < currHP && damage > 0)
    {
        effect eDam = EffectDamage(damage);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
    }
}

int h2_GetFeatUsesRemaining(object oPC, int nFeat, int nMaxUses)
{
    int nCount = 0;
    int i;
    for (i = 0; i <= nMaxUses; i++)
    {
        int bHasFeat = GetHasFeat(nFeat, oPC);
        if (bHasFeat)
        {
            nCount += 1;
            DecrementRemainingFeatUses(oPC, nFeat);
        }
        else
            break;
    }
    if (nCount == nMaxUses+1)
        nCount = -1;
    for (i = 0; i < nCount; i++)
    {
        IncrementRemainingFeatUses(oPC, nFeat);
    }
    return nCount;
}

void h2_SetFeatsRemaining(object oPC, int nFeat, int nUses)
{
    int i;
    for (i = 0; i < 50; i++)
    {
        int bHasFeat = GetHasFeat(nFeat, oPC);
        if (bHasFeat)
            DecrementRemainingFeatUses(oPC, nFeat);
        else
            break;
    }
    if (i < 50)
    {
        for (i = 0; i < nUses; i++)
            IncrementRemainingFeatUses(oPC, nFeat);
    }
}

void h2_SetAvailableFeatsToSavedValues(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    string sFeatTrack = GetLocalString(oPC, H2_FEAT_TRACK);
    if (sFeatTrack == "")
        return;
    sFeatTrack = GetStringRight(sFeatTrack, GetStringLength(sFeatTrack) - 1);
    while (sFeatTrack != "")
    {
        int nDivIndex = FindSubString(sFeatTrack, "|");
        int nValIndex = FindSubString(sFeatTrack, ":");
        int nFeat = StringToInt(GetStringLeft(sFeatTrack, nValIndex));
        int nUses = StringToInt(GetSubString(sFeatTrack,  nValIndex + 1, nDivIndex - nValIndex - 1));
        h2_SetFeatsRemaining(oPC, nFeat, nUses);
        sFeatTrack = GetStringRight(sFeatTrack, GetStringLength(sFeatTrack) - nDivIndex - 1);
    }
}

void h2_SetAvailableSpellsToSavedValues(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    string sSpelltrack = GetLocalString(oPC, H2_SPELL_TRACK);
    if (sSpelltrack == "")
        return;

    int nSpellID;
    for(nSpellID = 0; nSpellID < 550; nSpellID++) {
        int nSpellsRemaining = GetHasSpell(nSpellID, oPC);
        if (nSpellsRemaining > 0)
        {
            int nIndex = FindSubString(sSpelltrack, IntToString(nSpellID)+":");
            if (nIndex == -1)
            {
                //decrement spells that the player has, but were not known to have been set on
                //their last log out.
                while (nSpellsRemaining > 0) {
                    DecrementRemainingSpellUses(oPC, nSpellID);
                    nSpellsRemaining--;
                }
            }
            else //the PC has a spell that is being tracked.
            {   //get the saved remaining spells, and decrement them to the correct value.
                string sSavedSpellsRemaining = GetSubString(sSpelltrack, nIndex + GetStringLength(IntToString(nSpellID)) + 1, 1);
                int nSpellsToDecrement = nSpellsRemaining - StringToInt(sSavedSpellsRemaining);
                while (nSpellsToDecrement > 0) {
                    DecrementRemainingSpellUses(oPC, nSpellID);
                    nSpellsToDecrement--;
                }
            }
        }
    }
}

void h2_SavePCHitPoints(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    int hp = GetCurrentHitPoints(oPC);
    SetLocalInt(oPC, H2_PLAYER_HP, hp);
}

string h2_AppendToFeatTrack(string sFeatTrack, object oPC, int nFeat, int nMaxUses)
{
    int nFeatUses = h2_GetFeatUsesRemaining(oPC, nFeat, nMaxUses);
    if (nFeatUses > -1)
        return sFeatTrack + IntToString(nFeat) + ":" + IntToString(nFeatUses) + "|";
    return sFeatTrack;
}

void h2_SavePCAvailableFeats(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    int i;
    string sFeatTrack = "X";
    for (i = 1; i <= 3; i++)
    {
        int nClass = GetClassByPosition(i, oPC);
        switch (nClass)
        {
            case CLASS_TYPE_BARBARIAN:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_BARBARIAN_RAGE, 11);
                break;
            case CLASS_TYPE_BARD:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_BARD_SONGS, 44);
                break;
            case CLASS_TYPE_CLERIC:
            {
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TURN_UNDEAD, 24);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEATH_DOMAIN_POWER, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PROTECTION_DOMAIN_POWER, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_STRENGTH_DOMAIN_POWER, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TRICKERY_DOMAIN_POWER, 1);
                break;
            }
            case CLASS_TYPE_DRUID:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ANIMAL_COMPANION, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_WILD_SHAPE, 6);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ELEMENTAL_SHAPE, 4);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_WILD_SHAPE_DRAGON, 3);
                break;
            case CLASS_TYPE_MONK:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_STUNNING_FIST, 43);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EMPTY_BODY, 2);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_QUIVERING_PALM, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_WHOLENESS_OF_BODY, 1);
                break;
            case CLASS_TYPE_PALADIN:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TURN_UNDEAD, 24);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_LAY_ON_HANDS, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_REMOVE_DISEASE, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SMITE_EVIL, 3);
                break;
            case CLASS_TYPE_RANGER:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ANIMAL_COMPANION, 1);
                break;
            case CLASS_TYPE_ROGUE:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEFENSIVE_ROLL, 1);
                break;
            case CLASS_TYPE_SORCERER:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_FAMILIAR, 1);
                break;
            case CLASS_TYPE_WIZARD:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_FAMILIAR, 1);
                break;
            case CLASS_TYPE_ARCANE_ARCHER:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_IMBUE_ARROW, 3);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_HAIL_OF_ARROWS, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_ARROW_OF_DEATH, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_SEEKER_ARROW_1, 2);
                break;
            case CLASS_TYPE_ASSASSIN:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_DARKNESS, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_INVISIBILITY_1, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_INVISIBILITY_2, 1);
                break;
            case CLASS_TYPE_BLACKGUARD:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TURN_UNDEAD, 24);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SMITE_GOOD, 3);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_DARK_BLESSING, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_BULLS_STRENGTH, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_SERIOUS_WOUNDS, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_CRITICAL_WOUNDS, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_CONTAGION, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_LIGHT_WOUNDS, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_MODERATE_WOUNDS, 1);
                break;
            case CLASS_TYPE_HARPER:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_CATS_GRACE, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_EAGLES_SPLENDOR, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_INVISIBILITY, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_SLEEP, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_CRAFT_HARPER_ITEM, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TYMORAS_SMILE, 1);
                break;
            case CLASS_TYPE_SHADOWDANCER:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_SHADOW, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SHADOW_DAZE, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SHADOW_EVADE, 3);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEFENSIVE_ROLL, 1);
                break;
            case CLASS_TYPE_PALEMASTER:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ANIMATE_DEAD, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_UNDEAD, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_UNDEAD_GRAFT_1, 9);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_GREATER_UNDEAD, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEATHLESS_MASTER_TOUCH, 3);
                break;
            case CLASS_TYPE_DRAGON_DISCIPLE:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DRAGON_DIS_BREATH, 1);
                break;
            case CLASS_TYPE_SHIFTER:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_1, 3);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_2, 3);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_3, 3);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_4, 3);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HUMANOID_SHAPE, 3);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_CONSTRUCT_SHAPE, 3);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_OUTSIDER_SHAPE, 3);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_WILD_SHAPE_UNDEAD, 3);
                break;
            case CLASS_TYPE_DIVINE_CHAMPION:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_LAY_ON_HANDS, 1);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SMITE_EVIL, 3);
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DIVINE_WRATH, 1);
                break;
            case CLASS_TYPE_WEAPON_MASTER:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_KI_DAMAGE, 30);
                break;
            case CLASS_TYPE_DWARVEN_DEFENDER:
                sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE, 20);
                break;
        }
    }
    if (GetHitDice(oPC) > 20)
    {
        sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_DRAGON_KNIGHT, 1);
        sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_HELLBALL, 1);
        sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_MAGE_ARMOUR, 1);
        sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_MUMMY_DUST, 1);
        sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_RUIN, 1);
        sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_EPIC_WARDING, 1);
        sFeatTrack = h2_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_BLINDING_SPEED, 1);
    }
    SetLocalString(oPC, H2_FEAT_TRACK, sFeatTrack);
}

void h2_SavePCAvailableSpells(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    string sSpelltrack = "X";
    int nSpellID;
    for (nSpellID = 0; nSpellID < 550; nSpellID++) {
        int nSpellsRemaining = GetHasSpell(nSpellID, oPC);
        if(nSpellsRemaining > 0)
            sSpelltrack = sSpelltrack + IntToString(nSpellID) + ":" + IntToString(nSpellsRemaining) + "|";
    }
    SetLocalString(oPC, H2_SPELL_TRACK, sSpelltrack);
}

void h2_DropAllHenchmen(object oPC)
{
    object oHenchman = GetHenchman(oPC);
    while (GetIsObjectValid(oHenchman))
    {
        RemoveHenchman(oPC, oHenchman);
        oHenchman = GetHenchman(oPC);
    }
}

object h2_FindPCWithGivenUniqueID(string uniquePCID)
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        if (uniquePCID == h2_GetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID))
            return oPC;
        oPC = GetNextPC();
    }
    return OBJECT_INVALID;
}

int h2_SkillCheck(int nSkill, object oUser, int nBroadCastLevel = 1)
{
    int nRank = GetSkillRank(nSkill, oUser);
    int nRoll = d20();
    string sSkill;
    switch (nSkill)
    {
        case SKILL_ANIMAL_EMPATHY:   sSkill = H2_TEXT_SKILL_ANIMAL_EMPATHY;     break;
        case SKILL_APPRAISE:         sSkill = H2_TEXT_SKILL_APPRAISE;           break;
        case SKILL_BLUFF:            sSkill = H2_TEXT_SKILL_BLUFF;              break;
        case SKILL_CONCENTRATION:    sSkill = H2_TEXT_SKILL_CONCENTRATION;      break;
        case SKILL_CRAFT_ARMOR:      sSkill = H2_TEXT_SKILL_CRAFT_ARMOR;        break;
        case SKILL_CRAFT_TRAP:       sSkill = H2_TEXT_SKILL_CRAFT_TRAP;         break;
        case SKILL_CRAFT_WEAPON:     sSkill = H2_TEXT_SKILL_CRAFT_WEAPON;       break;
        case SKILL_DISABLE_TRAP:     sSkill = H2_TEXT_SKILL_DISABLE_TRAP;       break;
        case SKILL_DISCIPLINE:       sSkill = H2_TEXT_SKILL_DISCIPLINE;         break;
        case SKILL_HEAL:             sSkill = H2_TEXT_SKILL_HEAL;               break;
        case SKILL_HIDE:             sSkill = H2_TEXT_SKILL_HIDE;               break;
        case SKILL_INTIMIDATE:       sSkill = H2_TEXT_SKILL_INTIMIDATE;         break;
        case SKILL_LISTEN:           sSkill = H2_TEXT_SKILL_LISTEN;             break;
        case SKILL_LORE:             sSkill = H2_TEXT_SKILL_LORE;               break;
        case SKILL_MOVE_SILENTLY:    sSkill = H2_TEXT_SKILL_MOVE_SILENTLY;      break;
        case SKILL_OPEN_LOCK:        sSkill = H2_TEXT_SKILL_OPEN_LOCK;          break;
        case SKILL_PARRY:            sSkill = H2_TEXT_SKILL_PARRY;              break;
        case SKILL_PERFORM:          sSkill = H2_TEXT_SKILL_PERFORM;            break;
        case SKILL_PERSUADE:         sSkill = H2_TEXT_SKILL_PERSUADE;           break;
        case SKILL_PICK_POCKET:      sSkill = H2_TEXT_SKILL_PICK_POCKET;        break;
        case SKILL_SEARCH:           sSkill = H2_TEXT_SKILL_SEARCH;             break;
        case SKILL_SET_TRAP:         sSkill = H2_TEXT_SKILL_SET_TRAP;           break;
        case SKILL_SPELLCRAFT:       sSkill = H2_TEXT_SKILL_SPELLCRAFT;         break;
        case SKILL_SPOT:             sSkill = H2_TEXT_SKILL_SPOT;               break;
        case SKILL_TAUNT:            sSkill = H2_TEXT_SKILL_TAUNT;              break;
        case SKILL_TUMBLE:           sSkill = H2_TEXT_SKILL_TUMBLE;             break;
        case SKILL_USE_MAGIC_DEVICE: sSkill = H2_TEXT_SKILL_USE_MAGIC_DEVICE;   break;
    }

    string sMessage = GetName(oUser) + " " + sSkill + H2_TEXT_SKILL_CHECK + IntToString(nRoll) +
                        " + " + IntToString(nRank) + " = " + IntToString(nRoll + nRank);
    SendMessageToAllDMs(sMessage);
    
    if (nBroadCastLevel == 1)
        SendMessageToPC(oUser, sMessage);
    else if (nBroadCastLevel == 2)
        FloatingTextStringOnCreature(sMessage, oUser);

    return nRank + nRoll;
}

//The original h2_ColorText function was causing compile errors because of the contents of the
//  constant H2_COLORSTRING.  The new version uses the much simpler StringToRGBString from
//  x3_inc_string.

//string h2_ColorText(string sText, int nRed=255, int nGreen=255, int nBlue=255)
string h2_ColorText(string sText, string sColor)
{
    //return "<c" + GetSubString(H2_COLORSTRING, nRed, 1) + GetSubString(H2_COLORSTRING, nGreen, 1) + GetSubString(H2_COLORSTRING, nBlue, 1) + ">" + sText + "</c>";
    return StringToRGBString(sText, sColor);
}
//end general functions

//heartbeat functions
void h2_SaveCurrentCalendar()
{
    h2_SetExternalInt(H2_CURRENT_HOUR, GetTimeHour());
    h2_SetExternalInt(H2_CURRENT_DAY, GetCalendarDay());
    h2_SetExternalInt(H2_CURRENT_MONTH, GetCalendarMonth());
    h2_SetExternalInt(H2_CURRENT_YEAR, GetCalendarYear());
    h2_SetExternalInt(H2_CURRENT_MIN, GetTimeMinute());
}

void h2_SavePCLocation(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    h2_SetPlayerPersistentLocation(oPC, H2_PC_SAVED_LOC, GetLocation(oPC));
}
//end heartbeat functions

//Module load functions
void h2_CreateCoreDataPoint()
{
    CreateObject(OBJECT_TYPE_WAYPOINT, H2_CORE_DATA_POINT, GetStartingLocation());
}

void h2_RestoreSavedCalendar()
{
    int iCurYear = h2_GetExternalInt(H2_CURRENT_YEAR);
    int iCurMonth = h2_GetExternalInt(H2_CURRENT_MONTH);
    int iCurDay = h2_GetExternalInt(H2_CURRENT_DAY);
    int iCurHour = h2_GetExternalInt(H2_CURRENT_HOUR);
    int iCurMin = h2_GetExternalInt(H2_CURRENT_MIN);
    if(iCurYear) {
        SetTime(iCurHour, iCurMin, 0, 0);
        SetCalendar(iCurYear, iCurMonth, iCurDay);
    }
}

void h2_SaveServerStartTime() //Call this after the Calandar has been restored.
{
    h2_SetModLocalInt(H2_SERVER_START_HOUR, GetTimeHour());
    h2_SetModLocalInt(H2_SERVER_START_DAY, GetCalendarDay());
    h2_SetModLocalInt(H2_SERVER_START_MONTH, GetCalendarMonth());
    h2_SetModLocalInt(H2_SERVER_START_YEAR, GetCalendarYear());
}

void h2_CopyEventVariablesToCoreDataPoint(string sEventType = "")
{
    if (sEventType != "")
    {
        object oMod = GetModule();
        int index = 1;
        string scriptname = GetLocalString(oMod, sEventType + IntToString(index));
        while (scriptname != "")
        {
            h2_SetModLocalString(sEventType + IntToString(index), scriptname);
            DeleteLocalString(oMod, sEventType + IntToString(index));
            index++;
            scriptname = GetLocalString(oMod, sEventType + IntToString(index));
        }
    }
    else
    {
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_ACQUIRE_ITEM);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_ACTIVATE_ITEM);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_CLIENT_ENTER);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_CLIENT_LEAVE);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_CUTSCENE_ABORT);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_HEARTBEAT);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_MODULE_LOAD);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_PLAYER_DEATH);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_PLAYER_DYING);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_PLAYER_EQUIP_ITEM);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_PLAYER_RESPAWN);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_PLAYER_LEVEL_UP);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_PLAYER_REST_STARTED);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_PLAYER_REST_CANCELLED);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_PLAYER_REST_FINISHED);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_PLAYER_UNEQUIP_ITEM);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_SPELLHOOK);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_UNACQUIRE_ITEM);
        h2_CopyEventVariablesToCoreDataPoint(H2_EVENT_ON_USER_DEFINED);
        h2_CopyEventVariablesToCoreDataPoint(H2_AREAEVENT_ON_ENTER);
        h2_CopyEventVariablesToCoreDataPoint(H2_AREAEVENT_ON_EXIT);
        h2_CopyEventVariablesToCoreDataPoint(H2_AREAEVENT_ON_HEARTBEAT);
        h2_CopyEventVariablesToCoreDataPoint(H2_AREAEVENT_ON_USER_DEFINED);
    }
}

void h2_AddPlayerDataMenuItem(string sMenuText, string sConvResRef)
{
     if (sMenuText == "")
        return;
    int index = h2_GetModLocalInt(H2_PLAYER_DATA_MENU_INDEX) + 1;
    if (index <=20)
    {
        h2_SetModLocalInt(H2_PLAYER_DATA_MENU_INDEX, index);
        h2_SetModLocalString(H2_PLAYER_DATA_MENU_ITEM_TEXT + IntToString(index), sMenuText);
        h2_SetModLocalString(H2_CONVERSATION_RESREF + IntToString(index), sConvResRef);
    }
    else
        WriteTimestampedLogEntry("Player Data Menu Item: " + sMenuText + " exceeded maximum allowed.");
}

void h2_StartCharExportTimer()
{
    if (H2_EXPORT_CHARACTERS_INTERVAL > 0.0)
    {
        int nTimerID = h2_CreateTimer(GetModule(), H2_EXPORT_CHAR_TIMER_SCRIPT, H2_EXPORT_CHARACTERS_INTERVAL);
        h2_StartTimer(nTimerID);
    }
}

//end module load functions

//client enter functions
void h2_CreatePlayerDataItem(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    object oPlayerDataItem =  GetItemPossessedBy(oPC, H2_PLAYER_DATA_ITEM);
    if (!GetIsObjectValid(oPlayerDataItem))
    {
        oPlayerDataItem = CreateItemOnObject(H2_PLAYER_DATA_ITEM, oPC);
        if (!GetIsObjectValid(oPlayerDataItem))
        {
            SendMessageToPC(oPC, H2_TEXT_PLAYER_DATA_ITEM_NOT_CREATED);
            return;
        }
        SendMessageToPC(oPC, H2_TEXT_PLAYER_DATA_ITEM_CREATED);
    }
}

string h2_GetNewUniquePCID()
{
    int nextID = h2_GetExternalInt(H2_NEXT_UNIQUE_PC_ID);
    string id = IntToHexString(nextID);
    nextID++;
    h2_SetExternalInt(H2_NEXT_UNIQUE_PC_ID, nextID);
    return id;
}

void h2_SendPCToSavedLocation(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    string uniquePCID = h2_GetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID);
    int hasLoggedInThisReset = h2_GetModLocalInt(uniquePCID + H2_INITIAL_LOGIN);
    if (!hasLoggedInThisReset && H2_SAVE_PC_LOCATION)
    {
        location savedLocation = h2_GetPlayerPersistentLocation(oPC, H2_PC_SAVED_LOC);
        if (h2_GetIsLocationValid(savedLocation))
        {
            SendMessageToPC(oPC, H2_TEXT_SEND_TO_SAVED_LOC);
            DelayCommand(H2_CLIENT_ENTER_JUMP_DELAY, AssignCommand(oPC, ActionJumpToLocation(savedLocation)));
        }
    }
}

void h2_SetPlayerID(object oPC)
{
    string uniquepcid = h2_GetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID);
    string fullpcname = GetName(oPC) + "_" + GetPCPlayerName(oPC);
    if (uniquepcid == "")
    {
        uniquepcid = h2_GetNewUniquePCID();
        h2_SetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID, uniquepcid);
        h2_SetExternalString(uniquepcid, fullpcname);
    }
    else
    {
        string storedName = h2_GetExternalString(uniquepcid);
        if (storedName != fullpcname)
        {
            string sMessage = fullpcname + H2_WARNING_INVALID_PLAYERID + storedName + H2_WARNING_ASSIGNED_NEW_PLAYERID;
            WriteTimestampedLogEntry(sMessage);
            SendMessageToAllDMs(sMessage);
            uniquepcid = h2_GetNewUniquePCID();
            h2_SetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID, uniquepcid);
            h2_SetExternalString(uniquepcid, fullpcname);
        }
    }
}

void h2_RegisterPC(object oPC)
{
    int registeredCharCount = h2_GetExternalInt(GetPCPlayerName(oPC) + H2_REGISTERED_CHAR_SUFFIX);
    h2_SetPlayerPersistentInt(oPC, H2_REGISTERED, TRUE);
    h2_SetExternalInt(GetPCPlayerName(oPC) + H2_REGISTERED_CHAR_SUFFIX, registeredCharCount + 1);
    SendMessageToPC(oPC, H2_TEXT_CHAR_REGISTERED);
    SendMessageToPC(oPC, H2_TEXT_TOTAL_REGISTERED_CHARS + IntToString(registeredCharCount + 1));
    SendMessageToPC(oPC, H2_TEXT_MAX_REGISTERED_CHARS + IntToString(H2_REGISTERED_CHARACTERS_ALLOWED));
}

void h2_InitializePC(object oPC)
{
    SetPlotFlag(oPC, FALSE);
    SetImmortal(oPC, FALSE);

    if (h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE) != H2_PLAYER_STATE_ALIVE)
    {
        SetLocalInt(oPC, H2_LOGIN_DEATH, TRUE);
        h2_MovePossessorInventory(oPC, TRUE);
        h2_MoveEquippedItems(oPC);
        DelayCommand(H2_CLIENT_ENTER_JUMP_DELAY, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC));
        return;
    }
    if (H2_STRIP_ON_FIRST_LOGIN)
        h2_StripOnFirstLogin(oPC);

    string uniquePCID = h2_GetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID);
    int savedHP = h2_GetModLocalInt(uniquePCID + H2_PLAYER_HP);
    if (savedHP < GetMaxHitPoints(oPC) && savedHP > 0)
    {
        h2_DeleteModLocalInt(uniquePCID + H2_PLAYER_HP);
        SetLocalInt(oPC, H2_PLAYER_HP, savedHP);
        h2_SetPlayerHitPointsToSavedValue(oPC);
    }

    string spelltrack = h2_GetModLocalString(uniquePCID + H2_SPELL_TRACK);
    string feattrack = h2_GetModLocalString(uniquePCID + H2_FEAT_TRACK);

    if (GetRacialType(oPC) > 6)
    {   //If racial type is above 6, then the PC is polymorphed.
        effect eff = GetFirstEffect(oPC);
        while (GetEffectType(eff)!= EFFECT_TYPE_INVALIDEFFECT)
        {   //some polymorphs add temporary hitpoints.
            if (GetEffectType(eff) == EFFECT_TYPE_POLYMORPH || GetEffectType(eff) == EFFECT_TYPE_TEMPORARY_HITPOINTS)
                RemoveEffect(oPC, eff);
            eff = GetNextEffect(oPC);
        }
    }

    if (spelltrack != "")
    {
        h2_DeleteModLocalString(uniquePCID + H2_SPELL_TRACK);
        SetLocalString(oPC, H2_SPELL_TRACK, spelltrack);
        DelayCommand(1.0, h2_SetAvailableSpellsToSavedValues(oPC));
    }

    if (feattrack != "")
    {
        h2_DeleteModLocalString(uniquePCID + H2_FEAT_TRACK);
        SetLocalString(oPC, H2_FEAT_TRACK, feattrack);
        DelayCommand(1.0, h2_SetAvailableFeatsToSavedValues(oPC));
    }

    h2_SendPCToSavedLocation(oPC);
    h2_SetModLocalInt(uniquePCID + H2_INITIAL_LOGIN, TRUE);

    int isRegistered = h2_GetPlayerPersistentInt(oPC, H2_REGISTERED);
    if (!isRegistered && H2_REGISTERED_CHARACTERS_ALLOWED > 0)
        h2_RegisterPC(oPC);

    if (H2_SAVE_PC_LOCATION)
    {
        int timerID = h2_CreateTimer(oPC, H2_SAVE_LOCATION, H2_SAVE_PC_LOCATION_TIMER_INTERVAL);
        h2_StartTimer(timerID);
    }
}

void h2_StripOnFirstLogin(object oPC)
{
    if (h2_GetPlayerPersistentInt(oPC, H2_STRIPPED) == FALSE)
    {
        h2_MovePossessorInventory(oPC, TRUE);
        h2_MoveEquippedItems(oPC);
        h2_SetPlayerPersistentInt(oPC, H2_STRIPPED, TRUE);
    }
}

int h2_MaximumPlayersReached()
{
    return (H2_MAXIMUM_PLAYERS > 0 && h2_GetModLocalInt(H2_PLAYER_COUNT) >= H2_MAXIMUM_PLAYERS);
}
//end client enter functions

//client leave functions
void h2_SavePersistentPCData(object oPC)
{
    int hp = GetCurrentHitPoints(oPC);
    string uniquePCID = h2_GetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID);
    h2_SetModLocalInt(uniquePCID + H2_PLAYER_HP, hp);
    h2_SavePCAvailableSpells(oPC);
    h2_SavePCAvailableFeats(oPC);
    string spelltrack = GetLocalString(oPC, H2_SPELL_TRACK);
    h2_SetModLocalString(uniquePCID + H2_SPELL_TRACK, spelltrack);
    string feattrack = GetLocalString(oPC, H2_FEAT_TRACK);
    h2_SetModLocalString(uniquePCID + H2_FEAT_TRACK, feattrack);
}
//end client leave functions

//player rest functions
int h2_GetAllowRest(object oPC)
{
    return GetLocalInt(oPC, H2_ALLOW_REST);
}

void h2_SetAllowRest(object oPC, int bAllowRest)
{
    SetLocalInt(oPC, H2_ALLOW_REST, bAllowRest);
}

int h2_GetAllowSpellRecovery(object oPC)
{
    return GetLocalInt(oPC, H2_ALLOW_SPELL_RECOVERY);
}

int h2_GetAllowFeatRecovery(object oPC)
{
    return GetLocalInt(oPC, H2_ALLOW_FEAT_RECOVERY);
}

void h2_SetAllowSpellRecovery(object oPC, int bAllowRecovery)
{
    SetLocalInt(oPC, H2_ALLOW_SPELL_RECOVERY, bAllowRecovery);
}

void h2_SetAllowFeatRecovery(object oPC, int bAllowRecovery)
{
    SetLocalInt(oPC, H2_ALLOW_FEAT_RECOVERY, bAllowRecovery);
}


int h2_GetPostRestHealAmount(object oPC)
{
    return GetLocalInt(oPC, H2_POST_REST_HEAL_AMT);
}

void h2_SetPostRestHealAmount(object oPC, int amount)
{
    SetLocalInt(oPC, H2_POST_REST_HEAL_AMT, amount);
}

void h2_OpenRestDialog(object oPC)
{
    SetLocalInt(oPC, H2_SKIP_CANCEL_REST, TRUE);
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionStartConversation(oPC, H2_PC_REST_DIALOG, TRUE, FALSE));
}

void h2_MakePCRest(object oPC)
{
    SetLocalInt(oPC, H2_SKIP_REST_DIALOG, TRUE);
    h2_SavePCHitPoints(oPC);
    h2_SavePCAvailableSpells(oPC);
    h2_SavePCAvailableFeats(oPC);
    DelayCommand(2.0, AssignCommand(oPC, ActionRest(TRUE)));
}

void h2_AddRestMenuItem(object oPC, string sMenuText, string sActionScript = H2_REST_MENU_DEFAULT_ACTION_SCRIPT)
{
    if (sMenuText == "")
        return;
    int index = GetLocalInt(oPC, H2_PLAYER_REST_MENU_INDEX) + 1;
    if (index <= 10)
    {
        SetLocalInt(oPC, H2_PLAYER_REST_MENU_INDEX, index);
        SetLocalString(oPC, H2_PLAYER_REST_MENU_ITEM_TEXT + IntToString(index), sMenuText);
        SetLocalString(oPC, H2_PLAYER_REST_MENU_ACTION_SCRIPT + IntToString(index), sActionScript);
    }
    else
        WriteTimestampedLogEntry("Rest Menu item: " + sMenuText + " exceeded maximum allowed.");
}

void h2_LimitPostRestHeal(object oPC, int postRestHealAmt)
{
    int savedHP = GetLocalInt(oPC, H2_PLAYER_HP);
    int currHP = GetCurrentHitPoints(oPC);
    if (savedHP + postRestHealAmt < currHP)
    {
        int nDam = currHP - (savedHP + postRestHealAmt);
        effect eDamage = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
    }
}
//end player rest functions
