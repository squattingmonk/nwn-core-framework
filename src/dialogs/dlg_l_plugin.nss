// -----------------------------------------------------------------------------
//    File: dlg_l_plugin.nss
//  System: Dynamic Dialogs (library script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This library contains hook-in scripts for the Dynamic Dialogs plugin. If the
// Dynamic Dialogs plugin is activated, these scripts will fire on the
// appropriate events.
// -----------------------------------------------------------------------------

#include "core_i_framework"
#include "dlg_i_dialogs"
#include "util_i_color"
#include "util_i_library"

// -----------------------------------------------------------------------------
//                             Event Hook-In Scripts
// -----------------------------------------------------------------------------

// ----- WrapDialog ------------------------------------------------------------
// Starts a dialog between the calling object and the PC that triggered the
// event being executed. Only valid when being called by an event queue.
// ----- Variables -------------------------------------------------------------
// string "*Dialog":  The name of the dialog script (library or otherwise)
// int    "*Private": Whether the dialog should be hidden from other players.
// int    "*NoHello": Prevent the NPC from saying hello on dialog start
// int    "*NoZoom":  Prevent camera from zooming in on dialog start
// ----- Aliases ---------------------------------------------------------------

void WrapDialog(int bGhost = FALSE)
{
    // Get the PC that triggered the event. This information is pulled off the
    // event queue since we don't know which event is calling us.
    object oPC = GetEventTriggeredBy();

    if (!GetIsPC(oPC))
        return;

    string sDialog  = GetLocalString(OBJECT_SELF, DLG_DIALOG);
    int    bPrivate = GetLocalInt   (OBJECT_SELF, DLG_PRIVATE);
    int    bNoHello = GetLocalInt   (OBJECT_SELF, DLG_NO_HELLO);
    int    bNoZoom  = GetLocalInt   (OBJECT_SELF, DLG_NO_ZOOM);

    StartDialog(oPC, OBJECT_SELF, sDialog, bPrivate, bNoHello, bNoZoom);
}


// -----------------------------------------------------------------------------
//                             Plugin Control Dialog
// -----------------------------------------------------------------------------
// This dialog allows users to view and modify Core Framework Plugins.
// -----------------------------------------------------------------------------

const string PLUGIN_DIALOG      = "PluginControlDialog";
const string PLUGIN_PAGE        = "Plugin: ";
const string PLUGIN_PAGE_MAIN   = "Plugin List";
const string PLUGIN_PAGE_FAIL   = "Not Authorized";
const string PLUGIN_ACTIVATE    = "Activate Plugin";
const string PLUGIN_DEACTIVATE  = "Deactivate Plugin";

// Adds a dummy page for a plugin if it does not already exist
string AddPluginPage(string sPlugin)
{
    string sPage = PLUGIN_PAGE + sPlugin;
    if (!HasDialogPage(sPage))
    {
        AddDialogPage(sPage, "Plugin: <Plugin>\nStatus: <Status>\n\n<Description>", sPlugin);
        AddDialogNode(sPage, sPage, "Activate plugin",   PLUGIN_ACTIVATE);
        AddDialogNode(sPage, sPage, "Deactivate plugin", PLUGIN_DEACTIVATE);
        SetDialogTarget(PLUGIN_PAGE_MAIN, sPage, DLG_NODE_BACK);
    }

    return sPage;
}

string PluginStatusText(int nStatus)
{
    switch (nStatus)
    {
        case PLUGIN_STATUS_OFF:
            return HexColorString("[Inactive]", COLOR_GRAY);
        case PLUGIN_STATUS_ON:
            return HexColorString("[Active]", COLOR_GREEN);
        //case PLUGIN_STATUS_MISSING:
        //    return HexColorString("[Missing]", COLOR_RED);
    }

    return "";
}

void PluginControl_Init()
{
    EnableDialogNode(DLG_NODE_BACK);
    EnableDialogNode(DLG_NODE_END);

    AddDialogToken("Plugin");
    AddDialogToken("Status");
    AddDialogToken("Description");
    SetDialogPage(PLUGIN_PAGE_MAIN);
    AddDialogPage(PLUGIN_PAGE_MAIN,
        "This dialog allows you to manage the plugins in the Core Framework. " +
        "To manage a plugin, click its name below.\n\nThe following plugins " +
        "are installed:");
    SetDialogLabel(DLG_NODE_BACK, "[Refresh]", PLUGIN_PAGE_MAIN);

    string sPlugin, sPage;
    int i, nCount = CountStringList(PLUGINS);
    for (i; i < nCount; i++)
    {
        sPlugin = GetListString(PLUGINS, i);
        AddPluginPage(sPlugin);
    }

    AddDialogPage(PLUGIN_PAGE_FAIL, "Sorry, but only a DM can use this.");
    DisableDialogNode(DLG_NODE_BACK, PLUGIN_PAGE_FAIL);
}

