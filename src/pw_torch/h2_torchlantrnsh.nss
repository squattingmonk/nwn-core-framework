
#include "x2_inc_switches"
#include "h2_torchlantrn_i"

void main()
{
    object oItem = GetSpellCastItem();
    int spellID = GetSpellId();
    if (GetTag(oItem) == H2_OILFLASK && GetSpellId() == SPELL_GRENADE_FIRE)
    {
        if (d2()==1)
        {
            SendMessageToPC(OBJECT_SELF, H2_TEXT_OIL_FLASK_FAIED_TO_IGNITE);
            SetModuleOverrideSpellScriptFinished();
        }
    }
}
