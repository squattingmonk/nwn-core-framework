/*
Filename:           h2_fatigueoce
System:             fatigue (client enter event hook-in script)
Author:             Edward Beck (0100010)
Date Created:       Sept. 11th, 2006
Summary:

This script should be called via ExecuteScript from the
RunModuleEventScripts(H2_EVENT_ON_CLIENT_ENTER, oPC) function that is called from h2_cliententer_e.

To make this script execute, a string variable, named OnClientEnter#,
where # is a number that indicates the order in which you want this client enter script to execute,
should be assigned the value "h2_fatigueoce" under the variables section of Module properties.

Variables available to all event hook client enter scripts

GetLocalString(GetEnteringObject(), H2_PC_PLAYER_NAME) : provides the entering PC's player name.
GetLocalString(GetEnteringObject(), H2_PC_CD_KEY) : provides the entering PC's CD key.
h2_GetPlayerPersistentString(GetEnteringObject(), H2_UNIQUE_PC_ID) : provides the 10 character unique Hex string
used to uniquely identify this PC.

The primary reason for having these is so that they are also available in the client leave
event scripts.

You should not overwrite the above variables, or they will not remain consistant
for any other executing client enter script which might rely on them. (as well as any client leave scripts)

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:   10/21/2006
Revision Author: 0100010
Revision Summary: v1.4
Added check to prevent fatigue timer from being attached to DMs.

*/

#include "h2_fatigue_i"

void main()
{
    object oPC = GetEnteringObject();
    if (!GetIsDM(oPC))
        h2_InitFatigueCheck(oPC);
}