void PluginControl_Page()
{
    object oPC = GetPCSpeaker();

    if (!GetIsDM(oPC))
    {
        SetDialogPage(PLUGIN_PAGE_FAIL);
        return;
    }

    string sPage = GetDialogPage();

    if (sPage == PLUGIN_PAGE_MAIN)
    {
        // Delete the old plugin list
        DeleteDialogNodes(PLUGIN_PAGE_MAIN);

        // Build the list of plugins
        object oPlugin;
        string sPlugin, sText, sTarget;
        int i, nStatus, nCount = CountObjectList(PLUGINS);

        for (i; i < nCount; i++)
        {
            oPlugin = GetListObject(PLUGINS, i);
            sPlugin = GetListString(PLUGINS, i);
            sTarget = AddPluginPage(sPlugin);
            nStatus = GetIsPluginActivated(oPlugin);
            sText = sPlugin + " " + PluginStatusText(nStatus);
            AddDialogNode(PLUGIN_PAGE_MAIN, sTarget, sText);
        }

        return;
    }

    // The page is for a plugin
    string sPlugin = GetDialogData(sPage);
    object oPlugin = GetPlugin(sPlugin);
    int nStatus = GetIsPluginActivated(oPlugin);
    switch (nStatus)
    {
        case PLUGIN_STATUS_OFF:
        case PLUGIN_STATUS_ON:
            FilterDialogNodes(!nStatus); break;
        default:
            FilterDialogNodes(0, CountDialogNodes(sPage) - 1);
    }

    CacheDialogToken("Plugin", sPlugin);
    CacheDialogToken("Status", PluginStatusText(nStatus));
    CacheDialogToken("Description", GetDescription(oPlugin));
}

void PluginControl_Node()
{
    string sPage = GetDialogPage();
    string sPrefix = GetStringLeft(sPage, GetStringLength(PLUGIN_PAGE));

    if (sPrefix == PLUGIN_PAGE)
    {
        int nNode = GetDialogNode();
        string sData = GetDialogData(sPage, nNode);
        string sPlugin = GetDialogData(sPage);
        object oPlugin = GetPlugin(sPlugin);

        if (sData == PLUGIN_ACTIVATE)
            ActivatePlugin(oPlugin);
        else if (sData == PLUGIN_DEACTIVATE)
            DeactivatePlugin(oPlugin);
    }
}

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    // Plugin setup
    if (!GetIfPluginExists("dlg"))
    {
        object oPlugin = GetPlugin("dlg", TRUE);
        SetName(oPlugin, "[Plugin] Dynamic Dialogs");
        SetDescription(oPlugin,
            "This plugin allows the creation and launching of script-driven dialogs.");
        SetPluginLibraries(oPlugin, "dlg_l_plugin, dlg_l_tokens, dlg_l_demo");
    }

    // Event scripts
    RegisterLibraryScript("StartDialog",        0x0100+0x01);
    RegisterLibraryScript("StartGhostDialog",   0x0100+0x02);

    // Plugin Control Dialog
    RegisterLibraryScript("PluginControl_Init", 0x0200+0x01);
    RegisterLibraryScript("PluginControl_Page", 0x0200+0x02);
    RegisterLibraryScript("PluginControl_Node", 0x0200+0x03);

    RegisterDialogScript(PLUGIN_DIALOG, "PluginControl_Init", DLG_EVENT_INIT, DLG_PRIORITY_FIRST);
    RegisterDialogScript(PLUGIN_DIALOG, "PluginControl_Page", DLG_EVENT_PAGE);
    RegisterDialogScript(PLUGIN_DIALOG, "PluginControl_Node", DLG_EVENT_NODE);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry & 0xff00)
    {
        case 0x0100:
            switch (nEntry & 0x00ff)
            {
                case 0x01: WrapDialog();          break;
                case 0x02: WrapDialog(TRUE);      break;
            }  break;

        case 0x0200:
            switch (nEntry & 0x00ff)
            {
                 case 0x01: PluginControl_Init(); break;
                 case 0x02: PluginControl_Page(); break;
                 case 0x03: PluginControl_Node(); break;
             }   break;
    }
}
