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
        SetName(oPlugin, "[Plugin] HCR2 Plugin :: Torch and Lantern Subsystem");
        SetDescription(oPlugin,
            "This plugin controls the HCR2 Torch and Lantern Subsystem.");

        // ----- Module Events -----
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_SPELLHOOK,   "torch_OnSpellHook",   4.0);

        // ----- Timer Events -----
        RegisterEventScripts(oPlugin, TORCH_EVENT_ON_TIMER_EXPIRE, "torch_OnTimerExpire", 4.0);
    }

    // ----- Module Events -----
    RegisterLibraryScript("torch_OnSpellHook",   1);

    // ----- Tag-based Scripting -----
    RegisterLibraryScript(H2_LANTERN,            2);
    RegisterLibraryScript(H2_OILFLASK,           3);

    // ----- Timer Events -----
    RegisterLibraryScript("torch_OnTimerExpire", 4);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        // ----- Module Events -----
        case 1: torch_OnSpellHook();   break;

        // ----- Tag-based Scripting -----
        case 2: torch_lantern();       break;
        case 3: torch_oilflask();      break;

        // ----- Timer Events -----
        case 4: torch_OnTimerExpire(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
