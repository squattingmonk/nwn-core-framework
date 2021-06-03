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

const string DATA_PREFIX = "Datapoint: ";
const string DATA_POINT  = "x1_hen_inv";
const string DATA_ITEM   = "nw_it_msmlmisc22";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< CreateDatapoint >---
// ---< util_i_datapoint >---
// Creates a datapoint that oOwner can use to store sSystem-related variables.
// If oOwner is invalid, it will be the module. The placeable is created at
// oOwner's location (or the module starting location if oOwner is an area or
// the module).
object CreateDatapoint(string sSystem, object oOwner = OBJECT_INVALID);

// ---< GetDatapoint >---
// ---< util_i_datapoint >---
// Returns the object that oOwner uses to store sSystem-related variables. If
// oOwner is invalid, it will be the module. If the datapoint has not been
// created and bCreate is TRUE, the system will create one. The system-generated
// datapoint is an invisible placeable created at oOwner's location (or the
// module starting location if oOwner is an area or the module).
object GetDatapoint(string sSystem, object oOwner = OBJECT_INVALID, int bCreate = TRUE);

// ---< SetDatapoint >---
// ---< util_i_datapoint >---
// Sets oTarget as the object that oOwner uses to store sSystem-related
// variables. If oOwner is invalid, it will be the module. Useful if you want
// more control over the resref, object type, or location of your datapoint.
void SetDatapoint(string sSystem, object oTarget, object oOwner = OBJECT_INVALID);

// ---< CreateDataItem >---
// ---< util_i_datapoint >---
// Creates a data item on oDatapoint that it can use to store sSubSystem-related
// variables.
object CreateDataItem(object oDatapoint, string sSubSystem);

// ---< GetDataItem >---
// ---< util_i_datapoint >---
// Returns the item that oDatapoint uses to store sSubSystem-related variables.
object GetDataItem(object oDatapoint, string sSubSystem);

// ---< SetDataItem >---
// ---< util_i_datapoint >---
// Sets oItem as the object that oDatapoint uses to store sSubSystem-related
// variables.
void SetDataItem(object oDatapoint, string sSubSystem, object oItem);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

object CreateDatapoint(string sSystem, object oOwner = OBJECT_INVALID)
{
    if (oOwner == OBJECT_INVALID)
        oOwner = GetModule();

    location lLoc = GetLocation(oOwner);
    if (!GetObjectType(oOwner))
        lLoc = GetStartingLocation();

    object oData = CreateObject(OBJECT_TYPE_PLACEABLE, DATA_POINT, lLoc);
    SetName(oData, DATA_PREFIX + sSystem);
    SetUseableFlag(oData, FALSE);
    SetDatapoint(sSystem, oData, oOwner);
    return oData;
}

object GetDatapoint(string sSystem, object oOwner = OBJECT_INVALID, int bCreate = TRUE)
{
    if (oOwner == OBJECT_INVALID)
        oOwner = GetModule();

    object oData = GetLocalObject(oOwner, DATA_PREFIX + sSystem);

    if (!GetIsObjectValid(oData) && bCreate)
        oData = CreateDatapoint(sSystem, oOwner);

    return oData;
}

void SetDatapoint(string sSystem, object oTarget, object oOwner = OBJECT_INVALID)
{
    if (oOwner == OBJECT_INVALID)
        oOwner = GetModule();

    SetLocalObject(oOwner, DATA_PREFIX + sSystem, oTarget);
}

object CreateDataItem(object oDatapoint, string sSubSystem)
{
    object oItem = CreateItemOnObject(DATA_ITEM, oDatapoint);
    SetLocalObject(oDatapoint, sSubSystem, oItem);
    SetName(oItem, sSubSystem);
    return oItem;
}

object GetDataItem(object oDatapoint, string sSubSystem)
{
    return GetLocalObject(oDatapoint, sSubSystem);
}

void SetDataItem(object oDatapoint, string sSubSystem, object oItem)
{
    SetLocalObject(oDatapoint, sSubSystem, oItem);
}
