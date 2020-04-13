/*
Filename:           h2_debug_i
System:             core (debugging include script)
Author:             Edward Beck (0100010)
Date Created:       Mar. 25, 2006
Summary:
HCR2 core function definitions for special debugging functions.
This file holds the commonly used  debugging functions, used throughout the core HCR2 system.
It is accessible from h2_locals_i, h2_timers_i and h2_core_i.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

//This function will prepend a message with "DebugInfo: " and write the given
//message to the log file, as well as send it to the DM channel and the given
//PC if one is specified.
//sMessage = debug message to write and/or send.
//oPC = player to receive the message, default value is OBJECT_INVALID.
void h2_DebugSpeak(string sMessage, object oPC = OBJECT_INVALID);

void h2_DebugSpeak(string sMessage, object oPC = OBJECT_INVALID)
{
    sMessage = "DebugSpeak: " + sMessage;
    WriteTimestampedLogEntry(sMessage);
    SendMessageToAllDMs(sMessage);
    SendMessageToPC(oPC, sMessage);
}
