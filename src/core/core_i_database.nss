// -----------------------------------------------------------------------------
//    File: core_i_database.nss
//  System: Core Framework (database include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file contains functions for interacting with an SQLite database through
// NWNXEE. These functions may be used across plugins to provide a universal
// interface.
//
// PCs are identified using a unique integer ID (stored as a string to reduce
// conversions), while non-PC objects are identified by tag. This means objects
// with identical tags will share values in the database.
// -----------------------------------------------------------------------------

#include "nwnx_sql"
#include "util_i_debug"
#include "core_c_config"

// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

const string PCID = "PCID";

// Database types
const int DATABASE_TYPE_NONE       = 0;
const int DATABASE_TYPE_SQLITE     = 1;
const int DATABASE_TYPE_MYSQL      = 2;

// Table structures for Core tables.
const string SQLITE_TABLE_PC           = "pc           (id     INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, player TEXT NOT NULL DEFAULT '', UNIQUE (name, player))";
const string SQLITE_TABLE_PCDATA       = "pcdata       (pc_id  INTEGER,                  varname TEXT NOT NULL DEFAULT '', value TEXT NOT NULL DEFAULT '', PRIMARY KEY (pc_id,  varname), FOREIGN KEY (pc_id) REFERENCES pc (id) ON UPDATE CASCADE ON DELETE CASCADE)";
const string SQLITE_TABLE_PCOBJECTDATA = "pcobjectdata (pc_id  INTEGER,                  varname TEXT NOT NULL DEFAULT '', value TEXT NOT NULL DEFAULT '', PRIMARY KEY (pc_id,  varname), FOREIGN KEY (pc_id) REFERENCES pc (id) ON UPDATE CASCADE ON DELETE CASCADE)";
const string SQLITE_TABLE_PWDATA       = "pwdata       (tag    TEXT NOT NULL DEFAULT '', varname TEXT NOT NULL DEFAULT '', value TEXT NOT NULL DEFAULT '', PRIMARY KEY (tag,    varname))";
const string SQLITE_TABLE_PWOBJECTDATA = "pwobjectdata (tag    TEXT NOT NULL DEFAULT '', varname TEXT NOT NULL DEFAULT '', value TEXT NOT NULL DEFAULT '', PRIMARY KEY (tag,    varname))";
const string SQLITE_TABLE_PLAYERDATA   = "playerdata   (player TEXT NOT NULL DEFAULT '', varname TEXT NOT NULL DEFAULT '', value TEXT NOT NULL DEFAULT '', PRIMARY KEY (player, varname))";

const string MYSQL_TABLE_PC           = "pc           (id     INT UNSIGNED NOT NULL AUTO_INCREMENT, name    VARCHAR(64) NOT NULL DEFAULT '', player VARCHAR(64)  NOT NULL DEFAULT '', PRIMARY KEY (id),             UNIQUE  KEY (name, player))";
const string MYSQL_TABLE_PCDATA       = "pcdata       (pc_id  INT UNSIGNED NOT NULL DEFAULT 0,      varname VARCHAR(64) NOT NULL DEFAULT '', value  TEXT,                             PRIMARY KEY (varname, pc_id), FOREIGN KEY (pc_id) REFERENCES pc (id) ON UPDATE CASCADE ON DELETE CASCADE)";
const string MYSQL_TABLE_PCOBJECTDATA = "pcobjectdata (pc_id  INT UNSIGNED NOT NULL DEFAULT 0,      varname VARCHAR(64) NOT NULL DEFAULT '', value  TEXT,                             PRIMARY KEY (varname, pc_id), FOREIGN KEY (pc_id) REFERENCES pc (id) ON UPDATE CASCADE ON DELETE CASCADE)";
const string MYSQL_TABLE_PWDATA       = "pwdata       (tag    VARCHAR(64)  NOT NULL DEFAULT '',     varname VARCHAR(64) NOT NULL DEFAULT '', value  TEXT,                             PRIMARY KEY (varname, tag))";
const string MYSQL_TABLE_PWOBJECTDATA = "pwobjectdata (tag    VARCHAR(64)  NOT NULL DEFAULT '',     varname VARCHAR(64) NOT NULL DEFAULT '', value  TEXT,                             PRIMARY KEY (varname, tag))";
const string MYSQL_TABLE_PLAYERDATA   = "playerdata   (player VARCHAR(64)  NOT NULL DEFAULT '',     varname VARCHAR(64) NOT NULL DEFAULT '', value  TEXT,                             PRIMARY KEY (varname, player))";

