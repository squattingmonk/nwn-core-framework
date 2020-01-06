// -----------------------------------------------------------------------------
//    File: util_i_library.nss
//  System: Utilities (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This script contains boilerplate code for creating a library dispatcher. It
// should only be included in library scripts as it implements main().
// -----------------------------------------------------------------------------

#include "util_i_libraries"

// -----------------------------------------------------------------------------
//                               Global Variables
// -----------------------------------------------------------------------------

// We instantiate these here so they are automatically set when a library is
// executed. If the library itself calls another library script, these variables
// will remain valid in the scope of the parent library.
int    LIB_LOADING         = (LIBRARIES == OBJECT_SELF);
int    LIB_CURRENT_ENTRY   = GetLocalInt   (LIBRARIES, LIB_LAST_ENTRY);
string LIB_CURRENT_LIBRARY = GetLocalString(LIBRARIES, LIB_LAST_LIBRARY);
string LIB_CURRENT_SCRIPT  = GetLocalString(LIBRARIES, LIB_LAST_SCRIPT);


// -----------------------------------------------------------------------------
//                              Function Protoypes
// -----------------------------------------------------------------------------

// ---< RegisterLibraryScript >---
// ---< util_i_library >---
// Registers sScript as being located inside the current library at nEntry. This
// The script can later be called using RunLibraryScript(sScript) and routed to
// the proper function using OnLibraryScript(sScript, nEntry).
// Parameters:
// - sScript: the name of the script to register. This name must be unique in
//   the module. If a second script with the same name is registered, it will
//   overwrite the first one.
// - nEntry: a number unique to this library to identify this script. Is can be
//   obtained at runtime in OnLibraryScript() and used to access the correct
//   function. If this parameter is left as the default, you will have to filter
//   your script using the sScript parameter, which is less efficient.
void RegisterLibraryScript(string sScript, int nEntry = 0);

// ---< LibraryReturn >---
// ---< util_i_library >---
// Sets the return value of the currently executing library to nValue.
void LibraryReturn(int nValue);

// ---< OnLibraryLoad >---
// This is a user-defined function that registers function names to a unique (to
// this library) number. When the function name is run using RunLibraryScript(),
// this number will be passed to the user-defined function OnLibraryScript(),
// which resolves the call to the correct function.
//
// Example usage:
// void OnLibraryLoad()
// {
//     RegisterLibraryScript("MyFunction");
//     RegisterLibraryScript("MyOtherFunction");
// }
//
// or, if using nEntry...
// void OnLibraryLoad()
// {
//     RegisterLibraryScript("MyFunction",      1);
//     RegisterLibraryScript("MyOtherFunction", 2);
// }
void OnLibraryLoad();

// ---< OnLibraryScript >---
// This is a user-defined function that routes a unique (to the module) script
// name (sScript) or a unique (to this library) number (nEntry) to a function.
//
// Example usage:
// void OnLibraryScript(string sScript, int nEntry)
// {
//     if      (sScript == "MyFunction")      MyFunction();
//     else if (sScript == "MyOtherFunction") MyOtherFunction();
// }
//
// or, using nEntry...
// void OnLibraryScript(string sScript, int nEntry)
// {
//     switch (nEntry)
//     {
//         case 1: MyFunction();      break;
//         case 2: MyOtherFunction(); break;
//     }
// }
//
// For advanced usage, see the libraries included in the Core Framework.
void OnLibraryScript(string sScript, int nEntry);

// -----------------------------------------------------------------------------
//                           Function Implementations
// -----------------------------------------------------------------------------

void RegisterLibraryScript(string sScript, int nEntry = 0)
{
    string sLibrary = LIB_CURRENT_LIBRARY;
    string sExist   = GetLocalString(LIBRARIES, LIB_SCRIPT + sScript);

    if (sLibrary != sExist)
    {
        if (sExist != "")
            Debug(sLibrary + " is overriding " + sLibrary + "'s implementation of " +
                sScript, DEBUG_LEVEL_WARNING);

        SetLocalString(LIBRARIES, LIB_SCRIPT + sScript, sLibrary);
    }

    int nOldEntry = GetLocalInt(LIBRARIES, LIB_ENTRY + sLibrary + sScript);
    if (nOldEntry)
        Debug(sLibrary + " already declared " + sScript + ". " +
            " Old Entry: " + IntToString(nOldEntry) +
            " New Entry: " + IntToString(nEntry), DEBUG_LEVEL_WARNING);

    SetLocalInt(LIBRARIES, LIB_ENTRY + sLibrary + sScript, nEntry);
}

void LibraryReturn(int nValue)
{
    SetLocalInt(OBJECT_SELF, LIB_RETURN, nValue);
}

// These are dummy implementations to prevent nwnsc from complaining that they
// do not exist. If you want to compile in the toolset rather than using nwnsc,
// comment these lines out.
//#pragma default_function(OnLibraryLoad)
//#pragma default_function(OnLibraryScript)


// -----------------------------------------------------------------------------
//                                 Main Routine
// -----------------------------------------------------------------------------

void main()
{
    if (LIB_LOADING)
        OnLibraryLoad();
    else
        OnLibraryScript(LIB_CURRENT_SCRIPT, LIB_CURRENT_ENTRY);
}
