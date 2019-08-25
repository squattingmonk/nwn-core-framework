// -----------------------------------------------------------------------------
//    File: util_i_datapoint.nss
//  System: Utilities (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file holds functions for creating and interacting with data points. Data
// points are invisible objects used to hold variables specific to a system.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

const string DATA_RESREF = "nw_waypoint001";
const string DATA_PREFIX = "Datapoint: ";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< GetDatapoint >---
// ---< util_i_datapoint >---
// Returns the object that oOwner uses to store sSystem-related variables. If
// oOwner is invalid, it will be the module. If the datapoint has not been
// created and bCreate is TRUE, the system will create one. The system-generated
// datapoint is a stock NWN waypoint created at the module starting location.
object GetDatapoint(string sSystem, object oOwner = OBJECT_INVALID, int bCreate = TRUE);

// ---< SetDatapoint >---
// ---< util_i_datapoint >---
// Sets oTarget as the object that oOwner uses to store sSystem-related
// variables. If oOwner is invalid, it will be the module. Useful if you want
// more control over the resref, object type, or location of your datapoint.
void SetDatapoint(string sSystem, object oTarget, object oOwner = OBJECT_INVALID);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

object GetDatapoint(string sSystem, object oOwner = OBJECT_INVALID, int bCreate = TRUE)
{
    if (oOwner == OBJECT_INVALID)
        oOwner = GetModule();

    object oData = GetLocalObject(oOwner, DATA_PREFIX + sSystem);

    if (!GetIsObjectValid(oData) && bCreate)
    {
        oData = CreateObject(OBJECT_TYPE_WAYPOINT, DATA_RESREF,
                GetStartingLocation(), FALSE, sSystem);
        SetLocalObject(oOwner, DATA_PREFIX + sSystem, oData);
    }

    return oData;
}

void SetDatapoint(string sSystem, object oTarget, object oOwner = OBJECT_INVALID)
{
    if (oOwner == OBJECT_INVALID)
        oOwner = GetModule();

    SetLocalObject(oOwner, DATA_PREFIX + sSystem, oTarget);
}