// Used to yield multiple values based on whether the query is for a PC
struct QueryHelper
{
    string table;  // The table to operate on
    string column; // The column to use as the object's ID
    string id;     // The ID of the object
};

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ----- Utility Functions -----------------------------------------------------

// ---< LocationToString >---
// ---< core_i_database >---
// Returns a location converted to its string representation. Used for storing
// locations in a database.
string LocationToString(location lLocation);

// ---< StringToLocation >---
// ---< core_i_database >---
// Returns a location converted from its string representation. Used for
// retrieving locations from a database.
location StringToLocation(string sLocation);

// ---< GetQueryHelper >---
// ---< core_i_database >---
// Returns a helper structure that contains the appropriate table, column, and
// ID to use for a query based on whether oObject is a PC.
struct QueryHelper GetQueryHelper(object oObject, string sTable = "pwdata", string sPCTable = "pcdata");

// ---< NWNX_SQL_PrepareAndExecuteQuery >---
// ---< core_i_database >---
// Prepares an SQL query with up to 10 string parameters replacing any ?
// characters in the query. Returns whether the query executed successfully.
int NWNX_SQL_PrepareAndExecuteQuery(string sSQL,
        string s0 = "", string s1 = "", string s2 = "", string s3 = "", string s4 = "",
        string s5 = "", string s6 = "", string s7 = "", string s8 = "", string s9 = "");

// ----- Database Interface ----------------------------------------------------

// ---< GetDatabaseType >---
// ---< core_i_database >---
// Returns the type of database as a DATABASE_TYPE_* constant.
int GetDatabaseType();

// ---< InitializeDatabase >---
// ---< core_i_database >---
// Creates the tables needed by the Core Database functions if they do not
// already exist.
void InitializeDatabase();

// ---< GetPCID >---
// ---< core_i_database >---
// Returns the persistent ID of a PC, adding him to the database if he is not
// already there. The ID is an autoincremented integer beginning at 1 for the
// first PC in the database. The PCID is used to uniquely identify this
// character in other tables.
string GetPCID(object oPC);

// ---< DeleteDatabaseVariable >---
// ---< core_i_database >---
// Deletes a variable named sVarName belonging to oObject from the database. If
// oObject is invalid, the module will be used instead. Note that this function
// relies on the tag of the object to identify it; items with identical tags
// will share variables. This function works with the following types: int,
// float, location, string.
void DeleteDatabaseVariable(string sVarName, object oObject = OBJECT_INVALID);

// ---< DeleteDatabaseObject >---
// ---< core_i_database >---
// Deletes an object variable named sVarName belonging to oObject from the
// database. If oObject is invalid, the module will be used instead.
void DeleteDatabaseObject(string sVarName, object oObject = OBJECT_INVALID);

// ---< GetDatabaseFloat >---
// ---< core_i_database >---
// Returns the float value named sVarName for oObject in the database. If
// oObject is invalid, will use the module instead.
float GetDatabaseFloat(string sVarName, object oObject = OBJECT_INVALID);

// ---< GetDatabaseInt >---
// ---< core_i_database >---
// Returns the int value named sVarName for oObject in the database. If oObject
// is invalid, will use the module instead.
int GetDatabaseInt(string sVarName, object oObject = OBJECT_INVALID);

// ---< GetDatabaseLocation >---
// ---< core_i_database >---
// Returns the location value named sVarName for oObject in the database. If
// oObject is invalid, will use the module instead.
location GetDatabaseLocation(string sVarName, object oObject = OBJECT_INVALID);

// ---< GetDatabaseObject >---
// ---< core_i_database >---
// Returns the object value named sVarName for oObject in the database. If
// oObject is invalid, will use the module instead.
object GetDatabaseObject(string sVarName, object oObject = OBJECT_INVALID);

// ---< GetDatabaseString >---
// ---< core_i_database >---
// Returns the string value named sVarName for oObject in the database. If
// oObject is invalid, will use the module instead.
string GetDatabaseString(string sVarName, object oObject = OBJECT_INVALID);

// ---< SetDatabaseFloat >---
// ---< core_i_database >---
// Sets the float value named sVarName for oObject in the database. If oObject
// is invalid, will use the module instead.
void SetDatabaseFloat(string sVarName, float fValue, object oObject = OBJECT_INVALID);

