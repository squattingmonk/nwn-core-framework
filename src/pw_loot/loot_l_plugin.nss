// -----------------------------------------------------------------------------
//    File: loot_l_plugin.nss
//  System: PC Corpse Loot (library)
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
#include "loot_i_events"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    //Need to check for pw plugin and this is a sub-plugin
    if (!GetIfPluginExists("pw_loot"))
    {
        object oPlugin = GetPlugin("pw_loot", TRUE);
        SetName(oPlugin, "[Plugin] Persistent World Plugin :: Corpse Loot System");
        SetDescription(oPlugin,
            "This plugin controls the Corpse Loot Persistent World Subsystem.");

        // ----- Module Events -----
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DYING, "loot_OnPlayerDying");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DEATH, "loot_OnPlayerDeath");
    }

    // ----- Module Events -----
    RegisterLibraryScript("loot_OnPlayerDying", 1);
    RegisterLibraryScript("loot_OnPlayerDeath", 2);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  loot_OnPlayerDying(); break;
        case 2:  loot_OnPlayerDeath(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
