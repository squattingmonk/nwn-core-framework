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
#include "fugue_i_main"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    //Need to check for pw plugin and this is a sub-plugin
    if (!GetIfPluginExists("pw_fugue"))
    {
        object oPlugin = GetPlugin("pw_fugue", TRUE);
        SetName(oPlugin, "[Plugin] Persistent World Plugin :: Fugue Subsystem");
        SetDescription(oPlugin,
            "This plugin controls the fugue system of player death and resurrection.");

        //Add a local event for exiting the fugue plane.
        object oFuguePlane = GetObjectByTag(H2_FUGUE_PLANE);
        object oFugueScripts = GetObjectByTag(H2_WP_FUGUE);
        AddScriptSource(oFuguePlane, oFugueScripts);

        RegisterEventScripts(oFuguePlane, AREA_EVENT_ON_EXIT, "fugue_OnPlayerExit");
        RegisterEventScripts(oFuguePlane, AREA_EVENT_ON_ENTER, "fugue_OnPlayerEnter");
        
        //Add module level events for the fugue system
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER, "fugue_OnClientEnter");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DEATH, "fugue_OnPlayerDeath", EVENT_PRIORITY_ONLY);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DYING, "fugue_OnPlayerDying");
    }

    RegisterLibraryScript("fugue_OnClientEnter", 1);
    RegisterLibraryScript("fugue_OnPlayerDeath", 2);
    RegisterLibraryScript("fugue_OnPlayerDying", 3);
    RegisterLibraryScript("fugue_OnPlayerExit",  4);
    RegisterLibraryScript("fugue_OnPlayerEnter", 5);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  fugue_OnClientEnter(); break;
        case 2:  fugue_OnPlayerDeath(); break;
        case 3:  fugue_OnPlayerDying(); break;
        case 4:  fugue_OnPlayerExit();  break;
        case 5:  fugue_OnPlayerEnter(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
