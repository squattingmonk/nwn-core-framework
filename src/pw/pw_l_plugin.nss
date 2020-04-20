// -----------------------------------------------------------------------------
//    File: pw_l_plugin.nss
//  System: Persistent World Administration (library)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Library functions for PW Subsystem
// -----------------------------------------------------------------------------
// Builder Use:
//  None!  Leave me alone.
// -----------------------------------------------------------------------------
// Acknowledgment:
// -----------------------------------------------------------------------------
//  Revision:
//      Date:
//    Author:
//   Summary:
// -----------------------------------------------------------------------------

#include "util_i_library"
#include "core_i_framework"
#include "pw_i_events"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    //Need to check for pw plugin and this is a sub-plugin
    if (!GetIfPluginExists("pw"))
    {
        object oPlugin = GetPlugin("pw", TRUE);
        SetName(oPlugin, "[Plugin] HCR2 :: Core");
        SetDescription(oPlugin,
            "This plugin controls basic functions of the HCR2-base persistent world system.");

        // ----- Module Events -----
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER,     "pw_OnClientEnter",        4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_LEAVE,     "pw_OnClientLeave",        4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_HEARTBEAT,        "pw_OnModuleHeartbeat",    4.0);
        //RegisterEventScripts(oPlugin, MODULE_EVENT_ON_MODULE_LOAD,      "pw_OnModuleLoad",         4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DEATH,     "pw_OnPlayerDeath",        4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DYING,     "pw_OnPlayerDying",        4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_LEVEL_UP,  "pw_OnPlayerLevelUp",      4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_RESPAWN,   "pw_OnPlayerReSpawn",      4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST,      "pw_OnPlayerRest",         4.0);

        // ----- Local Events -----
        RegisterEventScripts(oPlugin, AREA_EVENT_ON_ENTER,              "pw_OnAreaEnter", 4.0);
        RegisterEventScripts(oPlugin, AREA_EVENT_ON_EXIT,               "pw_OnAreaExit", 4.0);
        RegisterEventScripts(oPlugin, PLACEABLE_EVENT_ON_HEARTBEAT,     "pw_OnPlaceableHeartbeat", 9.0);

        // ----- Timer Events -----
        RegisterEventScripts(oPlugin, H2_SAVE_LOCATION_ON_TIMER_EXPIRE, "pw_SavePCLocation_OnTimerExpire", 9.0);
        RegisterEventScripts(oPlugin, H2_EXPORT_CHAR_ON_TIMER_EXPIRE,   "pw_ExportPCs_OnTimerExpire", 9.0);
    }

    // ----- Module Events -----
    RegisterLibraryScript("pw_OnClientEnter",           1);
    RegisterLibraryScript("pw_OnClientLeave",           2);
    RegisterLibraryScript("pw_OnModuleHeartbeat",       3);
    RegisterLibraryScript("pw_OnModuleLoad",            4);
    RegisterLibraryScript("pw_OnPlayerDeath",           5);
    RegisterLibraryScript("pw_OnPlayerDying",           6);
    RegisterLibraryScript("pw_OnPlayerLevelUp",         7);
    RegisterLibraryScript("pw_OnPlayerReSpawn",         8);
    RegisterLibraryScript("pw_OnPlayerRest",            9);
    
    // ----- Local Events -----
    RegisterLibraryScript("pw_OnAreaEnter",             10);
    RegisterLibraryScript("pw_OnAreaExit",              11);
    RegisterLibraryScript("pw_OnPlaceableHeartbeat",    12);

    // ----- Tag-based Scripting -----
    RegisterLibraryScript(H2_PLAYER_DATA_ITEM,          13);

    // ----- Timer Events -----
    RegisterLibraryScript("pw_SavePCLocation_OnTimerExpire", 14);
    RegisterLibraryScript("pw_ExportPCs_OnTimerExpire", 15);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        // ----- Module Events -----
        case 1:   pw_OnClientEnter();          break;
        case 2:   pw_OnClientLeave();          break;
        case 3:   pw_OnModuleHeartbeat();      break;
        case 4:   pw_OnModuleLoad();           break;
        case 5:   pw_OnPlayerDeath();          break;

        case 6:   pw_OnPlayerDying();          break;
        case 7:   pw_OnPlayerLevelUp();        break;
        case 8:   pw_OnPlayerReSpawn();        break;
        case 9:   pw_OnPlayerRest();           break;
        
        // ----- Local Events -----
        case 10:  pw_OnAreaEnter();            break;
        case 11:  pw_OnAreaExit();             break;
        case 12:  pw_OnPlaceableHeartbeat();   break;
        
        // ----- Tag-based Scripting -----
        case 13:  pw_playerdataitem();         break;

        // ----- Timer Events -----
        case 14: pw_SavePCLocation_OnTimerExpire(); break;
        case 15: pw_ExportPCs_OnTimerExpire(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
