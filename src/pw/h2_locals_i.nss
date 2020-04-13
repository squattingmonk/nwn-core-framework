/*
Filename:           h2_locals_i
System:             core (special get/set locals include script)
Author:             Edward Beck (0100010)
Date Created:       Mar. 25, 2006
Summary:
HCR2 core function definitions for special types of variable setting and getting.
This file holds the commonly used  special variable set, get and delete functions,
used throughout the core HCR2 system.

this script is accesible from h2_timers_i, h2_core_i.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_debug_i"
#include "h2_constants_i"

//Gets a local variable of the given type named sVarName onto to a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
int h2_GetModLocalInt(string sVarName);

//Sets a local variable of the given type named sVarName with the given value onto to a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
void h2_SetModLocalInt(string sVarName, int value);

//Deletes a local variable of the given type named sVarName from a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
void h2_DeleteModLocalInt(string sVarName);

//Gets a local variable of the given type named sVarName onto to a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
string h2_GetModLocalString(string sVarName);

//Sets a local variable of the given type named sVarName with the given value onto to a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
void h2_SetModLocalString(string sVarName, string value);

//Deletes a local variable of the given type named sVarName from a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
void h2_DeleteModLocalString(string sVarName);

//Gets a local variable of the given type named sVarName onto to a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
float h2_GetModLocalFloat(string sVarName);

//Sets a local variable of the given type named sVarName with the given value onto to a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
void h2_SetModLocalFloat(string sVarName, float value);

//Deletes a local variable of the given type named sVarName from a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
void h2_DeleteModLocalFloat(string sVarName);

//Gets a local variable of the given type named sVarName onto to a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
object h2_GetModLocalObject(string sVarName);

//Sets a local variable of the given type named sVarName with the given value onto to a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
void h2_SetModLocalObject(string sVarName, object value);

//Deletes a local variable of the given type named sVarName from a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
void h2_DeleteModLocalObject(string sVarName);

//Gets a local variable of the given type named sVarName onto to a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
location h2_GetModLocalLocation(string sVarName);

//Sets a local variable of the given type named sVarName with the given value onto to a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
void h2_SetModLocalLocation(string sVarName, location value);

//Deletes a local variable of the given type named sVarName from a
//specific placeable object with the tag H2_CORE_DATA_POINT.
//The reason for this is to avoid the performance issue that can occur
//when setting and getting locals on the extrememly overused GetModule() object.
//This function is primarily for internal h2_core use.
void h2_DeleteModLocalLocation(string sVarName);

//Gets a variable of the given type named varname from the non-droppable data item object
//located in oPC's inventory. These values persist across resets if the module is using
//server vault characters. Use for player character specific values with server vaults
//that do not need to go into the external database.
int h2_GetPlayerPersistentInt(object oPC, string varname);

//Sets a variable of the given type named varname with the given value on the non-droppable data item object
//located in oPC's inventory. These values persist across resets if the module is using
//server vault characters. Use for player character specific values with server vaults
//that do not need to go into the external database.
void h2_SetPlayerPersistentInt(object oPC, string varname, int value);

//Gets a variable of the given type named varname from the non-droppable data item object
//located in oPC's inventory. These values persist across resets if the module is using
//server vault characters. Use for player character specific values with server vaults
//that do not need to go into the external database.
float h2_GetPlayerPersistentFloat(object oPC, string varname);

//Sets a variable of the given type named varname with the given value on the non-droppable data item object
//located in oPC's inventory. These values persist across resets if the module is using
//server vault characters. Use for player character specific values with server vaults
//that do not need to go into the external database.
void h2_SetPlayerPersistentFloat(object oPC, string varname, float value);

//Gets a variable of the given type named varname from the non-droppable data item object
//located in oPC's inventory. These values persist across resets if the module is using
//server vault characters. Use for player character specific values with server vaults
//that do not need to go into the external database.
object h2_GetPlayerPersistentObject(object oPC, string varname);

//Sets a variable of the given type named varname with the given value on the non-droppable data item object
//located in oPC's inventory. These values persist across resets if the module is using
//server vault characters. Use for player character specific values with server vaults
//that do not need to go into the external database. Note that local variables on the stored object
//will not save.
void h2_SetPlayerPersistentObject(object oPC, string varname, object value);

//Gets a variable of the given type named varname from the non-droppable data item object
//located in oPC's inventory. These values persist across resets if the module is using
//server vault characters. Use for player character specific values with server vaults
//that do not need to go into the external database.
string h2_GetPlayerPersistentString(object oPC, string varname);

//Sets a variable of the given type named varname with the given value on the non-droppable data item object
//located in oPC's inventory. These values persist across resets if the module is using
//server vault characters. Use for player character specific values with server vaults
//that do not need to go into the external database.
void h2_SetPlayerPersistentString(object oPC, string varname, string value);

//Gets a variable of the given type named varname from the non-droppable data item object
//located in oPC's inventory. These values persist across resets if the module is using
//server vault characters. Use for player character specific values with server vaults
//that do not need to go into the external database.
location h2_GetPlayerPersistentLocation(object oPC, string varname);

//Gets a variable of the given type named varname from the non-droppable data item object
//located in oPC's inventory. These values persist across resets if the module is using
//server vault characters. Use for player character specific values with server vaults
//that do not need to go into the external database.
void h2_SetPlayerPersistentLocation(object oPC, string varname, location value);

int h2_GetModLocalInt(string sVarName)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    return GetLocalInt(oModuleLocalStorage, sVarName);
}

void h2_SetModLocalInt(string sVarName, int value)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    SetLocalInt(oModuleLocalStorage, sVarName, value);
}

void h2_DeleteModLocalInt(string sVarName)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    DeleteLocalInt(oModuleLocalStorage, sVarName);
}

string h2_GetModLocalString(string sVarName)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    return GetLocalString(oModuleLocalStorage, sVarName);
}

void h2_SetModLocalString(string sVarName, string value)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    SetLocalString(oModuleLocalStorage, sVarName, value);
}

void h2_DeleteModLocalString(string sVarName)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    DeleteLocalString(oModuleLocalStorage, sVarName);
}

float h2_GetModLocalFloat(string sVarName)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    return GetLocalFloat(oModuleLocalStorage, sVarName);
}

void h2_SetModLocalFloat(string sVarName, float value)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    SetLocalFloat(oModuleLocalStorage, sVarName, value);
}

void h2_DeleteModLocalFloat(string sVarName)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    DeleteLocalFloat(oModuleLocalStorage, sVarName);
}

object h2_GetModLocalObject(string sVarName)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    return GetLocalObject(oModuleLocalStorage, sVarName);
}

void h2_SetModLocalObject(string sVarName, object value)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    SetLocalObject(oModuleLocalStorage, sVarName, value);
}

void h2_DeleteModLocalObject(string sVarName)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    DeleteLocalObject(oModuleLocalStorage, sVarName);
}

location h2_GetModLocalLocation(string sVarName)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    return GetLocalLocation(oModuleLocalStorage, sVarName);
}

void h2_SetModLocalLocation(string sVarName, location value)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    SetLocalLocation(oModuleLocalStorage, sVarName, value);
}

void h2_DeleteModLocalLocation(string sVarName)
{
    object oModuleLocalStorage = GetWaypointByTag(H2_CORE_DATA_POINT);
    DeleteLocalLocation(oModuleLocalStorage, sVarName);
}

int h2_GetPlayerPersistentInt(object oPC, string varname)
{
    object oData = GetItemPossessedBy(oPC, H2_PLAYER_DATA_ITEM);
    if (GetIsObjectValid(oData))
        return GetLocalInt(oData, varname);
    return 0;
}

void h2_SetPlayerPersistentInt(object oPC, string varname, int value)
{
    object oData = GetItemPossessedBy(oPC, H2_PLAYER_DATA_ITEM);
    if (GetIsObjectValid(oData))
        SetLocalInt(oData, varname, value);
}

float h2_GetPlayerPersistentFloat(object oPC, string varname)
{
    object oData = GetItemPossessedBy(oPC, H2_PLAYER_DATA_ITEM);
    if (GetIsObjectValid(oData))
        return GetLocalFloat(oData, varname);
    return 0.0;
}

void h2_SetPlayerPersistentFloat(object oPC, string varname, float value)
{
    object oData = GetItemPossessedBy(oPC, H2_PLAYER_DATA_ITEM);
    if (GetIsObjectValid(oData))
        SetLocalFloat(oData, varname, value);
}

object h2_GetPlayerPersistentObject(object oPC, string varname)
{
    object oData = GetItemPossessedBy(oPC, H2_PLAYER_DATA_ITEM);
    if (GetIsObjectValid(oData))
        return GetLocalObject(oData, varname);
    return OBJECT_INVALID;
}

void h2_SetPlayerPersistentObject(object oPC, string varname, object value)
{
    object oData = GetItemPossessedBy(oPC, H2_PLAYER_DATA_ITEM);
    if (GetIsObjectValid(oData))
        SetLocalObject(oData, varname, value);
}

string h2_GetPlayerPersistentString(object oPC, string varname)
{
    object oData = GetItemPossessedBy(oPC, H2_PLAYER_DATA_ITEM);
    if (GetIsObjectValid(oData))
        return GetLocalString(oData, varname);
    return "";
}

void h2_SetPlayerPersistentString(object oPC, string varname, string value)
{
    object oData = GetItemPossessedBy(oPC, H2_PLAYER_DATA_ITEM);
    if (GetIsObjectValid(oData))
        SetLocalString(oData, varname, value);
}

location h2_GetPlayerPersistentLocation(object oPC, string varname)
{
    object oData = GetItemPossessedBy(oPC, H2_PLAYER_DATA_ITEM);
    if (GetIsObjectValid(oData))
        return GetLocalLocation(oData, varname);
    return Location(OBJECT_INVALID, Vector(-1.0,-1.0,-1.0), 0.0);
}

void h2_SetPlayerPersistentLocation(object oPC, string varname, location value)
{
    object oData = GetItemPossessedBy(oPC, H2_PLAYER_DATA_ITEM);
    if (GetIsObjectValid(oData))
        SetLocalLocation(oData, varname, value);
}