// ---< SetDatabaseInt >---
// ---< core_i_database >---
// Sets the int value named sVarName for oObject in the database. If oObject is
// invalid, will use the module instead.
void SetDatabaseInt(string sVarName, int nValue, object oObject = OBJECT_INVALID);

// ---< SetDatabaseLocation >---
// ---< core_i_database >---
// Sets the location value named sVarName for oObject in the database. If
// oObject is invalid, will use the module instead.
void SetDatabaseLocation(string sVarName, location lValue, object oObject = OBJECT_INVALID);

// ---< SetDatabaseObject >---
// ---< core_i_database >---
// Sets the object value named sVarName for oObject in the database. If oObject
// is invalid, will use the module instead.
void SetDatabaseObject(string sVarName, object oValue, object oObject = OBJECT_INVALID);

// ---< SetDatabaseString >---
// ---< core_i_database >---
// Sets the string value named sVarName for oObject in the database. If oObject
// is invalid, will use the module instead.
void SetDatabaseString(string sVarName, string sValue, object oObject = OBJECT_INVALID);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

// ----- Utility Functions -----------------------------------------------------

string LocationToString(location lLocation)
{
    object oArea        = GetAreaFromLocation(lLocation);
    vector vPosition    = GetPositionFromLocation(lLocation);
    float  fOrientation = GetFacingFromLocation(lLocation);
    return "#AREA#"        + GetTag(oArea) +
           "#POSITION_X#"  + FloatToString(vPosition.x)  +
           "#POSITION_Y#"  + FloatToString(vPosition.y)  +
           "#POSITION_Z#"  + FloatToString(vPosition.z)  +
           "#ORIENTATION#" + FloatToString(fOrientation) + "#END#";
}

location StringToLocation(string sLocation)
{
    location lReturnValue;
    object oArea;
    vector vPosition;
    float fOrientation, fX, fY, fZ;

    int nPos, nCount, nLen = GetStringLength(sLocation);

    if (nLen > 0)
    {
        nPos   = FindSubString(sLocation, "#AREA#") + 6;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLen - nPos), "#");
        oArea  = GetObjectByTag(GetSubString(sLocation, nPos, nCount));

        nPos   = FindSubString(sLocation, "#POSITION_X#") + 12;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLen - nPos), "#");
        fX     = StringToFloat(GetSubString(sLocation, nPos, nCount));

        nPos   = FindSubString(sLocation, "#POSITION_Y#") + 12;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLen - nPos), "#");
        fY     = StringToFloat(GetSubString(sLocation, nPos, nCount));

        nPos   = FindSubString(sLocation, "#POSITION_Z#") + 12;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLen - nPos), "#");
        fZ     = StringToFloat(GetSubString(sLocation, nPos, nCount));

        vPosition = Vector(fX, fY, fZ);

        nPos         = FindSubString(sLocation, "#ORIENTATION#") + 13;
        nCount       = FindSubString(GetSubString(sLocation, nPos, nLen - nPos), "#");
        fOrientation = StringToFloat(GetSubString(sLocation, nPos, nCount));

        lReturnValue = Location(oArea, vPosition, fOrientation);
    }
    return lReturnValue;
}

struct QueryHelper GetQueryHelper(object oObject, string sTable = "pwdata", string sPCTable = "pcdata")
{
    if (!GetIsObjectValid(oObject))
        oObject = GetModule();

    int bPC = GetIsPC(oObject);
    struct QueryHelper q;

    q.table = bPC ? sPCTable : sTable;
    q.column = bPC ? "pc_id" : "tag";
    q.id = bPC ? GetPCID(oObject) : GetTag(oObject);
    return q;
}

int NWNX_SQL_PrepareAndExecuteQuery(string sSQL,
        string s0 = "", string s1 = "", string s2 = "", string s3 = "", string s4 = "",
        string s5 = "", string s6 = "", string s7 = "", string s8 = "", string s9 = "")
{
    if (!NWNX_SQL_PrepareQuery(sSQL))
        return FALSE;

    string sParam;
    int i, nCount = NWNX_SQL_GetPreparedQueryParamCount();

    for (i = 0; i < nCount; i++)
    {
        switch (i)
        {
            case  0: sParam =  s0; break;
            case  1: sParam =  s1; break;
            case  2: sParam =  s2; break;
            case  3: sParam =  s3; break;
            case  4: sParam =  s4; break;
            case  5: sParam =  s5; break;
            case  6: sParam =  s6; break;
            case  7: sParam =  s7; break;
            case  8: sParam =  s8; break;
            case  9: sParam =  s9; break;
            default: sParam = "*INVALID*";
        }

        NWNX_SQL_PreparedString(i, sParam);
    }
    return NWNX_SQL_ExecutePreparedQuery();
}

