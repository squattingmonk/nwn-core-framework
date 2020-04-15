// -----------------------------------------------------------------------------
//    File: pw_l_plugin.nss
//  System: Persistent World Administration (library script)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Persistent world text constants.  This script contains user-definable text
//  constants that are used in-game for the base persistent world (pw)
//  administration system.
//
// This constants can be translated to other languages and still be used in the
//  base pw system.  If translated, save this script with a different name and
//  reference the new script as an include in pw_i_core.nss.
//  ---> Replace [#include pw_i_text] with [#include <your script name>]
// -----------------------------------------------------------------------------
// Acknowledgment:
// This script is a copy of Edward Becks HCR2 script h2_core_t modified and renamed
//  to work under Michael Sinclair's (Squatting Monk) core-framework system and
//  for use in the Dark Sun Persistent World.
// -----------------------------------------------------------------------------
// Revisions:
// -----------------------------------------------------------------------------

#include "util_i_library"
#include "core_i_framework"
#include "pw_i_items"
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
        SetName(oPlugin, "[Plugin] Persistent World Plugin :: Core System");
        SetDescription(oPlugin,
            "This plugin controls basic functions of the HCR2-base persistent world system.");

        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_MODULE_LOAD, "pw_OnModuleLoad");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_HEARTBEAT, "pw_OnModuleHeartbeat");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER, "pw_OnClientEnter");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_LEAVE, "pw_OnClientLeave");
        RegisterEventScripts(oPlugin, AREA_EVENT_ON_ENTER, "pw_OnAreaEnter");
        RegisterEventScripts(oPlugin, AREA_EVENT_ON_EXIT, "pw_OnAreaExit");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DYING, "pw_OnPlayerDying");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DEATH, "pw_OnPlayerDeath");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_RESPAWN, "pw_OnPlayerReSpawn");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_LEVEL_UP, "pw_OnPlayerLevelUp");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST, "pw_OnPlayerRest");
        RegisterEventScripts(oPlugin, PLACEABLE_EVENT_ON_HEARTBEAT, "pw_OnPlaceableHeartbeat");
    }

    RegisterLibraryScript("pw_OnModuleLoad", 1);
    RegisterLibraryScript("pw_OnModuleHeartbeat", 2);
    RegisterLibraryScript("pw_OnClientEnter", 3);
    RegisterLibraryScript("pw_OnClientLeave", 4);
    RegisterLibraryScript("pw_OnAreaEnter", 5);
    RegisterLibraryScript("pw_OnAreaExit", 6);
    RegisterLibraryScript("pw_OnPlayerDying", 7);
    RegisterLibraryScript("pw_OnPlayerDeath", 8);
    RegisterLibraryScript("pw_OnPlayerReSpawn", 9);
    RegisterLibraryScript("pw_OnPlayerLevelUp", 10);
    RegisterLibraryScript("pw_OnPlayerRest", 11);
    RegisterLibraryScript("pw_OnPlaceableHeartbeat", 12);
    
    //Tag-based scripting
    RegisterLibraryScript(H2_PLAYER_DATA_ITEM), 13);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  pw_OnModuleLoad(); break;
        case 2:  pw_OnModuleHeartbeat(); break;
        case 3:  pw_OnClientEnter(); break;
        case 4:  pw_OnClientLeave(); break;
        case 5:  pw_OnAreaEnter(); break;
        case 6:  pw_OnAreaExit(); break;
        case 7:  pw_OnPlayerDying(); break;
        case 8:  pw_OnPlayerDeath(); break;
        case 9:  pw_OnPlayerReSpawn(); break;
        case 10:  pw_OnPlayerLevelUp(); break;
        case 11:  pw_OnPlayerRest(); break;
        case 12:  pw_OnPlaceableHeartbeat(); break;
        case 13:  pw_playerdataitem();    break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
