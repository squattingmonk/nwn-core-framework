// -----------------------------------------------------------------------------
//    File: util_i_varlists.nss
//  System: Utilities (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file holds utility functions for manipulating local variable lists.
// Because these lists are zero-indexed, they can be used to approximate
// one-dimensional arrays.
//
// Local variable lists are specific to a variable type: string lists and int
// lists can be maintained separately even when you give them the same name.
//
// The majority of functions in this utility apply to each possible variable
// type: float, int, location, vector, object, string, json.  However, there
// are some that only apply to a subset of variable types, such as
// Sort[Float|Int|String]List() and [Increment|Decrement]ListInt().
// -----------------------------------------------------------------------------

#include "util_i_math"

// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

// Constants used to describe float|int|string sorting order
const int LIST_SORT_ASC = 1;
const int LIST_SORT_DESC = 2;

// Prefixes used to keep list variables from colliding with other locals.  These
// constants are considered private and should not be referenced from other scripts.
const string LIST_REF              = "Ref:";
const string VARLIST_TYPE_VECTOR   = "VL:";
const string VARLIST_TYPE_FLOAT    = "FL:";
const string VARLIST_TYPE_INT      = "IL:";
const string VARLIST_TYPE_LOCATION = "LL:";
const string VARLIST_TYPE_OBJECT   = "OL:";
const string VARLIST_TYPE_STRING   = "SL:";
const string VARLIST_TYPE_JSON     = "JL:";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< GetVectorObject >---
// ---< util_i_varlists >---
// Returns a json vector object encoded from vector vPosition. This
// function should be used if creating elements to be used
// with SetVectorList().   
json GetVectorObject(vector vPosition = [0.0, 0.0, 0.0]);

// ---< GetVectorObject >---
// ---< util_i_varlists >---
// Returns a vector decoded from json vector object jPosition. This
// function should be used to decode elements of a list returned by
// GetVectorList().
vector GetObjectVector(json jPosition);

// ---< GetLocationObject >---
// ---< util_i_varlists >---
// Returns a json location object encoded from location lLocation.
// This function should be used when creating elements to be used
// with SetLocationList().
json GetLocationObject(location lLocation);

// ---< GetObjectLocation >---
// ---< util_i_varlists >---
// Returns a location decoded from json location object jLocation.
// This function should be used to decode elements of a list returned
// by GetLocationList().
location GetObjectLocation(json jLocation);

// ---< AddListFloat >---
// ---< util_i_varlists >---
// Adds fValue to a float list on oTarget given the list name sListName. If
// bAddUnique is TRUE, this only adds to the list if it is not already there.
// Returns whether the addition was successful.
int AddListFloat(object oTarget, float fValue, string sListName = "", int bAddUnique = FALSE);

// ---< AddListInt >---
// ---< util_i_varlists >---
// Adds nValue to an int list on oTarget given the list name sListName. If
// bAddUnique is TRUE, this only adds to the list if it is not already there.
// Returns whether the addition was successful.
int AddListInt(object oTarget, int nValue, string sListName = "", int bAddUnique = FALSE);

// ---< AddListLocation >---
// ---< util_i_varlists >---
// Adds lValue to a location list on oTarget given the list name sListName. If
// bAddUnique is TRUE, this only adds to the list if it is not already there.
// Returns whether the addition was successful.
int AddListLocation(object oTarget, location lValue, string sListName = "", int bAddUnique = FALSE);

// ---< AddListVector >---
// ---< util_i_varlists >---
// Adds vValue to a vector list on oTarget given the list name sListName. If
// bAddUnique is TRUE, this only adds to the list if it is not already there.
// Returns whether the addition was successful.
int AddListVector(object oTarget, vector vValue, string sListName = "", int bAddUnique = FALSE);

// ---< AddListObject >---
// ---< util_i_varlists >---
// Adds oValue to a object list on oTarget given the list name sListName. If
// bAddUnique is TRUE, this only adds to the list if it is not already there.
// Returns whether the addition was successful.
int AddListObject(object oTarget, object oValue, string sListName = "", int bAddUnique = FALSE);

// ---< AddListString >---
// ---< util_i_varlists >---
// Adds sValue to a string list on oTarget given the list name sListName. If
// bAddUnique is TRUE, this only adds to the list if it is not already there.
// Returns whether the addition was successful.
int AddListString(object oTarget, string sValue, string sListName = "", int bAddUnique = FALSE);

// ---< AddListJson >---
// ---< util`_i_varlists >---
// Adds jValue to a json list on oTarget given the list name sListName. If
// bAddUnique is TRUE, this only adds to the list if it is not already there.
// Returns whether the addition was successful.
int AddListJson(object oTarget, json jValue, string sListName = "", int bAddUnique = FALSE);

// ---< GetListFloat >---
// ---< util_i_varlists >---
// Returns the float at nIndex in oTarget's float list sListName. If no float is
// found at that index, 0.0 is returned.
float GetListFloat(object oTarget, int nIndex = 0, string sListName = "");

// ---< GetListInt >---
// ---< util_i_varlists >---
// Returns the int at nIndex in oTarget's int list sListName. If no int is found
// at that index, 0 is returned.
int GetListInt(object oTarget, int nIndex = 0, string sListName = "");

// ---< GetListLocation >---
// ---< util_i_varlists >---
// Returns the location at nIndex in oTarget's location list sListName. If no
// location is found at that index, an invalid location is returned.
location GetListLocation(object oTarget, int nIndex = 0, string sListName = "");

// ---< GetListVector >---
// ---< util_i_varlists >---
// Returns the vector at nIndex in oTarget's vector list sListName. If no string
// is found at that index, an origin vector is returned (0, 0, 0).
vector GetListVector(object oTarget, int nIndex = 0, string sListName = "");

// ---< GetListObject >---
// ---< util_i_varlists >---
// Returns the object at nIndex in oTarget's object list sListName. If no object
// is found at that index, OBJECT_INVALID is returned.
object GetListObject(object oTarget, int nIndex = 0, string sListName = "");

// ---< GetListString >---
// ---< util_i_varlists >---
// Returns the string at nIndex in oTarget's string list sListName. If no string
// is found at that index, "" is returned.
string GetListString(object oTarget, int nIndex = 0, string sListName = "");

// ---< GetListJson >---
// ---< util_i_varlists >---
// Returns the element at nIndex in oTarget's json list sListName. If no element
// is found at that index, JsonNull() is returned.
json GetListJson(object oTarget, int nIndex = 0, string sListName = "");

// ---< DeleteListFloat >---
// ---< util_i_varlists >---
// Removes the float at nIndex on oTarget's float list sListName and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int DeleteListFloat(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE);

// ---< DeleteListInt >---
// ---< util_i_varlists >---
// Removes the int at nIndex on oTarget's int list sListName and returns
// the number of items remaining in the list. IfbMaintainOrder exists for legacy
// support and is not used.
int DeleteListInt(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE);

// ---< DeleteListLocation >---
// ---< util_i_varlists >---
// Removes the location at nIndex on oTarget's location list sListName and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int DeleteListLocation(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE);

// ---< DeleteListVector >---
// ---< util_i_varlists >---
// Removes the vector at nIndex on oTarget's vector list sListName and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int DeleteListVector(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE);

// ---< DeleteListObject >---
// ---< util_i_varlists >---
// Removes the object at nIndex on oTarget's object list sListName and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int DeleteListObject(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE);

// ---< DeleteListString >---
// ---< util_i_varlists >---
// Removes the string at nIndex on oTarget's string list sListName and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int DeleteListString(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE);

// ---< DeleteListJson >---
// ---< util_i_varlists >---
// Removes the element at nIndex on oTarget's json list sListName and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int DeleteListJson(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE);

// ---< RemoveListFloat >---
// ---< util_i_varlists >---
// Removes a float of fValue from the float list sListName on oTarget and
// returns the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int RemoveListFloat(object oTarget, float fValue, string sListName = "", int bMaintainOrder = FALSE);

// ---< RemoveListInt >---
// ---< util_i_varlists >---
// Removes the first int of nValue from the int list sListName on oTarget and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int RemoveListInt(object oTarget, int nValue, string sListName = "", int bMaintainOrder = FALSE);

// ---< RemoveListLocation >---
// ---< util_i_varlists >---
// Removes the first location of lValue from the location list sListName on oTarget and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int RemoveListLocation(object oTarget, location lValue, string sListName = "", int bMaintainOrder = FALSE);

// ---< RemoveListVector >---
// ---< util_i_varlists >---
// Removes the first vector of vValue from the vector list sListName on oTarget and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int RemoveListVector(object oTarget, vector vValue, string sListName = "", int bMaintainOrder = FALSE);

// ---< RemoveListObject >---
// ---< util_i_varlists >---
// Removes the first object of oValue from the object list sListName on oTarget and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int RemoveListObject(object oTarget, object oValue, string sListName = "", int bMaintainOrder = FALSE);

// ---< RemoveListString >---
// ---< util_i_varlists >---
// Removes the first string of sValue from the string list sListName on oTarget and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int RemoveListString(object oTarget, string sValue, string sListName = "", int bMaintainOrder = FALSE);