// ----- Database Interface ----------------------------------------------------

int GetDatabaseType()
{
    string sDatabase = GetStringUpperCase(NWNX_SQL_GetDatabaseType());
    if (sDatabase == "SQLITE")
        return DATABASE_TYPE_SQLITE;
    if (sDatabase == "MYSQL")
        return DATABASE_TYPE_MYSQL;

    return DATABASE_TYPE_NONE;
}

int CreateTable(string sStructure)
{
    return NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + sStructure);
}

int CreateEntry(string sStructure)
{
    return NWNX_SQL_ExecuteQuery(sStructure);
}

void InitializeDatabase()
{
    int nDatabase = GetDatabaseType();

    if (nDatabase == DATABASE_TYPE_SQLITE)
    {
        // Needed to ensure our foreign key constraints work
        NWNX_SQL_ExecuteQuery("PRAGMA foreign_keys=1");

        CreateTable(SQLITE_TABLE_PC);
        CreateTable(SQLITE_TABLE_PCDATA);
        CreateTable(SQLITE_TABLE_PCOBJECTDATA);
        CreateTable(SQLITE_TABLE_PWDATA);
        CreateTable(SQLITE_TABLE_PWOBJECTDATA);
        CreateTable(SQLITE_TABLE_PLAYERDATA);
    }
    else if (nDatabase == DATABASE_TYPE_MYSQL)
    {
        CreateTable(MYSQL_TABLE_PC);
        CreateTable(MYSQL_TABLE_PCDATA);
        CreateTable(MYSQL_TABLE_PCOBJECTDATA);
        CreateTable(MYSQL_TABLE_PWDATA);
        CreateTable(MYSQL_TABLE_PWOBJECTDATA);
        CreateTable(MYSQL_TABLE_PLAYERDATA);
    }
    else
        Debug("No supported database found. Falling back to campaign DB...",
              DEBUG_LEVEL_WARNING);
}

string GetPCID(object oPC)
{
    if (!GetIsPC(oPC))
        return "";

    string sPCID = GetLocalString(oPC, PCID);

    // Verify that the ID is not blank and is a valid number > 0. If it passes
    // this check, we trust it is right.
    if (!StringToInt(sPCID))
    {
        sPCID = "";
        string sName = GetName(oPC, TRUE);
        string sPlayer = GetPCPlayerName(oPC);
        int nDatabase = GetDatabaseType();

        if (nDatabase)
        {
            string sQuery= "SELECT id from pc WHERE name=? AND player=?";

            if (NWNX_SQL_PrepareAndExecuteQuery(sQuery, sName, sPlayer))
            {
                // Load the PCID from the database
                if (NWNX_SQL_ReadyToReadNextRow())
                {
                    NWNX_SQL_ReadNextRow();
                    sPCID = NWNX_SQL_ReadDataInActiveRow();
                }
                else
                {
                    // Add the PC to the database and return the PCID
                    sQuery = "INSERT INTO pc (name, player) VALUES (?, ?)";

                    NWNX_SQL_PrepareAndExecuteQuery(sQuery, sName, sPlayer);
                    sPCID = IntToString(NWNX_SQL_GetAffectedRows());
                }
            }
        }
        else
            sPCID = GetCampaignString(FALLBACK_DATABASE, PCID, oPC);

        SetLocalString(oPC, PCID, sPCID);
    }
    return sPCID;
}

void DeleteDatabaseVariable(string sVarName, object oObject = OBJECT_INVALID)
{
    int nDatabase = GetDatabaseType();

    if (nDatabase)
    {
        struct QueryHelper q = GetQueryHelper(oObject);
        string sQuery = "DELETE FROM " + q.table + " WHERE " + q.column + "=? AND varname=?";
        NWNX_SQL_PrepareAndExecuteQuery(sQuery, q.id, sVarName);
    }
    else
        DeleteCampaignVariable(FALLBACK_DATABASE, sVarName, oObject);
}

