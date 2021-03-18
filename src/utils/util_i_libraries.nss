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

// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

const string LIB_ENTRY        = "LIB_ENTRY";
const string LIB_LOADED       = "LIB_LOADED";
const string LIB_LOADING      = "LIB_LOADING";
const string LIB_RETURN       = "LIB_RETURN";
const string LIB_SCRIPT       = "LIB_SCRIPT";
const string LIB_LAST_ENTRY   = "LIB_LAST_ENTRY";
const string LIB_LAST_LIBRARY = "LIB_LAST_LIBRARY";
const string LIB_LAST_SCRIPT  = "LIB_LAST_SCRIPT";
const string LIB_LOADING_LIB  = "LIB_LOADING_LIB";
const string LIB_INIT         = "LIB_INIT";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< AddLibraryScript >---
// ---< util_i_libraries >---
// Creates the `framework_libraries` table in the module's volatile sqlite database.
// If bReset is TRUE, the table will be dropped and recreated.
void CreateLibraryTable(int bReset = FALSE);

// ---< AddLibraryScript >---
// ---< util_i_libraries >---
// Adds a database record associating sScript with sLibrary at entry nEntry.  sScript
// must be unique module-wide.  
void AddLibraryScript(string sLibrary, string sScript, int nEntry);

// ---< GetScriptLibrary >---
// ---< util_i_libraries >---
// Queries the framework's volatile database to return the script library associated
// with sScript.
string GetScriptLibrary(string sScript);

// ---< GetScriptEntry >---
// ---< util_i_libraries >---
// Queries the framework's volatile database to return the entry number associated
// with sScript.
int GetScriptEntry(string sScript);

// ---< GetScriptData >---
// ---< util_i_libraries >---
// Returns a prepared query with the library and entry data associated with sScript
// allowing users to retrieve the same data returned by GetScriptLibrary and
// GetScriptEntry with one function.
sqlquery GetScriptData(string sScript);

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

void CreateLibraryTable(int bReset = FALSE)
{
    if (GetLocalInt(GetModule(), LIB_INIT) && !bReset)
        return;

    SetLocalInt(GetModule(), LIB_INIT, TRUE);

    if (bReset)
    {
        string sDrop = "DROP TABLE framework_libraries;";
        sqlquery sqlDrop = SqlPrepareQueryObject(GetModule(), sDrop);
        SqlStep(sqlDrop);
    }

    string sLibraries = "CREATE TABLE IF NOT EXISTS framework_libraries (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "sLibrary TEXT NOT NULL, " +
                    "sScript TEXT NOT NULL UNIQUE ON CONFLICT REPLACE, " +
                    "nEntry INTEGER NOT NULL);";

    sqlquery sql = SqlPrepareQueryObject(GetModule(), sLibraries);
    SqlStep(sql);
}

void AddLibraryScript(string sLibrary, string sScript, int nEntry)
{
    CreateLibraryTable();

    string sQuery = "INSERT INTO framework_libraries (sLibrary, sScript, nEntry) " +
                    "VALUES (@sLibrary, @sScript, @nEntry);";
    sqlquery sql = SqlPrepareQueryObject(GetModule(), sQuery);
    SqlBindString(sql, "@sLibrary", sLibrary);
    SqlBindString(sql, "@sScript", sScript);
    SqlBindInt(sql, "@nEntry", nEntry);
    
    SqlStep(sql);
}

string GetScriptFieldData(string sField, string sScript)
{
    CreateLibraryTable();

    string sQuery = "SELECT " + sField + " FROM framework_libraries " +
                    "WHERE sScript = @sScript;";
    sqlquery sql = SqlPrepareQueryObject(GetModule(), sQuery);
    SqlBindString(sql, "@sScript", sScript);

    return SqlStep(sql) ? SqlGetString(sql, 0) : "";
}

string GetScriptLibrary(string sScript)
{
    return GetScriptFieldData("sLibrary", sScript);
}

int GetScriptEntry(string sScript)
{
    return StringToInt(GetScriptFieldData("nEntry", sScript));
}

sqlquery GetScriptData(string sScript)
{
    string sQuery = "SELECT sLibrary, nEntry FROM framework_libraries " +
                    "WHERE sScript = @sScript;";
    sqlquery sql = SqlPrepareQueryObject(GetModule(), sQuery);
    SqlBindString(sql, "@sScript", sScript);

    return sql;
}

int GetIsLibraryLoaded(string sLibrary)
{
    CreateLibraryTable();

    string sQuery = "SELECT COUNT(sLibrary) FROM framework_libraries " +
                    "WHERE sLibrary = @sLibrary LIMIT 1;";
    sqlquery sql = SqlPrepareQueryObject(GetModule(), sQuery);
    SqlBindString(sql, "@sLibrary", sLibrary);

    return SqlStep(sql) ? SqlGetInt(sql, 0) : FALSE;
}

void LoadLibrary(string sLibrary, int bForce = FALSE)
{
    Debug("Attempting to " + (bForce ? "force " : "") + "load library " + sLibrary);

    if (bForce || !GetIsLibraryLoaded(sLibrary))
    {
        SetLocalString(GetModule(), LIB_LAST_LIBRARY, sLibrary);
        SetLocalString(GetModule(), LIB_LAST_SCRIPT, sLibrary);
        SetLocalInt(GetModule(), LIB_LAST_ENTRY, 0);

        SetLocalInt(GetModule(), LIB_LOADING, TRUE);
        ExecuteScript(sLibrary, GetModule());
    }
    else
        Error("Library " + sLibrary + " already loaded!");
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

    string sLibrary;
    int nEntry;

    sqlquery sqlScriptData = GetScriptData(sScript);
    if (SqlStep(sqlScriptData))
    {
        sLibrary = SqlGetString(sqlScriptData, 0);
        nEntry = SqlGetInt(sqlScriptData, 1);
    }

    DeleteLocalInt(oSelf, LIB_RETURN);

    if (sLibrary != "")
    {
        Debug("Library script " + sScript + " found in " + sLibrary +
            (nEntry != 0 ? " at entry " + IntToString(nEntry) : ""));

        SetLocalString(GetModule(), LIB_LAST_LIBRARY, sLibrary);
        SetLocalString(GetModule(), LIB_LAST_SCRIPT, sScript);
        SetLocalInt(GetModule(), LIB_LAST_ENTRY, nEntry);
        
        ExecuteScript (sLibrary, oSelf);
    }
    else
    {
        Debug(sScript + " is not a library script; executing directly");
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
