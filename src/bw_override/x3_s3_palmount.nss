//::///////////////////////////////////////////////
//:: Summon Paladin Mount
//:: x3_s3_palmount
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     This script handles the summoning of the paladin mount.
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: 2007-18-12
//:: Last Update: March 29th, 2008
//:://////////////////////////////////////////////

/*
    On the module object set X3_HORSE_PALADIN_USE_PHB to 1 as an integer
    variable if you want the duration to match that found in the 3.5 edition
    version of the Player's Handbook.

*/

#include "x3_inc_horse"
#include "ds_htf_c"

void _hookAssociate(object oPaladinMount)
{
    if(DKSN_HTF_APPLY_TO_PALADINMOUNT)
    {
        object oAssociate = oPaladinMount;
        DelayCommand(0.1, ExecuteScript(DKSN_HTF_ASSOCIATE_SCRIPT, oAssociate));
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    object oMount;
    object oAreaTarget = GetArea(oPC); // used for mount restriction checking

    int bPHBDuration = GetLocalInt(GetModule(), "X3_HORSE_PALADIN_USE_PHB");
    int bNoMounts = FALSE;

    string sSummonScript;

    if (!GetLocalInt(oAreaTarget,"X3_MOUNT_OK_EXCEPTION"))
    { // check for global restrictions
        if (GetLocalInt(GetModule(),"X3_MOUNTS_EXTERNAL_ONLY")&&GetIsAreaInterior(oAreaTarget)) bNoMounts=TRUE;
        else if (GetLocalInt(GetModule(),"X3_MOUNTS_NO_UNDERGROUND")&&!GetIsAreaAboveGround(oAreaTarget)) bNoMounts=TRUE;
    } // check for global restrictions


    //Check to see if horses are not allowed in this area.  If so, no mount is summoned.
    if (GetLocalInt(GetArea(oPC), "X3_NO_HORSES") || bNoMounts)
    {
        DelayCommand(1.0,IncrementRemainingFeatUses(oPC,FEAT_PALADIN_SUMMON_MOUNT));
        FloatingTextStrRefOnCreature(111986, oPC, FALSE);
        return;
    }

    if (GetSpellId() == SPELL_PALADIN_SUMMON_MOUNT)
    {
        //See if this guy already has a Paladin Mount, if not check to see if he's already mounted.
        oMount = HorseGetPaladinMount(oPC);
        if (!GetIsObjectValid(oMount)) 
            oMount = GetLocalObject(oPC, "oX3PaladinMount");
        
        if (GetIsObjectValid(oMount))
        {
            if (GetIsPC(oPC))
            {
                if (oMount == oPC) FloatingTextStrRefOnCreature(111987, oPC, FALSE);
                else FloatingTextStrRefOnCreature(111988, oPC, FALSE);
            }
            DelayCommand(1.0, IncrementRemainingFeatUses(oPC,FEAT_PALADIN_SUMMON_MOUNT));
            return;
        }

        sSummonScript=GetLocalString(GetModule(),"X3_PALMOUNT_SUMMONOVR");

        if (GetStringLength(GetLocalString(oPC, "X3_PALMOUNT_SUMMONOVR")) > 0) 
            sSummonScript = GetLocalString(oPC,"X3_PALMOUNT_SUMMONOVR");

        if (GetStringLength(sSummonScript) < 1)
        {
            oMount=HorseSummonPaladinMount(bPHBDuration);
            if(DKSN_HTF_APPLY_TO_ASSOCIATES) 
                DelayCommand(0.1, _hookAssociate(oPC));
        }
        else
        {
            ExecuteScript(sSummonScript,oPC);
        }
    }
}