void DeleteDatabaseObject(string sVarName, object oObject = OBJECT_INVALID)
{
    int nDatabase = GetDatabaseType();

    if (nDatabase)
    {
        struct QueryHelper q = GetQueryHelper(oObject, "pwobjectdata", "pcobjectdata");
        string sQuery = "DELETE FROM " + q.table + " WHERE " + q.column + "=? AND varname=?";
        NWNX_SQL_PrepareAndExecuteQuery(sQuery, q.id, sVarName);
    }
    else
        DeleteCampaignVariable(FALLBACK_DATABASE, sVarName, oObject);
}

float GetDatabaseFloat(string sVarName, object oObject = OBJECT_INVALID)
{
    return StringToFloat(GetDatabaseString(sVarName, oObject));
}

int GetDatabaseInt(string sVarName, object oObject = OBJECT_INVALID)
{
    return StringToInt(GetDatabaseString(sVarName, oObject));
}

location GetDatabaseLocation(string sVarName, object oObject = OBJECT_INVALID)
{
    return StringToLocation(GetDatabaseString(sVarName, oObject));
}

object GetDatabaseObject(string sVarName, object oObject = OBJECT_INVALID)
{
    int nDatabase = GetDatabaseType();

    if (nDatabase)
    {
        struct QueryHelper q = GetQueryHelper(oObject, "pwobjectdata", "pcobjectdata");
        string sQuery = "SELECT value FROM " + q.table + " WHERE " + q.column + "=? AND varname=?";
        NWNX_SQL_PrepareAndExecuteQuery(sQuery, q.id, sVarName);

        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            return NWNX_SQL_ReadFullObjectInActiveRow();
        }
        return OBJECT_INVALID;
    }
    location lLoc = GetLocation(oObject);
    return RetrieveCampaignObject(FALLBACK_DATABASE, sVarName, lLoc, oObject, oObject);
}

string GetDatabaseString(string sVarName, object oObject = OBJECT_INVALID)
{
    int nDatabase = GetDatabaseType();

    if (nDatabase)
    {
        struct QueryHelper q = GetQueryHelper(oObject);
        string sQuery = "SELECT value FROM " + q.table + " WHERE " + q.column + "=? AND varname=?";
        NWNX_SQL_PrepareAndExecuteQuery(sQuery, q.id, sVarName);

        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            return NWNX_SQL_ReadDataInActiveRow();
        }
        return "";
    }
    return GetCampaignString(FALLBACK_DATABASE, sVarName, oObject);
}

void SetDatabaseFloat(string sVarName, float fValue, object oObject = OBJECT_INVALID)
{
    SetDatabaseString(sVarName, FloatToString(fValue), oObject);
}

void SetDatabaseInt(string sVarName, int nValue, object oObject = OBJECT_INVALID)
{
    SetDatabaseString(sVarName, IntToString(nValue), oObject);
}

void SetDatabaseLocation(string sVarName, location lValue, object oObject = OBJECT_INVALID)
{
    SetDatabaseString(sVarName, LocationToString(lValue), oObject);
}

void SetDatabaseObject(string sVarName, object oValue, object oObject = OBJECT_INVALID)
{
    int nDatabase = GetDatabaseType();

    if (nDatabase)
    {
        struct QueryHelper q = GetQueryHelper(oObject, "pwobjectdata", "pcobjectdata");
        string sQuery = "REPLACE INTO " + q.table + "(" + q.column + ",varname, value) VALUES (?, ?, ?)";

        NWNX_SQL_PreparedString(0, q.id);
        NWNX_SQL_PreparedString(1, sVarName);
        NWNX_SQL_PreparedObjectFull(2, oValue);
        NWNX_SQL_ExecutePreparedQuery();
    }
    else
        StoreCampaignObject(FALLBACK_DATABASE, sVarName, oValue, oObject);
}

void SetDatabaseString(string sVarName, string sValue, object oObject = OBJECT_INVALID)
{
    int nDatabase = GetDatabaseType();

    if (nDatabase)
    {
        struct QueryHelper q = GetQueryHelper(oObject);
        string sQuery = "REPLACE INTO " + q.table + "(" + q.column + ",varname, value) VALUES (?, ?, ?)";
        NWNX_SQL_PrepareAndExecuteQuery(sQuery, q.id, sVarName, sValue);
    }
    else
        SetCampaignString(FALLBACK_DATABASE, sVarName, sValue, oObject);
}