// ---< RemoveListJson >---
// ---< util_i_varlists >---
// Removes the first element of jValue from the json list sListName on oTarget and returns
// the number of items remaining in the list. bMaintainOrder exists for legacy
// support and is not used.
int RemoveListJson(object oTarget, json jValue, string sListName = "", int bMaintainOrder = FALSE);

// ---< FindListFloat >---
// ---< util_i_varlists >---
// Returns the index of the first reference of the float fValue in the float
// list sListName on oTarget. If it is not in the list, returns -1.
int FindListFloat(object oTarget, float fValue, string sListName = "");

// ---< FindListInt >---
// ---< util_i_varlists >---
// Returns the index of the first reference of the int nValue in the int list
// sListName on oTarget. If it is not in the list, returns -1.
int FindListInt(object oTarget, int nValue, string sListName = "");

// ---< FindListLocation >---
// ---< util_i_varlists >---
// Returns the index of the first reference of the location lValue in the
// location list sListName on oTarget. If it is not in the list, returns -1.
int FindListLocation(object oTarget, location lValue, string sListName = "");

// ---< FindListVector >---
// ---< util_i_varlists >---
// Returns the index of the first reference of the vector vValue in the
// location list sListName on oTarget. If it is not in the list, returns -1.
int FindListVector(object oTarget, vector vValue, string sListName = "");

// ---< FindListObject >---
// ---< util_i_varlists >---
// Returns the index of the first reference of the obejct oValue in the object
// list sListName on oTarget. If it is not in the list, returns -1.
int FindListObject(object oTarget, object oValue, string sListName = "");

// ---< FindListString >---
// ---< util_i_varlists >---
// Returns the index of the first reference of the string sValue in the string
// list sListName on oTarget. If it is not in the list, returns -1.
int FindListString(object oTarget, string sValue, string sListName = "");

// ---< FindListJson >---
// ---< util_i_varlists >---
// Returns the index of the first reference of the element jValue in the json
// list sListName on oTarget. If it is not in the list, returns -1.
int FindListJson(object oTarget, json jValue, string sListName = "");

// ---< HasListFloat >---
// ---< util_i_varlists >---
// Returns whether oTarget has a float with the value fValue in its float list
// sListName.
int HasListFloat(object oTarget, float fValue, string sListName = "");

// ---< HasListInt >---
// ---< util_i_varlists >---
// Returns whether oTarget has an int with the value nValue in its int list
// sListName.
int HasListInt(object oTarget, int nValue, string sListName = "");

// ---< HasListLocation >---
// ---< util_i_varlists >---
// Returns whether oTarget has a location with the value lValue in its locaiton
// list sListName.
int HasListLocation(object oTarget, location lValue, string sListName = "");

// ---< HasListVector >---
// ---< util_i_varlists >---
// Returns whether oTarget has a vector with the value vValue in its vector
// list sListName.
int HasListVector(object oTarget, vector vValue, string sListName = "");

// ---< HasListObject >---
// ---< util_i_varlists >---
// Returns whether oTarget has an object with the value oValue in its object
// list sListName.
int HasListObject(object oTarget, object oValue, string sListName = "");

// ---< HasListString >---
// ---< util_i_varlists >---
// Returns whether oTarget has a string with the value sValue in its string list
// sListName.
int HasListString(object oTarget, string sValue, string sListName = "");

// ---< HasListJson >---
// ---< util_i_varlists >---
// Returns whether oTarget has an element with the value jValue in its json list
// sListName.
int HasListJson(object oTarget, json jValue, string sListName = "");

// ---< InsertListFloat >---
// ---< util_i_varlists >---
// Inserts item nIndex in the float list of sListName on oTarget to fValue. If the
// index is at the end of the list, it will be added. If it exceeds the length
// of the list, nothing is added.
int InsertListFloat(object oTarget, int nIndex, float fValue, string sListName = "", int bAddUnique = FALSE);

// ---< InsertListInt >---
// ---< util_i_varlists >---
// Inserts item nIndex in the int list of sListName on oTarget to nValue. If the
// index is at the end of the list, it will be added. If nIndex exceeds the length
// of the list, nothing is added.  If bAddUnique, the insert operation will be
// conducted first, then subsequent duplicate values will be removed, keeping the
// passed nValue at the desired nIndex.
int InsertListInt(object oTarget, int nIndex, int nValue, string sListName = "", int bAddUnique = FALSE);

// ---< InsertListLocation >---
// ---< util_i_varlists >---
// Inserts item nIndex in the location list of sListName on oTarget to lValue. If
// the index is at the end of the list, it will be added. If it exceeds the
// length of the list, nothing is added.  If bAddUnique, the insert operation will be
// conducted first, then subsequent duplicate values will be removed, keeping the
// passed nValue at the desired nIndex.
int InsertListLocation(object oTarget, int nIndex, location lValue, string sListName = "", int bAddUnique = FALSE);

// ---< InsertListVector >---
// ---< util_i_varlists >---
// Inserts item nIndex in the vector list of sListName on oTarget to vValue. If the
// index is at the end of the list, it will be added. If it exceeds the length
// of the list, nothing is added.
int InsertListVector(object oTarget, int nIndex, vector vValue, string sListName = "", int bAddUnique = FALSE);

// ---< InsertListObject >---
// ---< util_i_varlists >---
// Inserts item nIndex in the object list of sListName on oTarget to oValue. If the
// index is at the end of the list, it will be added. If it exceeds the length
// of the list, nothing is added.
int InsertListObject(object oTarget, int nIndex, object oValue, string sListName = "", int bAddUnique = FALSE);

// ---< InsertListString >---
// ---< util_i_varlists >---
// Inserts item nIndex in the string list of sListName on oTarget to sValue. If the
// index is at the end of the list, it will be added. If it exceeds the length
// of the list, nothing is added.
int InsertListString(object oTarget, int nIndex, string sValue, string sListName = "", int bAddUnique = FALSE);

// ---< InsertListJson >---
// ---< util_i_varlists >---
// Inserts item nIndex in the json list of sListName on oTarget to sValue. If the
// index is at the end of the list, it will be added. If it exceeds the length
// of the list, nothing is added.
int InsertListJson(object oTarget, int nIndex, json jValue, string sListName = "", int bAddUnique = FALSE);

// ---< SetListFloat >---
// ---< util_i_varlists >---
// Sets item nIndex in the float list of sListName on oTarget to fValue. If the
// index is at the end of the list, it will be added. If it exceeds the length
// of the list, nothing is added.
void SetListFloat(object oTarget, int nIndex, float fValue, string sListName = "");

// ---< SetListInt >---
// ---< util_i_varlists >---
// Sets item nIndex in the int list of sListName on oTarget to nValue. If the
// index is at the end of the list, it will be added. If it exceeds the length
// of the list, nothing is added.
void SetListInt(object oTarget, int nIndex, int nValue, string sListName = "");

// ---< SetListLocation >---
// ---< util_i_varlists >---
// Sets item nIndex in the location list of sListName on oTarget to lValue. If
// the index is at the end of the list, it will be added. If it exceeds the
// length of the list, nothing is added.
void SetListLocation(object oTarget, int nIndex, location lValue, string sListName = "");

// ---< SetListVector >---
// ---< util_i_varlists >---
// Sets item nIndex in the vector list of sListName on oTarget to vValue. If the
// index is at the end of the list, it will be added. If it exceeds the length
// of the list, nothing is added.
void SetListVector(object oTarget, int nIndex, vector vValue, string sListName = "");

// ---< SetListObject >---
// ---< util_i_varlists >---
// Sets item nIndex in the object list of sListName on oTarget to oValue. If the
// index is at the end of the list, it will be added. If it exceeds the length
// of the list, nothing is added.
void SetListObject(object oTarget, int nIndex, object oValue, string sListName = "");

// ---< SetListString >---
// ---< util_i_varlists >---
// Sets item nIndex in the string list of sListName on oTarget to sValue. If the
// index is at the end of the list, it will be added. If it exceeds the length
// of the list, nothing is added.
void SetListString(object oTarget, int nIndex, string sValue, string sListName = "");

// ---< SetListJson >---
// ---< util_i_varlists >---
// Sets item nIndex in the json list of sListName on oTarget to sValue. If the
// index is at the end of the list, it will be added. If it exceeds the length
// of the list, nothing is added.
void SetListJson(object oTarget, int nIndex, json jValue, string sListName = "");

// ---< CopyListFloat >---
// ---< util_i_varlists >---
// Starting at nIndex, copies nRange items from float list sSourceName on oSource
// and adds them to list sTargetName on oTarget.  Returns the number of list items
// copied to the target list.  If bAddUnique, the copy operation will be conducted
// first, then any duplicate values will be removed.  Values in sTargetName are
// prioritized over duplicate values in sSourceName.
int CopyListFloat(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE);

// ---< CopyListInt >---
// ---< util_i_varlists >---
// Starting at nIndex, copies nRange items from int list sSourceName on oSource
// and adds them to list sTargetName on oTarget.  Returns the number of list items
// copied to the target list.  If bAddUnique, the copy operation will be conducted
// first, then any duplicate values will be removed.  Values in sTargetName are
// prioritized over duplicate values in sSourceName.
int CopyListInt(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE);

