// -----------------------------------------------------------------------------
//    File: core_i_plugins.nss
//  System: Core Framework (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file holds functions for managing plugins, objects that contain lists of
// scripts hooks for particular systems.
// -----------------------------------------------------------------------------

#include "util_i_csvlists"
#include "util_i_varlists"
#include "util_i_libraries"
#include "core_i_constants"
#include "core_c_config"

// -----------------------------------------------------------------------------
//                               Global Variables
// -----------------------------------------------------------------------------

// The currently executing plugin.
object PLUGIN_CURRENT = GetLocalObject(PLUGINS, PLUGIN_LAST);


// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< LoadPlugin >---
// ---< core_i_plugins >---
// Creates and returns a data object for the plugin with ID sPlugin. If the
// plugin was not already loaded, loads a library named sPlugin, runs the
// plugin's OnPluginActivate scripts, and sets its status to ON.
//
// Note: while plugin setup can be done in the OnLibraryLoad() routine of the
// library sPlugin, you can also create a plugin blueprint with the resref
// "PLUG_" + sPlugin.
object LoadPlugin(string sPlugin);

// ---< LoadPlugins >---
// ---< core_i_plugins >---
// Creates a data object for each plugin in the CSV list sPlugins. If the plugin
// was not already loaded, loads a library with the same name as the plugin,
// runs the plugin's OnPluginActivate scripts, and sets its status to ON.
void LoadPlugins(string sPlugins);

// ---< ActivatePlugin >---
// ---< core_i_plugins >---
// Activates oPlugin if its status is not already ON. Runs the OnPluginActivate
// script and sets the status to ON. If bForce is TRUE, will activate the plugin
// even if its status is already ON.
void ActivatePlugin(object oPlugin, int bForce = FALSE);

// ---< DeactivatePlugin >---
// ---< core_i_plugins >---
// Deactivates oPlugin if its status is not already OFF. Runs the
// OnPluginDeactivate script and sets the status to OFF. If bForce is TRUE, will
// deactivate the plugin even if its status is already OFF.
void DeactivatePlugin(object oPlugin, int bForce = FALSE);

// ---< GetPlugin >---
// ---< core_i_plugins >---
// Returns the plugin object associated with sPluginID.
object GetPlugin(string sPluginID);

// ---< GetIsPluginActivated >---
// ---< core_i_plugins >---
// Return whether the plugin associated with sPluginID has been activated.
int GetIsPluginActivated(string sPluginID);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

object LoadPlugin(string sPlugin)
{
    if (sPlugin == "")
        return OBJECT_INVALID;

    DebugSystem(DEBUG_SYSTEM_CORE, "Loading plugin " + sPlugin);
    object oPlugin = GetLocalObject(PLUGINS, sPlugin);

    if (!GetIsObjectValid(oPlugin))
    {
        // It's possible the builder has pre-created a plugin object with all
        // the necessary variables on it. Try to create it. If it's not valid,
        // we can generate one from scratch.
        oPlugin = CreateItemOnObject(PLUGIN_PREFIX + sPlugin, PLUGINS, 1, sPlugin);
        if (!GetIsObjectValid(oPlugin))
            oPlugin = CreateItemOnObject(PLUGIN, PLUGINS, 1, sPlugin);

        // Make the Core aware of this plugin
        SetLocalObject(PLUGINS, sPlugin, oPlugin);
        AddListString (PLUGINS, sPlugin);
        AddListObject (PLUGINS, oPlugin);

        // Run activation routines
        SetLocalString(PLUGINS, PLUGIN_LAST, sPlugin);
        SetLocalObject(PLUGINS, PLUGIN_LAST, oPlugin);
        LoadLibrary(sPlugin);
        ActivatePlugin(oPlugin);

        // Clean up
        DeleteLocalString(PLUGINS, PLUGIN_LAST);
        DeleteLocalObject(PLUGINS, PLUGIN_LAST);
    }

    return oPlugin;
}

void LoadPlugins(string sPlugins)
{
    string sPlugin;
    int i, nCount = CountList(sPlugins);
    for (i = 0; i < nCount; i++)
    {
        sPlugin = GetListItem(sPlugins, i);
        LoadPlugin(sPlugin);
    }
}

void ActivatePlugin(object oPlugin, int bForce = FALSE)
{
    if (!GetIsObjectValid(oPlugin))
        return;

    string sPlugin = GetLocalString(oPlugin, PLUGIN_ID);
    if (bForce || !GetLocalInt(oPlugin, PLUGIN_STATUS))
    {
        string sScripts = GetLocalString(oPlugin, CORE_EVENT_ON_PLUGIN_ACTIVATE);
        RunLibraryScripts(sScripts, oPlugin);
        SetLocalInt(oPlugin, PLUGIN_STATUS, PLUGIN_STATUS_ON);
    }
    else
    {
        Debug("Plugin " + sPlugin + " is already activated!",
                DEBUG_LEVEL_WARNING, DEBUG_SYSTEM_CORE);
    }
}

void DeactivatePlugin(object oPlugin, int bForce = FALSE)
{
    if (!GetIsObjectValid(oPlugin))
        return;

    string sPlugin = GetLocalString(oPlugin, PLUGIN_ID);
    if (bForce || GetLocalInt(oPlugin, PLUGIN_STATUS))
    {
        string sScripts = GetLocalString(oPlugin, CORE_EVENT_ON_PLUGIN_DEACTIVATE);
        RunLibraryScripts(sScripts, oPlugin);
        SetLocalInt(oPlugin, PLUGIN_STATUS, PLUGIN_STATUS_OFF);
    }
    else
    {
        Debug("Plugin " + sPlugin + " is already deactivated!",
                DEBUG_LEVEL_WARNING, DEBUG_SYSTEM_CORE);
    }
}

object GetPlugin(string sPlugin)
{
    return GetLocalObject(PLUGINS, sPlugin);
}

int GetIsPluginActivated(string sPlugin)
{
    object oPlugin = GetPlugin(sPlugin);
    return GetLocalInt(oPlugin, PLUGIN_STATUS);
}

object GetCurrentPlugin()
{
    return PLUGIN_CURRENT;
}
