
void main()
{
    object oSelf = OBJECT_SELF;
    string sTag = GetTag(oSelf);
    object oPC = GetLastUsedBy();

    if (sTag == "FloorLever1")
    {
        SendMessageToPC(oPC, "Bye!");
        object oTarget = GetObjectByTag("FloorLever1");
        SendMessageToPC(oPC, "Tag of target: " + GetTag(oTarget));
        ClearAllActions();
        AssignCommand(oPC, JumpToObject(oTarget));
    }

}