// ---< CopyListLocation >---
// ---< util_i_varlists >---
// Starting at nIndex, copies nRange items from location list sSourceName on oSource
// and adds them to list sTargetName on oTarget.  Returns the number of list items
// copied to the target list.  If bAddUnique, the copy operation will be conducted
// first, then any duplicate values will be removed.  Values in sTargetName are
// prioritized over duplicate values in sSourceName.
int CopyListLocation(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE);

// ---< CopyListVector >---
// ---< util_i_varlists >---
// Starting at nIndex, copies nRange items from vector list sSourceName on oSource
// and adds them to list sTargetName on oTarget.  Returns the number of list items
// copied to the target list.  If bAddUnique, the copy operation will be conducted
// first, then any duplicate values will be removed.  Values in sTargetName are
// prioritized over duplicate values in sSourceName.
int CopyListVector(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE);

// ---< CopyListObject >---
// ---< util_i_varlists >---
// Starting at nIndex, copies nRange items from object list sSourceName on oSource
// and adds them to list sTargetName on oTarget.  Returns the number of list items
// copied to the target list.  If bAddUnique, the copy operation will be conducted
// first, then any duplicate values will be removed.  Values in sTargetName are
// prioritized over duplicate values in sSourceName.
int CopyListObject(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE);

// ---< CopyListString >---
// ---< util_i_varlists >---
// Starting at nIndex, copies nRange items from string list sSourceName on oSource
// and adds them to list sTargetName on oTarget.  Returns the number of list items
// copied to the target list.  If bAddUnique, the copy operation will be conducted
// first, then any duplicate values will be removed.  Values in sTargetName are
// prioritized over duplicate values in sSourceName.
int CopyListString(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE);

// ---< CopyListJson >---
// ---< util_i_varlists >---
// Starting at nIndex, copies nRange items from json list sSourceName on oSource
// and adds them to list sTargetName on oTarget.  Returns the number of list items
// copied to the target list.  If bAddUnique, the copy operation will be conducted
// first, then any duplicate values will be removed.  Values in sTargetName are
// prioritized over duplicate values in sSourceName.
int CopyListJson(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE);

// ---< IncrementListInt >---
// ---< util_i_varlists >---
// Increments an integer at nIndex in sListName on oTarget by nIncrement
// and returns the new value.
int IncrementListInt(object oTarget, int nIndex, int nIncrement = 1, string sListName = "");

// ---< DecrementListInt >---
// ---< util_i_varlists >---
// Decrements an integer at nIndex in sListName on oTarget by nDecrement
// and returns the new value.
int DecrementListInt(object oTarget, int nIndex, int nDecrement = -1, string sListName = "");

// ---< GetFloatList >---
// ---< util_i_varlists >---
// Retrieves the float list sListName from oTarget.
// Elements of the returned array can be decoded with
// JsonGetFloat().
json GetFloatList(object oTarget, string sListName = "");

// ---< GetIntList >---
// ---< util_i_varlists >---
// Retrieves the int list sListName from oTarget.
// Elements of the returned array can be decoded with
// JsonGetInt().
json GetIntList(object oTarget, string sListName = "");

// ---< GetLocationList >---
// ---< util_i_varlists >---
// Retrieves the location list sListName from oTarget.
// Elements of the returned array can be decoded with
// GetObjectLocation().
json GetLocationList(object oTarget, string sListName = "");

// ---< GetVectorList >---
// ---< util_i_varlists >---
// Retrieves the vector list sListName from oTarget.
// Elements of the returned array can be decoded with
// GetObjectVector().
json GetVectorList(object oTarget, string sListName = "");

// ---< GetObjectList >---
// ---< util_i_varlists >---
// Retrieves the float list sListName from oTarget.
// Elements of the returned array can be decoded with
// StringToObject().
json GetObjectList(object oTarget, string sListName = "");

// ---< GetStringList >---
// ---< util_i_varlists >---
// Retrieves the float list sListName from oTarget.
// Elements of the returned array can be decoded with
// JsonGetString().
json GetStringList(object oTarget, string sListName = "");

// ---< GetJsonList >---
// ---< util_i_varlists >---
// Retrieves the float list sListName from oTarget.
json GetJsonList(object oTarget, string sListName = "");

// ---< SetFloatList >---
// ---< util_i_varlists >---
// Sets the float list jList as sListName on oTarget.
// jList must be an array of floats encoded with JsonFloat().
void SetFloatList(object oTarget, json jList, string sListName = "");

// ---< SetIntList >---
// ---< util_i_varlists >---
// Sets the int list jList as sListName on oTarget.
// jList must be an array of ints encoded with JsonInt().
void SetIntList(object oTarget, json jList, string sListName = "");

// ---< SetLocationList >---
// ---< util_i_varlists >---
// Sets the location list jList as sListName on oTarget.
// jList must be an array of location objects. A location object 
// can be encoded by passing a location to GetLocationObject().
void SetLocationList(object oTarget, json jList, string sListName = "");

// ---< SetVectorList >---
// ---< util_i_varlists >---
// Sets the vector list jList as sListName on oTarget.
// jList must be an array of vector objects. A vector object
// can be encoded by passing a vector to GetVectorObject()..
void SetVectorList(object oTarget, json jList, string sListName = "");

// ---< SetObjectList >---
// ---< util_i_varlists >---
// Sets the object list jList as sListName on oTarget.
// jList must be an array of object IDs created with
// ObjectToString() and encoded via JsonString().
void SetObjectList(object oTarget, json jList, string sListName = "");

// ---< SetStringList >---
// ---< util_i_varlists >---
// Sets the string list jList as sListName on oTarget.
// jList must be an array of strings created with JsonString().
void SetStringList(object oTarget, json jList, string sListName = "");

// ---< SetJsonList >---
// ---< util_i_varlists >---
// Sets the float list jList as sListName on oTarget.
// jList can be any collection of json objects.
void SetJsonList(object oTarget, json jList, string sListName = "");

// ---< DeleteFloatList >---
// ---< util_i_varlists >---
// Deletes the float list sListName from oTarget.
void DeleteFloatList(object oTarget, string sListName = "");

// ---< DeleteIntList >---
// ---< util_i_varlists >---
// Deletes the int list sListName from oTarget.
void DeleteIntList(object oTarget, string sListName = "");

// ---< DeleteLocationList >---
// ---< util_i_varlists >---
// Deletes the location list sListName from oTarget.
void DeleteLocationList(object oTarget, string sListName = "");

// ---< DeleteVectorList >---
// ---< util_i_varlists >---
// Deletes the vector list sListName from oTarget.
void DeleteVectorList(object oTarget, string sListName = "");

// ---< DeleteObjectList >---
// ---< util_i_varlists >---
// Deletes the object list sListName from oTarget.
void DeleteObjectList(object oTarget, string sListName = "");

// ---< DeleteStringList >---
// ---< util_i_varlists >---
// Deletes the string list sListName from oTarget.
void DeleteStringList(object oTarget, string sListName = "");

// ---< DeleteJsonList >---
// ---< util_i_varlists >---
// Deletes the json list sListName from oTarget.
void DeleteJsonList(object oTarget, string sListName = "");

// ---< DeclareFloatList >---
// ---< util_i_varlists >---
// Creates a float list of sListName on oTarget with nCount fDefault items. If
// oTarget already had a list with this name, that list is deleted before the
// new one is created.
json DeclareFloatList(object oTarget, int nCount, string sListName = "", float fDefault = 0.0);

// ---< DeclareIntList >---
// ---< util_i_varlists >---
// Creates an int list of sListName on oTarget with nCount nDefault items. If
// oTarget already had a list with this name, that list is deleted before the
// new one is created.
json DeclareIntList(object oTarget, int nCount, string sListName = "", int nDefault = 0);

// ---< DeclareLocationList >---
// ---< util_i_varlists >---
// Creates a location list of sListName on oTarget with nCount null items. If
// oTarget already had a list with this name, that list is deleted before the
// new one is created.
json DeclareLocationList(object oTarget, int nCount, string sListName = "");

// ---< DeclareVectorList >---
// ---< util_i_varlists >---
// Creates a vector list of sListName on oTarget with nCount null items. If
// oTarget already had a list with this name, that list is deleted before the
// new one is created.
json DeclareVectorList(object oTarget, int nCount, string sListName = "");

// ---< DeclareObjectList >---
// ---< util_i_varlists >---
// Creates an object list of sListName on oTarget with nCount null items. If
// oTarget already had a list with this name, that list is deleted before the
// new one is created.
json DeclareObjectList(object oTarget, int nCount, string sListName = "");

// ---< DeclareStringList >---
// ---< util_i_varlists >---
// Creates a string list of sListName on oTarget with nCount sDefault items. If
// oTarget already had a list with this name, that list is deleted before the
// new one is created.
json DeclareStringList(object oTarget, int nCount, string sListName = "", string sDefault = "");

