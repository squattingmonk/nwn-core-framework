/*
Filename:           nw_s2_animalcom
System:             htf (associate hook)
Author:             Edward Burke (tinygiant)
Date Created:       20200212
Summary:
Used to hook associates into the Dark Sun HTF system if so desired by the
    module owner.  Options for Associates to be inlcuded are in the include
    file ds_htf_c.  If associates are not to be included in the module's
    HTF system, the Summon Animal Companion function will work normally.

This script overrides an internal BioWare script.  The name of the script
    must not be changed or the system will not function correctly.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "ds_htf_i_config"

void _hookAssociate(object oPC)
{
    if(DS_HTF_APPLY_TO_ANIMALCOMPANION)
    {
        object oAssociate = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
        DelayCommand(0.1, ExecuteScript(DS_HTF_ASSOCIATE_SCRIPT, oAssociate));
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    SummonAnimalCompanion(oPC);

    if(DS_HTF_APPLY_TO_ASSOCIATES) DelayCommand(0.1, _hookAssociate(oPC));
}
