/*
Filename:           h2_persistence_c
System:             core (persistence user configuration file)
Author:             Edward Beck (0100010)
Date Created:       Aug. 28, 2005
Summary:

This script is consumed by h2_persistence_i as an include directive.

Contains user definable functions and constants for the persistance subsystem.
Should contains include directives for additional files needed by the user,
and any _t scripts (text string definition scripts).

This script is freely editable by the mod builder. It should not contain any h2 functions that should
not be overrideable by the user, put those in h2_persistence_i.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_biowaredb_c"

//------------------------DO NOT EDIT BELOW THIS LINE--------------------------------

//All below functions and constants may be overriden by the user, but do not alter the prototyped function
//signature or the name of the constants, merely edit the contents of the function within the include
//file that you have specified to use above.

//See h2_biowaredb_c as an example of how the internal code of the below functions is defined
//and how to what value the constants are set.

//The below commented out constant must be defined with the same variable name in the include
//file used above.
//const string H2_DEFAULT_CAMPAIGN_NAME = "H2_TESTMODULE";

//This function contains any code that needs to be  called to set up the database system you are using.
//It is called directly from h2_moduleload_e, and is called prior to any other module load scripts
//that have been set to be ran via the Event Script hook-ins.
void h2_InitializeDatabase();

//Gets an variable of type float from the database system being used.
//sVarName = name of the variable to retrieve.
//oPlayer a PC player object that is associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
float h2_GetExternalFloat(string sVarName, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Gets an variable of type int from the database system being used.
//sVarName = name of the variable to retrieve.
//oPlayer a PC player object that is associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
int h2_GetExternalInt(string sVarName, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Gets an variable of type location from the database system being used.
//sVarName = name of the variable to retrieve.
//oPlayer a PC player object that is associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
location h2_GetExternalLocation(string sVarName, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Gets an variable of type string from the database system being used.
//sVarName = name of the variable to retrieve.
//oPlayer a PC player object that is associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
string h2_GetExternalString(string sVarName, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Gets an variable of type vector from the database system being used.
//sVarName = name of the variable to retrieve.
//oPlayer a PC player object that is associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
vector h2_GetExternalVector(string sVarName, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Gets an variable of type object from the database system being used.
//sVarName = name of the variable to retrieve.
//oPlayer a PC player object that is associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
object h2_GetExternalObject(string sVarName, location locLocation, object oOwner = OBJECT_INVALID, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Deletes a variable of of the given name from the database system being used.
//sVarName = name of the variable to delete.
//oPlayer a PC player object that is associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
void h2_DeleteExternalVariable(string sVarName, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Sets an variable of type float to the database system being used.
//sVarName = name of the variable to assign.
//flFloat = the value to be set to the variable.
//oPlayer a PC player object to be associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
void h2_SetExternalFloat(string sVarName, float flFloat, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Sets an variable of type int to the database system being used.
//sVarName = name of the variable to assign.
//nInt = the value to be set to the variable.
//oPlayer a PC player object to be associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
void h2_SetExternalInt(string sVarName, int nInt, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Sets an variable of type location to the database system being used.
//sVarName = name of the variable to assign.
//locLocationt = the value to be set to the variable.
//oPlayer a PC player object to be associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
void h2_SetExternalLocation(string sVarName, location locLocation, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Sets an variable of type string to the database system being used.
//sVarName = name of the variable to assign.
//sString = the value to be set to the variable.
//oPlayer a PC player object to be associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
void h2_SetExternalString(string sVarName, string sString, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Sets an variable of type vector to the database system being used.
//sVarName = name of the variable to assign.
//vVector = the value to be set to the variable.
//oPlayer a PC player object to be associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
void h2_SetExternalVector(string sVarName, vector vVector, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);

//Sets an variable of type object to the database system being used.
//sVarName = name of the variable to assign.
//oObject = the value to be set to the variable.
//oPlayer a PC player object to be associated with this variable. Defaults to OBJECT_INVALID
//sCampaignName the name of the campaign, or the name of the database being used.
//The default value for sCampaignName is the value assigned to the constant H2_DEFAULT_CAMPAIGN_NAME
//SetExternalObject must return 0 if it fails and 1 if it succeeds.
int  h2_SetExternalObject(string sVarName, object oObject, object oPlayer=OBJECT_INVALID, string sCampaignName=H2_DEFAULT_CAMPAIGN_NAME);