// ---< DeclareJsonList >---
// ---< util_i_varlists >---
// Creates a json list of sListName on oTarget with nCount null items. If
// oTarget already had a list with this name, that list is deleted before the
// new one is created.
json DeclareJsonList(object oTarget, int nCount, string sListName = "");

// ---< NormalizeFloatList >---
// ---< util_i_varlists >---
// Sets length of float list sListName on oTarget to nCount.  If nCount is less
// than the current list length, the list is shortened.  If nCount is greater than
// the current list length, fDefault elements are added to the list until the list
// is the desired length.  If the list doesn't exist, this function mimics
// DeclareFloatList().
json NormalizeFloatList(object oTarget, int nCount, string sListName = "", float fDefault = 0.0);

// ---< NormalizeIntList >---
// ---< util_i_varlists >---
// Sets length of int list sListName on oTarget to nCount.  If nCount is less
// than the current list length, the list is shortened.  If nCount is greater than
// the current list length, nDefault elements are added to the list until the list
// is the desired length.  If the list doesn't exist, this function mimics
// DeclareIntList().
json NormalizeIntList(object oTarget, int nCount, string sListName = "", int nDefault = 0);

// ---< NormalizeLocationList >---
// ---< util_i_varlists >---
// Sets length of location list sListName on oTarget to nCount.  If nCount is less
// than the current list length, the list is shortened.  If nCount is greater than
// the current list length, JsonNull() elements are added to the list until the list
// is the desired length.  If the list doesn't exist, this function mimics
// DeclareLocationList().
json NormalizeLocationList(object oTarget, int nCount, string sListName = "");

// ---< NormalizeVectorList >---
// ---< util_i_varlists >---
// Sets length of vector list sListName on oTarget to nCount.  If nCount is less
// than the current list length, the list is shortened.  If nCount is greater than
// the current list length, JsonNull() elements are added to the list until the list
// is the desired length.  If the list doesn't exist, this function mimics
// DeclareVectorList().
json NormalizeVectorList(object oTarget, int nCount, string sListName = "");

// ---< NormalizeObjectList >---
// ---< util_i_varlists >---
// Sets length of object list sListName on oTarget to nCount.  If nCount is less
// than the current list length, the list is shortened.  If nCount is greater than
// the current list length, JsonNull() elements are added to the list until the list
// is the desired length.  If the list doesn't exist, this function mimics
// DeclareObjectList().
json NormalizeObjectList(object oTarget, int nCount, string sListName = "");

// ---< NormalizeStringList >---
// ---< util_i_varlists >---
// Sets length of string list sListName on oTarget to nCount.  If nCount is less
// than the current list length, the list is shortened.  If nCount is greater than
// the current list length, sDefault elements are added to the list until the list
// is the desired length.  If the list doesn't exist, this function mimics
// DeclareStringList().
json NormalizeStringList(object oTarget, int nCount, string sListName = "", string sDefault = "");

// ---< NormalizeJsonList >---
// ---< util_i_varlists >---
// Sets length of json list sListName on oTarget to nCount.  If nCount is less
// than the current list length, the list is shortened.  If nCount is greater than
// the current list length, JsonNull() elements are added to the list until the list
// is the desired length.  If the list doesn't exist, this function mimics
// DeclareJsonList().
json NormalizeJsonList(object oTarget, int nCount, string sListName = "");

// ---< CopyFloatList >---
// ---< util_i_varlists >---
// Copies the float list sSourceName from oSource to oTarget, renamed
// sTargetName. If bAddUnique is TRUE, will only copy items from the source list
// that are not already present in the target list.
void CopyFloatList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE);

// ---< CopyIntList >---
// ---< util_i_varlists >---
// Copies the int list sSourceName from oSource to oTarget, renamed sTargetName.
// If bAddUnique is TRUE, will only copy items from the source list that are not
// already present in the target list.
void CopyIntList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE);

// ---< CopyLocationList >---
// ---< util_i_varlists >---
// Copies the location list sSourceName from oSource to oTarget, renamed
// sTargetName. If bAddUnique is TRUE, will only copy items from the source list
// that are not already present in the target list.
void CopyLocationList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE);

// ---< CopyVectorList >---
// ---< util_i_varlists >---
// Copies the vector list sSourceName from oSource to oTarget, renamed
// sTargetName. If bAddUnique is TRUE, will only copy items from the source list
// that are not already present in the target list.
void CopyVectorList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE);

// ---< CopyObjectList >---
// ---< util_i_varlists >---
// Copies the object list sSourceName from oSource to oTarget, renamed
// sTargetName. If bAddUnique is TRUE, will only copy items from the source list
// that are not already present in the target list.
void CopyObjectList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE);

// ---< CopyStringList >---
// ---< util_i_varlists >---
// Copies the string list sSourceName from oSource to oTarget, renamed
// sTargetName. If bAddUnique is TRUE, will only copy items from the source list
// that are not already present in the target list.
void CopyStringList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE);

// ---< CopyJsonList >---
// ---< util_i_varlists >---
// Copies the json list sSourceName from oSource to oTarget, renamed
// sTargetName. If bAddUnique is TRUE, will only copy items from the source list
// that are not already present in the target list.
void CopyJsonList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE);

// ---< CountFloatList >---
// ---< util_i_varlists >---
// Returns the number of items in oTarget's float list sListName.
int CountFloatList(object oTarget, string sListName = "");

// ---< CountIntList >---
// ---< util_i_varlists >---
// Returns the number of items in oTarget's int list sListName.
int CountIntList(object oTarget, string sListName = "");

// ---< CountLocationList >---
// ---< util_i_varlists >---
// Returns the number of items in oTarget's location list sListName.
int CountLocationList(object oTarget, string sListName = "");

// ---< CountVectorList >---
// ---< util_i_varlists >---
// Returns the number of items in oTarget's vector list sListName.
int CountVectorList(object oTarget, string sListName = "");

// ---< CountObjectList >---
// ---< util_i_varlists >---
// Returns the number of items in oTarget's object list sListName.
int CountObjectList(object oTarget, string sListName = "");

// ---< CountStringList >---
// ---< util_i_varlists >---
// Returns the number of items in oTarget's string list sListName.
int CountStringList(object oTarget, string sListName = "");

// ---< CountJsonList >---
// ---< util_i_varlists >---
// Returns the number of items in oTarget's json list sListName.
int CountJsonList(object oTarget, string sListName = "");

// ---< SortFloatList >---
// ---< util_i_varlists >---
// Sorts float list sListName on oTarget in nOrder order.
void SortFloatList(object oTarget, int nOrder = LIST_SORT_ASC, string sListName = "");

// ---< SortIntList >---
// ---< util_i_varlists >---
// Sorts int list sListName on oTarget in nOrder order.
void SortIntList(object oTarget, int nOrder = LIST_SORT_ASC, string sListName = "");

// ---< SortStringList >---
// ---< util_i_varlists >---
// Sorts string list sListName on oTarget in nOrder order.
void SortStringList(object oTarget, int nOrder = LIST_SORT_ASC, string sListName = "");

// ---< ShuffleFloatList >---
// ---< util_i_varlists >---
// Shuffles float list sListName on oTarget.
void ShuffleFloatList(object oTarget, string sListName = "");

// ---< ShuffleIntList >---
// ---< util_i_varlists >---
// Shuffles int list sListName on oTarget.
void ShuffleIntList(object oTarget, string sListName = "");

// ---< ShuffleLocationList >---
// ---< util_i_varlists >---
// Shuffles location list sListName on oTarget.
void ShuffleLocationList(object oTarget, string sListName = "");

// ---< ShuffleVectorList >---
// ---< util_i_varlists >---
// Shuffles vector list sListName on oTarget.
void ShuffleVectorList(object oTarget, string sListName = "");

// ---< ShuffleObjectList >---
// ---< util_i_varlists >---
// Shuffles object list sListName on oTarget.
void ShuffleObjectList(object oTarget, string sListName = "");

// ---< ShuffleStringList >---
// ---< util_i_varlists >---
// Shuffles string list sListName on oTarget.
void ShuffleStringList(object oTarget, string sListName = "");

// ---< ShuffleJsonList >---
// ---< util_i_varlists >---
// Shuffles json list sListName on oTarget.
void ShuffleJsonList(object oTarget, string sListName = "");

// ---< ReverseFloatList >---
// ---< util_i_varlists >---
// Reverses float list sListName on oTarget.
void ReverseFloatList(object oTarget, string sListName = "");

// ---< ReverseIntList >---
// ---< util_i_varlists >---
// Reverses int list sListName on oTarget.
void ReverseIntList(object oTarget, string sListName = "");

// ---< ReverseLocationList >---
// ---< util_i_varlists >---
// Reverses location list sListName on oTarget.
void ReverseLocationList(object oTarget, string sListName = "");

// ---< ReverseVectorList >---
// ---< util_i_varlists >---
// Reverses vector list sListName on oTarget.
void ReverseVectorList(object oTarget, string sListName = "");

// ---< ReverseObjectList >---
// ---< util_i_varlists >---
// Reverses object list sListName on oTarget.
void ReverseObjectList(object oTarget, string sListName = "");

