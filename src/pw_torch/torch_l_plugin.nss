// -----------------------------------------------------------------------------
//    File: torch_l_plugin.nss
//  System: Torch and Lantern (library)
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
#include "torch_i_events"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    if (!GetIfPluginExists("pw_torch"))
    {
        object oPlugin = GetPlugin("pw_torch", TRUE);
        SetName(oPlugin, "[Plugin] Persistent World Plugin :: Torch and Lantern System");
        SetDescription(oPlugin,
            "This plugin controls the HCR2 Torch and Lantern Persistent World Subsystem.");

        // ----- Module Events -----
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_SPELLHOOK, "torch_OnSpellHook");
    }

    // ----- Module Events -----
    RegisterLibraryScript("torch_OnSpellHook", 1);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  torch_OnSpellHook(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
