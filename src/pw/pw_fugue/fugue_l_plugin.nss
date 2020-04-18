// -----------------------------------------------------------------------------
//    File: fugue_l_plugin.nss
//  System: Fugue Death and Resurrection System (library script)
//     URL: 
// Authors: Edward A. Burke (tinygiant) (af.hog.pilot@gmail.com)
// -----------------------------------------------------------------------------
// This library script contains scripts to hook in to Core Framework events.
// -----------------------------------------------------------------------------

#include "util_i_library"
#include "core_i_framework"
#include "fugue_i_events"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    //Need to check for pw plugin and this is a sub-plugin
    if (!GetIfPluginExists("pw_fugue"))
    {
        object oPlugin = GetPlugin("pw_fugue", TRUE);
        SetName(oPlugin, "[Plugin] HCR2 Plugin :: Fugue Death and Resurrection Subsystem");
        SetDescription(oPlugin,
            "This plugin controls the HCR 2 Fugue Death and Resurrection subsytem.");

        // ----- Module Events -----      
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER, "fugue_OnClientEnter", 4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DEATH, "fugue_OnPlayerDeath", 3.9);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DYING, "fugue_OnPlayerDying", 4.0);
    }

    // ----- Module Events -----
    RegisterLibraryScript("fugue_OnClientEnter", 1);
    RegisterLibraryScript("fugue_OnPlayerDeath", 2);
    RegisterLibraryScript("fugue_OnPlayerDying", 3);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        // ----- Module Events -----
        case 1:  fugue_OnClientEnter(); break;
        case 2:  fugue_OnPlayerDeath(); break;
        case 3:  fugue_OnPlayerDying(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