// ---< ReverseStringList >---
// ---< util_i_varlists >---
// Reverses string list sListName on oTarget.
void ReverseStringList(object oTarget, string sListName = "");

// ---< ReverseJsonList >---
// ---< util_i_varlists >---
// Reverses json list sListName on oTarget.
void ReverseJsonList(object oTarget, string sListName = "");

// -----------------------------------------------------------------------------
//                           Function Implementations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                              Private Functions
// -----------------------------------------------------------------------------

// Determines whether nIndex is a valid reference to an array element in jList.
// If bNegative is TRUE, -1 will be returned as a valid nIndex value.
int _GetIsIndexValid(json jList, int nIndex, int bNegative = FALSE)
{
    return nIndex >= (0 - bNegative) && nIndex < JsonGetLength(jList);
}

// Retrieves json array sListName of sListType from oTarget.
json _GetList(object oTarget, string sListType, string sListName = "")
{
    json jList = GetLocalJson(oTarget, LIST_REF + sListType + sListName);
    return jList == JsonNull() ? JsonArray() : jList;
}

// Sets sListType json array jList as sListName on oTarget.
void _SetList(object oTarget, string sListType, string sListName, json jList)
{
    SetLocalJson(oTarget, LIST_REF + sListType + sListName, jList);
}

// Deletes sListType json array sListName from oTarget.
void _DeleteList(object oTarget, string sListType, string sListName)
{
    DeleteLocalJson(oTarget, LIST_REF + sListType + sListName);
}

// Inserts array element jValue into json array sListName at nIndex on oTarget.
// Returns the number of elements in the array after insertion.  If bUnique is
// TRUE, duplicate values with be removed after the insert operation.
int _InsertListElement(object oTarget, string sListType, string sListName,
                       json jValue, int nIndex, int bUnique)
{
    json jList = _GetList(oTarget, sListType, sListName);

    if (_GetIsIndexValid(jList, nIndex, TRUE) == TRUE)
    {
        jList = JsonArrayInsert(jList, jValue, nIndex);

        if (bUnique == TRUE)
            jList = JsonArrayTransform(jList, JSON_ARRAY_UNIQUE);

        _SetList(oTarget, sListType, sListName, jList);
    }

    return JsonGetLength(jList);
}

// Returns array element at nIndex from array sListName on oTarget.  If not
// found, returns JsonNull().
json _GetListElement(object oTarget, string sListType, string sListName, int nIndex)
{
    json jList = _GetList(oTarget, sListType, sListName);
    return _GetIsIndexValid(jList, nIndex) == TRUE ?
                JsonArrayGet(jList, nIndex) :
                JsonNull();
}

// Deletes array element at nIndex from array sListName on oTarget.  Element order
// is maintained.  Returns the number of array elements remaining after deletion.
int _DeleteListElement(object oTarget, string sListType, string sListName, int nIndex)
{
    json jList = _GetList(oTarget, sListType, sListName);

    if (_GetIsIndexValid(jList, nIndex) == TRUE && JsonGetLength(jList) > 0)
    {
        jList = JsonArrayDel(jList, nIndex);
        _SetList(oTarget, sListType, sListName, jList);
    }

    return JsonGetLength(jList);
}

// Finds array element jValue in array sListName on oTarget.  If found, returns the
// index of the elements.  If not, returns -1.
int _FindListElement(object oTarget, string sListType, string sListName, json jValue)
{
    json jList = _GetList(oTarget, sListType, sListName);
    json jIndex = JsonFind(jList, jValue, 0, JSON_FIND_EQUAL);
    return jIndex == JsonNull() ? -1 : JsonGetInt(jIndex);
}

// Deletes array element jValue from array sListName on oTarget.  Element order
// is maintained.  Returns the number of array elements remaining after deletion.
int _RemoveListElement(object oTarget, string sListType, string sListName, json jValue)
{
    json jList = _GetList(oTarget, sListType, sListName);
    int nIndex = _FindListElement(oTarget, sListType, sListName, jValue);

    if (nIndex > -1)
    {
        jList = JsonArrayDel(jList, nIndex);
        _SetList(oTarget, sListType, sListName, JsonArrayDel(jList, nIndex));
    }

    return JsonGetLength(jList);
}

// Finds array element jValue in array sListName on oTarget.  Returns TRUE if found,
// FALSE otherwise.
int _HasListElement(object oTarget, string sListType, string sListName, json jValue)
{
    return _FindListElement(oTarget, sListType, sListName, jValue) > -1;
}

// Replaces array element at nIndex in array sListName on oTarget with jValue.
void _SetListElement(object oTarget, string sListType, string sListName, int nIndex, json jValue)
{
    json jList = _GetList(oTarget, sListType, sListName);

    if (_GetIsIndexValid(jList, nIndex) == TRUE)
        _SetList(oTarget, sListType, sListName, JsonArraySet(jList, nIndex, jValue));
}

// This procedure exists because current json operations cannot easily append a list without
// removing duplicate elements or auto-sorting the list.  BD is expected to update json
// functions with an append option.  If so, replace this function with the json append
// function from nwscript.nss or fold this into _SortList() below.
json _JsonArrayAppend(json jFrom, json jTo)
{
    string sFrom = JsonDump(jFrom);
    string sTo = JsonDump(jTo);

    sFrom = GetStringRight(sFrom, GetStringLength(sFrom) - 1);
    sTo = GetStringLeft(sTo, GetStringLength(sTo) - 1);

    int nFrom = JsonGetLength(jFrom);
    int nTo = JsonGetLength(jTo);

    string s = (nTo == 0 ? "" :
                nTo > 0 && nFrom == 0 ? "" : ",");

    return JsonParse(sTo + s + sFrom);
}

// Copies specified elements from oSource array sSourceName to oTarget array sTargetName.
// Copied elements start at nIndex and continue for nRange elements.  Elements copied from
// oSource are appended to the end of oTarget's array.
int _CopyListElements(object oSource, object oTarget, string sListType, string sSourceName, 
                      string sTargetName, int nIndex, int nRange, int bUnique)
{
    json jSource = _GetList(oSource, sListType, sSourceName);
    json jTarget = _GetList(oTarget, sListType, sTargetName);
    
    if (jTarget == JsonNull())
        jTarget = JsonArray();

    int nSource = JsonGetLength(jSource);
    int nTarget = JsonGetLength(jTarget);

    if (nSource == 0) return 0;

    json jCopy, jReturn;

    if (nIndex == 0 && (nRange == -1 || nRange >= nSource))
    {
        if (jSource == JsonNull() || nSource == 0)
            return 0;

        jReturn = _JsonArrayAppend(jSource, jTarget);
        if (bUnique == TRUE)
            jReturn = JsonArrayTransform(jReturn, JSON_ARRAY_UNIQUE);

        _SetList(oTarget, sListType, sTargetName, jReturn);
        return nSource;
    }

    if (_GetIsIndexValid(jSource, nIndex) == TRUE)
    {
        int nMaxIndex = nSource - nIndex;
        if (nRange == -1)
            nRange = nMaxIndex;
        else if (nRange > (nMaxIndex))
            nRange = clamp(nRange, 1, nMaxIndex);

        jCopy = JsonArrayGetRange(jSource, nIndex, nIndex + (nRange - 1));
        jReturn = _JsonArrayAppend(jTarget, jCopy);
        if (bUnique == TRUE)
            jReturn = JsonArrayTransform(jReturn, JSON_ARRAY_UNIQUE);

        _SetList(oTarget, sListType, sTargetName, jReturn);
        return JsonGetLength(jCopy) - JsonGetLength(JsonSetOp(jCopy, JSON_SET_INTERSECT, jTarget));
    }

    return 0;
}

// Modifies an int list element by nIncrement and returns the new value.
int _IncrementListElement(object oTarget, string sListName, int nIndex, int nIncrement)
{
    json jList = _GetList(oTarget, VARLIST_TYPE_INT, sListName);
    
    if (_GetIsIndexValid(jList, nIndex))
    {
        int nValue = JsonGetInt(JsonArrayGet(jList, nIndex)) + nIncrement;
        jList = JsonArraySet(jList, nIndex, JsonInt(nValue));
        _SetList(oTarget, VARLIST_TYPE_INT, sListName, jList);

        return nValue;
    }

    return 0;
}

// Creates an array of length nLength jDefault elements as sListName on oTarget.
json _DeclareList(object oTarget, string sListType, string sListName, int nLength, json jDefault)
{
    json jList = JsonArray();
    
    int n;
    for (n = 0; n < nLength; n++)
        jList = JsonArrayInsert(jList, jDefault);

    _SetList(oTarget, sListType, sListName, jList);
    return jList;
}

// Sets the array length to nLength, adding/removing elements as required.
json _NormalizeList(object oTarget, string sListType, string sListName, int nLength, json jDefault)
{
    json jList = _GetList(oTarget, sListType, sListName);
    if (jList == JsonArray())
        return _DeclareList(oTarget, sListType, sListName, nLength, jDefault);
    else if (nLength < 0)
        return jList;
    else
    {
        int n, nList = JsonGetLength(jList);
        if (nList > nLength)
            jList = JsonArrayGetRange(jList, 0, nLength - 1);
        else
        {
            for (n = 0; n < nLength - nList; n++)
                jList = JsonArrayInsert(jList, jDefault);
        }

        _SetList(oTarget, sListType, sListName, jList);
    }

    return jList;
}

