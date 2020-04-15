// -----------------------------------------------------------------------------
//    File: unid_l_plugin.nss
//  System: UnID Item on Drop (library)
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
#include "x_i_main"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    if (!GetIfPluginExists("pw_x"))
    {
        object oPlugin = GetPlugin("pw_x", TRUE);
        SetName(oPlugin, "[Plugin] Persistent World Plugin :: x System");
        SetDescription(oPlugin,
            "This plugin controls the HCR2 x Persistent World Subsystem.");

        // ----- Module Events -----
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_UNACQUIRE_ITEM, "UnID_OnUnacquireItem");
    }

    // ----- Module Events -----
    RegisterLibraryScript("UnID_OnUnacquireItem", 1);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  UnID_OnUnacquireItem(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
