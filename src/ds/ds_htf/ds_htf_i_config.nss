/*******************************************************************************
* Description:  Dark Sun HTF sub-system configuration switches
  Usage:        Used to setup the HTF sub-system for the Dark Sun module.
********************************************************************************
* Created By:   tinygiant
* Created On:   20200125
*******************************************************************************/

//Areas that are not considered city/populated will have a travel cost associated
//  with them.  This travel cost is applied after a player has entered a non-
//  populated area for more than a specific amount of time.  This delay allows
//  a PC who has accidentally entered an area with a travel cost to exit without
//  penalty to his HTF stats as long as he does so before this time runs out.
//  Set the desired delay in this constant.  Units = seconds.
const float DS_HTF_AREATRAVELCOST_DELAY = 15.0;

//Some races and other variables can affect the factor used to decrement the value
//  of the Hunger, Thirst and Fatigue bars for each PC.  If you want to use
//  custom values for some decrement factors, set this value to TRUE.  If set to
//  FALSE, HCR2 values will be used.
const int DS_HTF_USE_CUSTOM_DECREMENT_FACTORS = TRUE;

//PCs can be accompanied by familiars, mounts and various other creatures.  If these
//  creature are partied with and under the control of the PC, they can be subject to
//  the same HTF limitations, requirements and penalties as the PC.  If you want
//  associates to be subject to the HTF system, set this value to TRUE.  If you
//  don't want to worry about them, set this to FALSE.
const int DS_HTF_APPLY_TO_ASSOCIATES = TRUE;

//  To go along with the previous constant, these switches will turn and off the system
//      for specific associate types.  Currently, Summons and Dominated are not implemented,
//      and Henchmen needs to be implemented with a hiring conversation or other method.
const int DS_HTF_APPLY_TO_ANIMALCOMPANION = TRUE;
const int DS_HTF_APPLY_TO_FAMILIAR = TRUE;
const int DS_HTF_APPLY_TO_HENCHMAN = TRUE;
const int DS_HTF_APPLY_TO_SUMMONS = FALSE;
const int DS_HTF_APPLY_TO_DOMINATED = FALSE;
const int DS_HTF_APPLY_TO_PALADINMOUNT = TRUE;

//  This script will be run for any associate if their switch above is set to TRUE.
const string DS_HTF_ASSOCIATE_SCRIPT = "ds_htf_assoc_add";

//If DS_HTF_APPLY_HTF_TO_ASSOCIATES is TRUE, we need to configure how the system
//  will be displayed on the associate.  The simplify the display, the values will be
//  shown in the floating bubble (where the NPC name is) above the NPC when the PC
//  hovers over the associate.  The values can be displayed as simple colored letters
//  (H | T | F), letters with numbers (H28 | T40 | F100) or as colored bars
//  (H ||||| T ||| F ||).  Set DS_HTF_ASSOCIATE_DISPLAY_TYPE to the appropriate
//  value.
const int ASSOCIATE_DISPLAY_LETTERS = 1;
const int ASSOCIATE_DISPLAY_NUMBERS = 2;
const int ASSOCIATE_DISPLAY_BARS = 3;

const int DS_HTF_ASSOCIATE_DISPLAY_TYPE = ASSOCIATE_DISPLAY_NUMBERS;

//Regardless of the type of associate display, the HTF values are displayed in color.
//  Set the following constants to determine thresholds for the various colors and the
//  actual color to be used.
//Values <= DS_HTF_THRESHHOLD_DIRE will be displayed in Red text.
//Values > DS_HTF_THRESHHOLD_DIRE and <= DS_HTF_THRESHHOLD_CAUTION will be displayed in Yellow text.
//Values > DS_HTF_THRESHHOLD_CAUTION will be displayed in Green text.
const int DS_HTF_THRESHHOLD_OK = 100;
const int DS_HTF_THRESHHOLD_CAUTION = 50;
const int DS_HTF_THRESHHOLD_DIRE = 10;