// Returns the length of array sListName on oTarget.
int _CountList(object oTarget, string sListType, string sListName)
{
    return JsonGetLength(_GetList(oTarget, sListType, sListName));
}

// Sorts sListName on oTarget in order specified by nOrder.
void _SortList(object oTarget, string sListType, string sListName, int nOrder)
{
    json jList = _GetList(oTarget, sListType, sListName);

    if (JsonGetLength(jList) > 1)
        _SetList(oTarget, sListType, sListName, JsonArrayTransform(jList, nOrder));
}

// -----------------------------------------------------------------------------
//                              Public Functions
// -----------------------------------------------------------------------------

json GetVectorObject(vector vPosition = [0.0, 0.0, 0.0])
{
    json jPosition = JsonObject();
         jPosition = JsonObjectSet(jPosition, "x", JsonFloat(vPosition.x));
         jPosition = JsonObjectSet(jPosition, "y", JsonFloat(vPosition.y));
    return           JsonObjectSet(jPosition, "z", JsonFloat(vPosition.z));
}

vector GetObjectVector(json jPosition)
{
    float x = JsonGetFloat(JsonObjectGet(jPosition, "x"));
    float y = JsonGetFloat(JsonObjectGet(jPosition, "y"));
    float z = JsonGetFloat(JsonObjectGet(jPosition, "z"));

    return Vector(x, y, z);
}

json GetLocationObject(location lLocation)
{
    json jLocation = JsonObject();
         jLocation = JsonObjectSet(jLocation, "area", JsonString(ObjectToString(GetAreaFromLocation(lLocation))));
         jLocation = JsonObjectSet(jLocation, "position", GetVectorObject(GetPositionFromLocation(lLocation)));
    return           JsonObjectSet(jLocation, "facing", JsonFloat(GetFacingFromLocation(lLocation)));
}

location GetObjectLocation(json jLocation)
{
    object oArea = StringToObject(JsonGetString(JsonObjectGet(jLocation, "area")));
    vector vPosition = GetObjectVector(JsonObjectGet(jLocation, "position"));
    float fFacing = JsonGetFloat(JsonObjectGet(jLocation, "facing"));
    
    return Location(oArea, vPosition, fFacing);
}

int AddListFloat(object oTarget, float fValue, string sListName = "", int bAddUnique = FALSE)
{
    return _InsertListElement(oTarget, VARLIST_TYPE_FLOAT, sListName, JsonFloat(fValue), -1, bAddUnique);
}

int AddListInt(object oTarget, int nValue, string sListName = "", int bAddUnique = FALSE)
{
    return _InsertListElement(oTarget, VARLIST_TYPE_INT, sListName, JsonInt(nValue), -1, bAddUnique);
}

int AddListLocation(object oTarget, location lValue, string sListName = "", int bAddUnique = FALSE)
{
    json jLocation = GetLocationObject(lValue);
    return _InsertListElement(oTarget, VARLIST_TYPE_LOCATION, sListName, jLocation, -1, bAddUnique);
}

int AddListVector(object oTarget, vector vValue, string sListName = "", int bAddUnique = FALSE)
{
    json jVector = GetVectorObject(vValue);
    return _InsertListElement(oTarget, VARLIST_TYPE_VECTOR, sListName, jVector, -1, bAddUnique);
}

int AddListObject(object oTarget, object oValue, string sListName = "", int bAddUnique = FALSE)
{
    json jObject = JsonString(ObjectToString(oValue));
    return _InsertListElement(oTarget, VARLIST_TYPE_OBJECT, sListName, jObject, -1, bAddUnique);
}

int AddListString(object oTarget, string sString, string sListName = "", int bAddUnique = FALSE)
{
    return _InsertListElement(oTarget, VARLIST_TYPE_STRING, sListName, JsonString(sString), -1, bAddUnique);
}

int AddListJson(object oTarget, json jValue, string sListName = "", int bAddUnique = FALSE)
{
    return _InsertListElement(oTarget, VARLIST_TYPE_JSON, sListName, jValue, -1, bAddUnique);
}

float GetListFloat(object oTarget, int nIndex = 0, string sListName = "")
{
    json jValue = _GetListElement(oTarget, VARLIST_TYPE_FLOAT, sListName, nIndex);
    return jValue == JsonNull() ? 0.0 : JsonGetFloat(jValue);
}

int GetListInt(object oTarget, int nIndex = 0, string sListName = "")
{
    json jValue = _GetListElement(oTarget, VARLIST_TYPE_INT, sListName, nIndex);
    return jValue == JsonNull() ? -1 : JsonGetInt(jValue);
}

location GetListLocation(object oTarget, int nIndex = 0, string sListName = "")
{
    json jValue = _GetListElement(oTarget, VARLIST_TYPE_LOCATION, sListName, nIndex);
    
    if (jValue == JsonNull())
        return Location(OBJECT_INVALID, Vector(), 0.0);
    else
        return GetObjectLocation(jValue);
}

vector GetListVector(object oTarget, int nIndex = 0, string sListName = "")
{
    json jValue = _GetListElement(oTarget, VARLIST_TYPE_VECTOR, sListName, nIndex);
    
    if (jValue == JsonNull())
        return Vector();
    else
        return GetObjectVector(jValue);
}

object GetListObject(object oTarget, int nIndex = 0, string sListName = "")
{   
    json jValue = _GetListElement(oTarget, VARLIST_TYPE_OBJECT, sListName, nIndex);
    return jValue == JsonNull() ? OBJECT_INVALID : StringToObject(JsonGetString(jValue));
}

string GetListString(object oTarget, int nIndex = 0, string sListName = "")
{
    json jValue = _GetListElement(oTarget, VARLIST_TYPE_STRING, sListName, nIndex);
    return jValue == JsonNull() ? "" : JsonGetString(jValue);
}

json GetListJson(object oTarget, int nIndex = 0, string sListName = "")
{
    return _GetListElement(oTarget, VARLIST_TYPE_JSON, sListName, nIndex);
}

int DeleteListFloat(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE)
{
    return _DeleteListElement(oTarget, VARLIST_TYPE_FLOAT, sListName, nIndex);
}

int DeleteListInt(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE)
{
    return _DeleteListElement(oTarget, VARLIST_TYPE_INT, sListName, nIndex);
}

int DeleteListLocation(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE)
{
    return _DeleteListElement(oTarget, VARLIST_TYPE_LOCATION, sListName, nIndex);
}

int DeleteListVector(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE)
{
    return _DeleteListElement(oTarget, VARLIST_TYPE_VECTOR, sListName, nIndex);
}

int DeleteListObject(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE)
{
    return _DeleteListElement(oTarget, VARLIST_TYPE_OBJECT, sListName, nIndex);
}

int DeleteListString(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE)
{
    return _DeleteListElement(oTarget, VARLIST_TYPE_STRING, sListName, nIndex);
}

int DeleteListJson(object oTarget, int nIndex, string sListName = "", int bMaintainOrder = FALSE)
{
    return _DeleteListElement(oTarget, VARLIST_TYPE_JSON, sListName, nIndex);
}

int RemoveListFloat(object oTarget, float fValue, string sListName = "", int bMaintainOrder = FALSE)
{
    return _RemoveListElement(oTarget, VARLIST_TYPE_FLOAT, sListName, JsonFloat(fValue));
}

int RemoveListInt(object oTarget, int nValue, string sListName = "", int bMaintainOrder = FALSE)
{
    return _RemoveListElement(oTarget, VARLIST_TYPE_INT, sListName, JsonInt(nValue)); 
}

int RemoveListLocation(object oTarget, location lValue, string sListName = "", int bMaintainOrder = FALSE)
{
    json jLocation = GetLocationObject(lValue);
    return _RemoveListElement(oTarget, VARLIST_TYPE_LOCATION, sListName, jLocation);
}

int RemoveListVector(object oTarget, vector vValue, string sListName = "", int bMaintainOrder = FALSE)
{
    json jVector = GetVectorObject(vValue);
    return _RemoveListElement(oTarget, VARLIST_TYPE_VECTOR, sListName, jVector);
}

int RemoveListObject(object oTarget, object oValue, string sListName = "", int bMaintainOrder = FALSE)
{
    json jObject = JsonString(ObjectToString(oValue));
    return _RemoveListElement(oTarget, VARLIST_TYPE_OBJECT, sListName, jObject);
}

int RemoveListString(object oTarget, string sValue, string sListName = "", int bMaintainOrder = FALSE)
{
    return _RemoveListElement(oTarget, VARLIST_TYPE_STRING, sListName, JsonString(sValue));
}

int RemoveListJson(object oTarget, json jValue, string sListName = "", int bMaintainOrder = FALSE)
{
    return _RemoveListElement(oTarget, VARLIST_TYPE_JSON, sListName, jValue);
}

