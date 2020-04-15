// -----------------------------------------------------------------------------
//    File: bleed_l_plugin.nss
//  System: Bleed Persistent World Subsystem (library)
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
// This script is a copy of Edward Becks HCR2 script h2_core_i modified and renamed
//  to work under Michael Sinclair's (Squatting Monk) core-framework system and
//  for use in the Dark Sun Persistent World.  Some of the HCR2 pw functions
//  have been removed because they are duplicates from the core-framework or no
//  no longer applicable to the pw system within the core-framework.
// -----------------------------------------------------------------------------
// Revisions:
// -----------------------------------------------------------------------------

#include "util_i_library"
#include "core_i_framework"
#include "corpse_i_main"
#include "corpse_i_items"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    //Need to check for pw plugin and this is a sub-plugin
    if (!GetIfPluginExists("pw_corpse"))
    {
        object oPlugin = GetPlugin("pw_corpse", TRUE);
        SetName(oPlugin, "[Plugin] Persistent World Plugin :: Corpse System");
        SetDescription(oPlugin,
            "This plugin controls the Bleed Persistent World Subsystem.");

        //Add module level events
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER,        "corpse_OnClientEnter");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_LEAVE,        "corpse_OnClientLeave");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DEATH,        "corpse_OnPlayerDeath");
    }

    RegisterLibraryScript("corpse_OnClientEnter",       1);
    RegisterLibraryScript("corpse_OnClientLeave",       2);
    RegisterLibraryScript("corpse_OnPlayerDeath",       3);
    
    //Tag-based scripting scripts
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
