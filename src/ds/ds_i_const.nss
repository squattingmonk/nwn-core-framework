/*******************************************************************************
* Description:  Add-on constants and functions for the Dark Sun Module
  Usage:        Include in scripts where these add-on constants and functions
                will be called
********************************************************************************
* Created By:   Melanie Graham (Nairn)
* Created On:   2019-04-13
*******************************************************************************/

// Race Constants
const int DKSN_RACIAL_TYPE_DWARF =      0;
const int DKSN_RACIAL_TYPE_ELF =        1;
const int DKSN_RACIAL_TYPE_HALFLING =   2;
const int DKSN_RACIAL_TYPE_THRIKREEN =  3;
const int DKSN_RACIAL_TYPE_HALFELF =    27;
const int DKSN_RACIAL_TYPE_AARAKOCRA=   29;
const int DKSN_RACIAL_TYPE_PTERRAN =    30;
const int DKSN_RACIAL_TYPE_MUL =        31;
const int DKSN_RACIAL_TYPE_HUMAN =      32;
const int DKSN_RACIAL_TYPE_HALFGIANT =  33;
const int DKSN_RACIAL_TYPE_TAREK =      34;

// Area Type Constants
const int DKSN_AREATYPE_BOULDERFIELD =  1;
const int DKSN_AREATYPE_DUSTSINK =      2;
const int DKSN_AREATYPE_MOUNTAIN =      3;
const int DKSN_AREATYPE_MUDFLAT =       4;
const int DKSN_AREATYPE_ROCKYBADLAND =  5;
const int DKSN_AREATYPE_SALTFLAT =      6;
const int DKSN_AREATYPE_SALTMARSH =     7;
const int DKSN_AREATYPE_SANDYWASTE =    8;
const int DKSN_AREATYPE_SCRUBPLAIN =    9;
const int DKSN_AREATYPE_STONYBARREN =   10;

//Area Travel Messages
const string DKSN_AREATRAVELMESSAGE_DEFAULT =       "Default Area Travel Message";
const string DKSN_AREATRAVELMESSAGE_BOULDERFIELD =  "Boulder Field Area Travel Message";
const string DKSN_AREATRAVELMESSAGE_DUSTSINK =      "Dust Sink Area Travel Message";
const string DKSN_AREATRAVELMESSAGE_MOUNTAIN =      "Mountain Area Travel Message";
const string DKSN_AREATRAVELMESSAGE_MUDFLAT =       "Mud Flat Area Travel Message";
const string DKSN_AREATRAVELMESSAGE_ROCKYBADLAND =  "Rocky Badland Area Travel Message";
const string DKSN_AREATRAVELMESSAGE_SALTFLAT =      "Salt Flat Area Travel Message";
const string DKSN_AREATRAVELMESSAGE_SALTMARSH =     "Salt Marsh Area Travel Message";
const string DKSN_AREATRAVELMESSAGE_SANDYWASTE =    "Sandy Waste Area Travel Message";
const string DKSN_AREATRAVELMESSAGE_SCRUBPLAIN =    "Scrub Plain Area Travel Message";
const string DKSN_AREATRAVELMESSAGE_STONYBARREN =   "Stony Barren Area Travel Message";

//Area HTF Travel Costs
//These costs are in percentage of total possible HTF bar and are applied
//  when the timer expires in ds_htf_areatimer.
const int DKSN_AREATRAVELCOST_DEFAULT =         0;
const int DKSN_AREATRAVELCOST_BOULDERFIELD =    33;
const int DKSN_AREATRAVELCOST_DUSTSINK =        50;
const int DKSN_AREATRAVELCOST_MOUNTAIN =        50;
const int DKSN_AREATRAVELCOST_MUDFLAT =         33;
const int DKSN_AREATRAVELCOST_ROCKYBADLAND =    50;
const int DKSN_AREATRAVELCOST_SALTFLAT =        25;
const int DKSN_AREATRAVELCOST_SALTMARSH =       33;
const int DKSN_AREATRAVELCOST_SANDYWASTE =      33;
const int DKSN_AREATRAVELCOST_SCRUBPLAIN =      25;
const int DKSN_AREATRAVELCOST_STONYBARREN =     33;

//Other
const float DKSN_DOOR_CLOSE_DELAY = 5.0;