int FindListFloat(object oTarget, float fValue, string sListName = "")
{
    return _FindListElement(oTarget, VARLIST_TYPE_FLOAT, sListName, JsonFloat(fValue));
}

int FindListInt(object oTarget, int nValue, string sListName = "")
{
    return _FindListElement(oTarget, VARLIST_TYPE_INT, sListName, JsonInt(nValue));
}

int FindListLocation(object oTarget, location lValue, string sListName = "")
{
    json jLocation = GetLocationObject(lValue);
    return _FindListElement(oTarget, VARLIST_TYPE_LOCATION, sListName, jLocation);
}

int FindListVector(object oTarget, vector vValue, string sListName = "")
{
    json jVector = GetVectorObject(vValue);
    return _FindListElement(oTarget, VARLIST_TYPE_VECTOR, sListName, jVector);
}

int FindListObject(object oTarget, object oValue, string sListName = "")
{
    json jObject = JsonString(ObjectToString(oValue));
    return _FindListElement(oTarget, VARLIST_TYPE_OBJECT, sListName, jObject);
}

int FindListString(object oTarget, string sValue, string sListName = "")
{
    return _FindListElement(oTarget, VARLIST_TYPE_STRING, sListName, JsonString(sValue));
}

int FindListJson(object oTarget, json jValue, string sListName = "")
{
    return _FindListElement(oTarget, VARLIST_TYPE_JSON, sListName, jValue);
}

int HasListFloat(object oTarget, float fValue, string sListName = "")
{
    return FindListFloat(oTarget, fValue, sListName) != -1;
}

int HasListInt(object oTarget, int nValue, string sListName = "")
{
    return FindListInt(oTarget, nValue, sListName) != -1;
}

int HasListLocation(object oTarget, location lValue, string sListName = "")
{
    return FindListLocation(oTarget, lValue, sListName) != -1;
}

int HasListVector(object oTarget, vector vValue, string sListName = "")
{
    return FindListVector(oTarget, vValue, sListName) != -1;
}

int HasListObject(object oTarget, object oValue, string sListName = "")
{
    return FindListObject(oTarget, oValue, sListName) != -1;
}

int HasListString(object oTarget, string sValue, string sListName = "")
{
    return FindListString(oTarget, sValue, sListName) != -1;
}

int HasListJson(object oTarget, json jValue, string sListName = "")
{
    return FindListJson(oTarget, jValue, sListName) != -1;
}

int InsertListFloat(object oTarget, int nIndex, float fValue, string sListName = "", int bAddUnique = FALSE)
{
    return _InsertListElement(oTarget, VARLIST_TYPE_FLOAT, sListName, JsonFloat(fValue), nIndex, bAddUnique);
}

int InsertListInt(object oTarget, int nIndex, int nValue, string sListName = "", int bAddUnique = FALSE)
{
    return _InsertListElement(oTarget, VARLIST_TYPE_INT, sListName, JsonInt(nValue), nIndex, bAddUnique);
}

int InsertListLocation(object oTarget, int nIndex, location lValue, string sListName = "", int bAddUnique = FALSE)
{
    json jLocation = GetLocationObject(lValue);
    return _InsertListElement(oTarget, VARLIST_TYPE_LOCATION, sListName, jLocation, nIndex, bAddUnique);
}

int InsertListVector(object oTarget, int nIndex, vector vValue, string sListName = "", int bAddUnique = FALSE)
{
    json jVector = GetVectorObject(vValue);
    return _InsertListElement(oTarget, VARLIST_TYPE_VECTOR, sListName, jVector, nIndex, bAddUnique);
}

int InsertListObject(object oTarget, int nIndex, object oValue, string sListName = "", int bAddUnique = FALSE)
{
    json jObject = JsonString(ObjectToString(oValue));
    return _InsertListElement(oTarget, VARLIST_TYPE_OBJECT, sListName, jObject, nIndex, bAddUnique);
}

int InsertListString(object oTarget, int nIndex, string sValue, string sListName = "", int bAddUnique = FALSE)
{
    return _InsertListElement(oTarget, VARLIST_TYPE_STRING, sListName, JsonString(sValue), nIndex, bAddUnique);
}

int InsertListJson(object oTarget, int nIndex, json jValue, string sListName = "", int bAddUnique = FALSE)
{
    return _InsertListElement(oTarget, VARLIST_TYPE_JSON, sListName, jValue, nIndex, bAddUnique);
}

void SetListFloat(object oTarget, int nIndex, float fValue, string sListName = "")
{
    _SetListElement(oTarget, VARLIST_TYPE_FLOAT, sListName, nIndex, JsonFloat(fValue));
}

void SetListInt(object oTarget, int nIndex, int nValue, string sListName = "")
{
    _SetListElement(oTarget, VARLIST_TYPE_INT, sListName, nIndex, JsonInt(nValue));
}

void SetListLocation(object oTarget, int nIndex, location lValue, string sListName = "")
{
    json jLocation = GetLocationObject(lValue);
    _SetListElement(oTarget, VARLIST_TYPE_LOCATION, sListName, nIndex, jLocation);
}

void SetListVector(object oTarget, int nIndex, vector vValue, string sListName = "")
{
    json jVector = GetVectorObject(vValue);
    _SetListElement(oTarget, VARLIST_TYPE_VECTOR, sListName, nIndex, jVector);
}

void SetListObject(object oTarget, int nIndex, object oValue, string sListName = "")
{
    json jObject = JsonString(ObjectToString(oValue));
    _SetListElement(oTarget, VARLIST_TYPE_OBJECT, sListName, nIndex, jObject);
}

void SetListString(object oTarget, int nIndex, string sValue, string sListName = "")
{
    _SetListElement(oTarget, VARLIST_TYPE_STRING, sListName, nIndex, JsonString(sValue));
}

void SetListJson(object oTarget, int nIndex, json jValue, string sListName = "")
{
    _SetListElement(oTarget, VARLIST_TYPE_JSON, sListName, nIndex, jValue);
}

int CopyListFloat(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE)
{
    return _CopyListElements(oSource, oTarget, VARLIST_TYPE_FLOAT, sSourceName, sTargetName, nIndex, nRange, bAddUnique);
}

int CopyListInt(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE)
{
    return _CopyListElements(oSource, oTarget, VARLIST_TYPE_INT, sSourceName, sTargetName, nIndex, nRange, bAddUnique);
}

int CopyListLocation(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE)
{
    return _CopyListElements(oSource, oTarget, VARLIST_TYPE_LOCATION, sSourceName, sTargetName, nIndex, nRange, bAddUnique);
}

int CopyListVector(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE)
{
    return _CopyListElements(oSource, oTarget, VARLIST_TYPE_VECTOR, sSourceName, sTargetName, nIndex, nRange, bAddUnique);
}

int CopyListObject(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE)
{
    return _CopyListElements(oSource, oTarget, VARLIST_TYPE_OBJECT, sSourceName, sTargetName, nIndex, nRange, bAddUnique);
}

int CopyListString(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE)
{
    return _CopyListElements(oSource, oTarget, VARLIST_TYPE_STRING, sSourceName, sTargetName, nIndex, nRange, bAddUnique);
}

int CopyListJson(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int nRange = 1, int bAddUnique = FALSE)
{
    return _CopyListElements(oSource, oTarget, VARLIST_TYPE_JSON, sSourceName, sTargetName, nIndex, nRange, bAddUnique);
}

int IncrementListInt(object oTarget, int nIndex, int nIncrement = 1, string sListName = "")
{
    return _IncrementListElement(oTarget, sListName, nIndex, nIncrement);
}

int DecrementListInt(object oTarget, int nIndex, int nDecrement = -1, string sListName = "")
{
    return _IncrementListElement(oTarget, sListName, nIndex, nDecrement);
}

json GetFloatList(object oTarget, string sListName = "")
{
    return _GetList(oTarget, VARLIST_TYPE_FLOAT, sListName);
}

json GetIntList(object oTarget, string sListName = "")
{
    return _GetList(oTarget, VARLIST_TYPE_INT, sListName);
}

json GetLocationList(object oTarget, string sListName = "")
{
    return _GetList(oTarget, VARLIST_TYPE_LOCATION, sListName);
}

json GetVectorList(object oTarget, string sListName = "")
{
    return _GetList(oTarget, VARLIST_TYPE_VECTOR, sListName);
}

json GetObjectList(object oTarget, string sListName = "")
{
    return _GetList(oTarget, VARLIST_TYPE_OBJECT, sListName);
}

json GetStringList(object oTarget, string sListName = "")
{
    return _GetList(oTarget, VARLIST_TYPE_STRING, sListName);
}

json GetJsonList(object oTarget, string sListName = "")
{
    return _GetList(oTarget, VARLIST_TYPE_JSON, sListName);
}

void SetFloatList(object oTarget, json jList, string sListName = "")
{
    _SetList(oTarget, VARLIST_TYPE_FLOAT, sListName, jList);
}

void SetIntList(object oTarget, json jList, string sListName = "")
{
    _SetList(oTarget, VARLIST_TYPE_INT, sListName, jList);
}

