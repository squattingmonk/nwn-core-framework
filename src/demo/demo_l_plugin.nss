// -----------------------------------------------------------------------------
//    File: demo_l_plugin.nss
//  System: Core Framework Demo (library script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This library script contains scripts to hook in to Core Framework events.
// -----------------------------------------------------------------------------

#include "util_i_library"
#include "core_i_framework"


// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    if (!GetIfPluginExists("core_demo"))
    {
        object oPlugin = GetPlugin("core_demo", TRUE);
        SetName(oPlugin, "[Plugin] Core Framework Demo");
        SetDescription(oPlugin,
            "This plugin provides some simple demos of the Core Framework.");

        RegisterEventScripts(oPlugin, AREA_EVENT_ON_ENTER,     "VerifyEvent");
        RegisterEventScripts(oPlugin, PLACEABLE_EVENT_ON_USED, "VerifyEvent");
    }

    RegisterLibraryScript("VerifyEvent");
}

void OnLibraryScript(string sScript, int nEntry)
{
    if (sScript == "VerifyEvent")
    {
        object oEvent = GetCurrentEvent();
        object oPC = GetEventTriggeredBy(oEvent);
        SendMessageToPC(oPC, GetName(oEvent) + " fired!");
    }
    else
        CriticalError("Library function " + sScript + " not found");
}
