// -----------------------------------------------------------------------------
//    File: util_i_libraries.nss
//  System: Utilities (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file holds functions for packaging scripts into libraries. This allows
// the builder to dramatically reduce the module script count by keeping related
// scripts in the same file.
// -----------------------------------------------------------------------------
// Acknowledgement: these scripts have been adapted from Memetic AI.
// -----------------------------------------------------------------------------

// Debug utility functions
#include "util_i_debug"

// CSV List utility functions
#include "util_i_csvlists"

// Datapoint utilities
#include "util_i_datapoint"

// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

const string LIB_ENTRY        = "LIB_ENTRY";
const string LIB_LOADED       = "LIB_LOADED";
const string LIB_RETURN       = "LIB_RETURN";
const string LIB_SCRIPT       = "LIB_SCRIPT";
const string LIB_LAST_ENTRY   = "LIB_LAST_ENTRY";
const string LIB_LAST_LIBRARY = "LIB_LAST_LIBRARY";
const string LIB_LAST_SCRIPT  = "LIBRARY_LAST_SCRIPT";

// -----------------------------------------------------------------------------
//                               Global Variables
// -----------------------------------------------------------------------------

object LIBRARIES = GetDatapoint("LIBRARIES");

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< GetIsLibraryLoaded >---
// ---< util_i_libraries >---
// Returns whether sLibrary has been loaded.
int GetIsLibraryLoaded(string sLibrary);

// ---< LoadLibrary >---
// ---< util_i_libraries >---
// Loads library sLibrary. The scripts inside the library are registered and are
// accessible via a call to RunLibraryScript(). If the library has already been
// loaded, this will not reload it unless bForce is TRUE.
void LoadLibrary(string sLibrary, int bForce = FALSE);

// ---< LoadLibraries >---
// ---< util_i_libraries >---
// Loads all libraries in the CSV list sLibraries. The scripts inside the
// library are registered and are accessible via a call to RunLibraryScript().
// If any of the libraries have already been loaded, this will not reload them
// unless bForce is TRUE.
void LoadLibraries(string sLibraries, int bForce = FALSE);

// ---< RunLibraryScript >---
// ---< util_i_libraries >---
// Runs sScript, dispatching into a library if the script is registered as a
// library script or executing the script via ExecuteScript() if it is not.
// Returns the value of SetLibraryReturnValue().
// Parameters:
// - oSelf: Who actually executes the script. This object will be treated as
//   OBJECT_SELF when the library script is called.
int RunLibraryScript(string sScript, object oSelf = OBJECT_SELF);

// ---< RunLibraryScripts >---
// ---< util_i_libraries >---
// Runs all scripts in the CSV list sScripts, dispatching into libraries if the
// script is registered as a library script or executing the script via
// ExecuteScript() if it is not.
// Parameters:
// - oSelf: the object that actually executes the script. This object will be
//   treated as OBJECT_SELF when the library script is called.
void RunLibraryScripts(string sScripts, object oSelf = OBJECT_SELF);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int GetIsLibraryLoaded(string sLibrary)
{
    return GetLocalInt(LIBRARIES, LIB_LOADED + sLibrary);
}

void LoadLibrary(string sLibrary, int bForce = FALSE)
{
    Debug("Attempting to " + (bForce ? "force " : "") + "load library " + sLibrary);

    if (bForce || !GetLocalInt(LIBRARIES, LIB_LOADED + sLibrary))
    {
        SetLocalString(LIBRARIES, LIB_LAST_LIBRARY, sLibrary);
        SetLocalString(LIBRARIES, LIB_LAST_SCRIPT,  sLibrary);
        SetLocalInt   (LIBRARIES, LIB_LAST_ENTRY,   0);
        SetLocalInt   (LIBRARIES, LIB_LOADED + sLibrary, TRUE);
        ExecuteScript (sLibrary, LIBRARIES);
    }
    else
        Debug("Library " + sLibrary + " already loaded!", DEBUG_LEVEL_ERROR);
}

void LoadLibraries(string sLibraries, int bForce = FALSE)
{
    Debug("Attempting to " + (bForce ? "force " : "") + "load libraries " + sLibraries);

    int i, nCount = CountList(sLibraries);
    for (i = 0; i < nCount; i++)
        LoadLibrary(GetListItem(sLibraries, i), bForce);
}

int RunLibraryScript(string sScript, object oSelf = OBJECT_SELF)
{
    if (sScript == "") return -1;

    Debug("Running library script " + sScript + " on " + GetName(oSelf));

    string sLibrary = GetLocalString(LIBRARIES, LIB_SCRIPT + sScript);
    DeleteLocalInt(oSelf, LIB_RETURN);

    if (sLibrary != "")
    {
        int nEntry = GetLocalInt(LIBRARIES, LIB_ENTRY + sLibrary + sScript);
        Debug("Library script found at " + sLibrary + ":" + IntToString(nEntry));

        SetLocalString(LIBRARIES, LIB_LAST_LIBRARY, sLibrary);
        SetLocalString(LIBRARIES, LIB_LAST_SCRIPT,  sScript);
        SetLocalInt   (LIBRARIES, LIB_LAST_ENTRY,   nEntry);
        ExecuteScript (sLibrary, oSelf);
    }
    else
    {
        Debug(sScript + " is not a library script; executing directly.");
        ExecuteScript(sScript, oSelf);
    }

    return GetLocalInt(oSelf, LIB_RETURN);
}

void RunLibraryScripts(string sScripts, object oSelf = OBJECT_SELF)
{
    int i, nCount = CountList(sScripts);
    for (i = 0; i < nCount; i++)
        RunLibraryScript(GetListItem(sScripts, i), oSelf);
}