void SetLocationList(object oTarget, json jList, string sListName = "")
{
    _SetList(oTarget, VARLIST_TYPE_LOCATION, sListName, jList);
}

void SetVectorList(object oTarget, json jList, string sListName = "")
{
    _SetList(oTarget, VARLIST_TYPE_VECTOR, sListName, jList);
}

void SetObjectList(object oTarget, json jList, string sListName = "")
{
    _SetList(oTarget, VARLIST_TYPE_OBJECT, sListName, jList);
}

void SetStringList(object oTarget, json jList, string sListName = "")
{
    _SetList(oTarget, VARLIST_TYPE_STRING, sListName, jList);
}

void SetJsonList(object oTarget, json jList, string sListName = "")
{
    _SetList(oTarget, VARLIST_TYPE_JSON, sListName, jList);
}

void DeleteFloatList(object oTarget, string sListName = "")
{
    _DeleteList(oTarget, VARLIST_TYPE_FLOAT, sListName);
}

void DeleteIntList(object oTarget, string sListName = "")
{
    _DeleteList(oTarget, VARLIST_TYPE_INT, sListName);
}

void DeleteLocationList(object oTarget, string sListName = "")
{
    _DeleteList(oTarget, VARLIST_TYPE_LOCATION, sListName);
}

void DeleteVectorList(object oTarget, string sListName = "")
{
    _DeleteList(oTarget, VARLIST_TYPE_VECTOR, sListName);
}

void DeleteObjectList(object oTarget, string sListName = "")
{
    _DeleteList(oTarget, VARLIST_TYPE_OBJECT, sListName);
}

void DeleteStringList(object oTarget, string sListName = "")
{
    _DeleteList(oTarget, VARLIST_TYPE_STRING, sListName);
}

void DeleteJsonList(object oTarget, string sListName = "")
{
    _DeleteList(oTarget, VARLIST_TYPE_JSON, sListName);
}

json DeclareFloatList(object oTarget, int nCount, string sListName = "", float fDefault = 0.0)
{
    return _DeclareList(oTarget, VARLIST_TYPE_FLOAT, sListName, nCount, JsonFloat(fDefault));
}

json DeclareIntList(object oTarget, int nCount, string sListName = "", int nDefault = 0)
{
    return _DeclareList(oTarget, VARLIST_TYPE_INT, sListName, nCount, JsonInt(nDefault));
}

json DeclareLocationList(object oTarget, int nCount, string sListName = "")
{
    return _DeclareList(oTarget, VARLIST_TYPE_LOCATION, sListName, nCount, JsonNull());
}

json DeclareVectorList(object oTarget, int nCount, string sListName = "")
{
    return _DeclareList(oTarget, VARLIST_TYPE_VECTOR, sListName, nCount, JsonNull());
}

json DeclareObjectList(object oTarget, int nCount, string sListName = "")
{
    return _DeclareList(oTarget, VARLIST_TYPE_OBJECT, sListName, nCount, JsonNull());
}

json DeclareStringList(object oTarget, int nCount, string sListName = "", string sDefault = "")
{
    return _DeclareList(oTarget, VARLIST_TYPE_STRING, sListName, nCount, JsonString(sDefault));
}

json DeclareJsonList(object oTarget, int nCount, string sListName = "")
{
    return _DeclareList(oTarget, VARLIST_TYPE_JSON, sListName, nCount, JsonNull());
}

json NormalizeFloatList(object oTarget, int nCount, string sListName = "", float fDefault = 0.0)
{
    return _NormalizeList(oTarget, VARLIST_TYPE_FLOAT, sListName, nCount, JsonFloat(fDefault));
}

json NormalizeIntList(object oTarget, int nCount, string sListName = "", int nDefault = 0)
{
    return _NormalizeList(oTarget, VARLIST_TYPE_INT, sListName, nCount, JsonInt(nDefault));
}

json NormalizeLocationList(object oTarget, int nCount, string sListName = "")
{
    return _NormalizeList(oTarget, VARLIST_TYPE_LOCATION, sListName, nCount, JsonNull());
}

json NormalizeVectorList(object oTarget, int nCount, string sListName = "")
{
    return _NormalizeList(oTarget, VARLIST_TYPE_VECTOR, sListName, nCount, JsonNull());
}

json NormalizeObjectList(object oTarget, int nCount, string sListName = "")
{
    return _NormalizeList(oTarget, VARLIST_TYPE_OBJECT, sListName, nCount, JsonNull());
}

json NormalizeStringList(object oTarget, int nCount, string sListName = "", string sDefault = "")
{
    return _NormalizeList(oTarget, VARLIST_TYPE_STRING, sListName, nCount, JsonString(sDefault));
}

json NormalizeJsonList(object oTarget, int nCount, string sListName = "")
{
    return _NormalizeList(oTarget, VARLIST_TYPE_JSON, sListName, nCount, JsonNull());
}

void CopyFloatList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE)
{
    _CopyListElements(oSource, oTarget, VARLIST_TYPE_FLOAT, sSourceName, sTargetName, 0, -1, bAddUnique);
}

void CopyIntList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE)
{
    _CopyListElements(oSource, oTarget, VARLIST_TYPE_INT, sSourceName, sTargetName, 0, -1, bAddUnique);
}

void CopyLocationList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE)
{
    _CopyListElements(oSource, oTarget, VARLIST_TYPE_LOCATION, sSourceName, sTargetName, 0, -1, bAddUnique);
}

void CopyVectorList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE)
{
    _CopyListElements(oSource, oTarget, VARLIST_TYPE_VECTOR, sSourceName, sTargetName, 0, -1, bAddUnique);
}

void CopyObjectList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE)
{
    _CopyListElements(oSource, oTarget, VARLIST_TYPE_OBJECT, sSourceName, sTargetName, 0, -1, bAddUnique);
}

void CopyStringList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE)
{
    _CopyListElements(oSource, oTarget, VARLIST_TYPE_STRING, sSourceName, sTargetName, 0, -1, bAddUnique);
}

void CopyJsonList(object oSource, object oTarget, string sSourceName, string sTargetName, int bAddUnique = FALSE)
{
    _CopyListElements(oSource, oTarget, VARLIST_TYPE_JSON, sSourceName, sTargetName, 0, -1, bAddUnique);
}

int CountFloatList(object oTarget, string sListName = "")
{
    return _CountList(oTarget, VARLIST_TYPE_FLOAT, sListName);
}

int CountIntList(object oTarget, string sListName = "")
{
    return _CountList(oTarget, VARLIST_TYPE_INT, sListName);
}

int CountLocationList(object oTarget, string sListName = "")
{
    return _CountList(oTarget, VARLIST_TYPE_LOCATION, sListName);
}

int CountVectorList(object oTarget, string sListName = "")
{
    return _CountList(oTarget, VARLIST_TYPE_VECTOR, sListName);
}

int CountObjectList(object oTarget, string sListName = "")
{
    return _CountList(oTarget, VARLIST_TYPE_OBJECT, sListName);
}

int CountStringList(object oTarget, string sListName = "")
{
    return _CountList(oTarget, VARLIST_TYPE_STRING, sListName);
}

int CountJsonList(object oTarget, string sListName = "")
{
    return _CountList(oTarget, VARLIST_TYPE_JSON, sListName);
}

void SortFloatList(object oTarget, int nOrder = LIST_SORT_ASC, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_FLOAT, sListName, nOrder);
}

void SortIntList(object oTarget, int nOrder = LIST_SORT_ASC, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_INT, sListName, nOrder);
}

void SortStringList(object oTarget, int nOrder = LIST_SORT_ASC, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_STRING, sListName, nOrder);
}

void ShuffleFloatList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_FLOAT, sListName, JSON_ARRAY_SHUFFLE);
}

void ShuffleIntList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_INT, sListName, JSON_ARRAY_SHUFFLE);
}

void ShuffleLocationList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_LOCATION, sListName, JSON_ARRAY_SHUFFLE);
}

void ShuffleVectorList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_VECTOR, sListName, JSON_ARRAY_SHUFFLE);
}

void ShuffleObjectList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_OBJECT, sListName, JSON_ARRAY_SHUFFLE);
}

void ShuffleStringList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_STRING, sListName, JSON_ARRAY_SHUFFLE);
}

void ShuffleJsonList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_JSON, sListName, JSON_ARRAY_SHUFFLE);
}

void ReverseFloatList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_FLOAT, sListName, JSON_ARRAY_REVERSE);
}

void ReverseIntList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_INT, sListName, JSON_ARRAY_REVERSE);
}

void ReverseLocationList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_LOCATION, sListName, JSON_ARRAY_REVERSE);
}

void ReverseVectorList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_VECTOR, sListName, JSON_ARRAY_REVERSE);
}

void ReverseObjectList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_OBJECT, sListName, JSON_ARRAY_REVERSE);
}

void ReverseStringList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_STRING, sListName, JSON_ARRAY_REVERSE);
}

void ReverseJsonList(object oTarget, string sListName = "")
{
    _SortList(oTarget, VARLIST_TYPE_JSON, sListName, JSON_ARRAY_REVERSE);
}
