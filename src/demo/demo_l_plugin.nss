// -----------------------------------------------------------------------------
//    File: demo_l_plugin.nss
//  System: Core Framework Demo (library script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This library script contains scripts to hook in to Core Framework events.
// -----------------------------------------------------------------------------

#include "util_i_color"
#include "util_i_library"
#include "core_i_framework"
#include "chat_i_main"

// -----------------------------------------------------------------------------
//                                  VerifyEvent
// -----------------------------------------------------------------------------
// This is a simple script that sends a message to the PC triggering an event.
// It can be used to verify that an event is firing as expected.
// -----------------------------------------------------------------------------

void VerifyEvent(object oPC)
{
    SendMessageToPC(oPC, GetCurrentEvent() + " fired!");
}

// -----------------------------------------------------------------------------
//                                  PrintColors
// -----------------------------------------------------------------------------
// Prints a list of color strings for the calling PC. Used to test util_i_color.
// -----------------------------------------------------------------------------

void PrintColor(object oPC, string sColor, int nColor)
{
    SendMessageToPC(oPC, HexColorString(sColor + ": " + IntToHexString(nColor), nColor));
}

void PrintHexColor(object oPC, int nColor)
{
    string sText = "The quick brown fox jumps over the lazy dog";
    string sMessage = IntToHexString(nColor) + ": " + sText;
    SendMessageToPC(oPC, HexColorString(sMessage, nColor));
}

void PrintColors(object oPC)
{
    PrintColor(oPC, "Black", COLOR_BLACK);
    PrintColor(oPC, "Blue", COLOR_BLUE);
    PrintColor(oPC, "Dark Blue", COLOR_BLUE_DARK);
    PrintColor(oPC, "Light Blue", COLOR_BLUE_LIGHT);
    PrintColor(oPC, "Brown", COLOR_BROWN);
    PrintColor(oPC, "Light Brown", COLOR_BROWN_LIGHT);
    PrintColor(oPC, "Divine", COLOR_DIVINE);
    PrintColor(oPC, "Gold", COLOR_GOLD);
    PrintColor(oPC, "Gray", COLOR_GRAY);
    PrintColor(oPC, "Dark Gray", COLOR_GRAY_DARK);
    PrintColor(oPC, "Light Gray", COLOR_GRAY_LIGHT);
    PrintColor(oPC, "Green", COLOR_GREEN);
    PrintColor(oPC, "Dark Green", COLOR_GREEN_DARK);
    PrintColor(oPC, "Light Green", COLOR_GREEN_LIGHT);
    PrintColor(oPC, "Orange", COLOR_ORANGE);
    PrintColor(oPC, "Dark Orange", COLOR_ORANGE_DARK);
    PrintColor(oPC, "Light Orange", COLOR_ORANGE_LIGHT);
    PrintColor(oPC, "Red", COLOR_RED);
    PrintColor(oPC, "Dark Red", COLOR_RED_DARK);
    PrintColor(oPC, "Light Red", COLOR_RED_LIGHT);
    PrintColor(oPC, "Pink", COLOR_PINK);
    PrintColor(oPC, "Purple", COLOR_PURPLE);
    PrintColor(oPC, "Turquoise", COLOR_TURQUOISE);
    PrintColor(oPC, "Violet", COLOR_VIOLET);
    PrintColor(oPC, "Light Violet", COLOR_VIOLET_LIGHT);
    PrintColor(oPC, "Dark Violet", COLOR_VIOLET_DARK);
    PrintColor(oPC, "White", COLOR_WHITE);
    PrintColor(oPC, "Yellow", COLOR_YELLOW);
    PrintColor(oPC, "Dark Yellow", COLOR_YELLOW_DARK);
    PrintColor(oPC, "Light Yellow", COLOR_YELLOW_LIGHT);

    PrintHexColor(oPC, 0x0099fe);
    PrintHexColor(oPC, 0x3dc93d);

    struct HSV hsv = HexToHSV(0xff0000);
    PrintHexColor(oPC, HSVToHex(hsv));
    SendMessageToPC(oPC, "H: " + FloatToString(hsv.h) +
                        " S: " + FloatToString(hsv.s) +
                        " V: " + FloatToString(hsv.v));
    hsv.v /= 2.0;
    hsv.s = 0.0;
    PrintHexColor(oPC, HSVToHex(hsv));
}

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    if (!GetIfPluginExists("core_demo"))
    {
        object oPlugin = CreatePlugin("core_demo");
        SetName(oPlugin, "[Plugin] Core Framework Demo");
        SetDescription(oPlugin,
            "This plugin provides some simple demos of the Core Framework.");

        RegisterEventScript(oPlugin, PLACEABLE_EVENT_ON_USED, "VerifyEvent");
        RegisterEventScript(oPlugin, "CHAT_!colors", "PrintColors");
    }

    // This plugin is created from a blueprint
    if (!GetIfPluginExists("bw_defaultevents"))
        CreatePlugin("bw_defaultevents");

    RegisterLibraryScript("VerifyEvent", 1);
    RegisterLibraryScript("PrintColors", 2);
}

void OnLibraryScript(string sScript, int nEntry)
{
    object oPC = GetEventTriggeredBy();
    switch (nEntry)
    {
        case 1: VerifyEvent(oPC); break;
        case 2: PrintColors(oPC); break;
        default:
            CriticalError("Library function " + sScript + " not found");
    }
}
