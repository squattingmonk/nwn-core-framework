// -----------------------------------------------------------------------------
//    File: corpse_l_plugin.nss
//  System: PC Corpse (library)
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
#include "corpse_i_const"
#include "corpse_i_events"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    //Need to check for pw plugin and this is a sub-plugin
    if (!GetIfPluginExists("pw_corpse"))
    {
        object oPlugin = GetPlugin("pw_corpse", TRUE);
        SetName(oPlugin, "[Plugin] Persistent World Plugin :: PC Corpse System");
        SetDescription(oPlugin,
            "This plugin controls the PC Corpse Persistent World Subsystem.");

        // --- Module Events ---
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER,        "corpse_OnClientEnter");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_LEAVE,        "corpse_OnClientLeave");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DEATH,        "corpse_OnPlayerDeath");
    }

    // --- Module Events ---
    RegisterLibraryScript("corpse_OnClientEnter",       1);
    RegisterLibraryScript("corpse_OnClientLeave",       2);
    RegisterLibraryScript("corpse_OnPlayerDeath",       3);
    
    // --- Tag-based Scripting ---
    RegisterLibraryScript(H2_PC_CORPSE_ITEM),           4);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  corpse_OnClientEnter();       break;
        case 2:  corpse_OnClientLeave();       break;
        case 3:  corpse_OnPlayerDeath();       break;
        case 4:  corpse_pccorposeitem();       break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
