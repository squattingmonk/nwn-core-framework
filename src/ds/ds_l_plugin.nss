// -----------------------------------------------------------------------------
//    File: ds_l_plugin.nss
//  System: UnID Item on Drop Persistent World Subsystem (library)
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
#include "ds_i_main"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    //Need to check for pw plugin and this is a sub-plugin
    if (!GetIfPluginExists("ds"))
    {
        object oPlugin = GetPlugin("ds", TRUE);
        SetName(oPlugin, "[Plugin] Dark Sun System :: Primary");
        SetDescription(oPlugin,
            "This plugin controls the UnID Item on Drop Persistent World Subsystem.");

        //Add module level events
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER, "ds_OnClientEnter");
    }

    RegisterLibraryScript("ds_OnClientEnter", 1);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  ds_OnClientEnter(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
