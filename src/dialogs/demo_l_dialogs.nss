// -----------------------------------------------------------------------------
//    File: demo_l_dialogs.nss
//  System: Dynamic Dialogs (library script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This library contains some example dialogs that show the features of the Core
// Dialogs system. You can use it as a model for your own dialog libraries.
// -----------------------------------------------------------------------------

#include "dlg_i_dialogs"
#include "util_i_library"

// -----------------------------------------------------------------------------
//                                  Poet Dialog
// -----------------------------------------------------------------------------
// This dialog shows how to use continue, back, and end nodes in a dialog.
// -----------------------------------------------------------------------------

const string POET_DIALOG       = "PoetDialog";
const string POET_DIALOG_INIT  = "PoetDialog_Init";
const string POET_DIALOG_PAGE  = "PoetDialog_Page";
const string POET_DIALOG_QUIT  = "PoetDialog_Quit";

const string POET_PAGE_MAIN = "Main Page";
const string POET_PAGE_INFO = "Continue Node Info";
const string POET_PAGE_POOR = "Not enough GP";
const string POET_PAGE_MARY = "Poem: Mary Had A Little Lamb";
const string POET_PAGE_SICK = "Poem: Sick";
const string POET_PAGE_END  = "Poem Finished";

void PoetDialog_Init()
{
    string sPage;

    // Main landing page
    SetDialogPage(POET_PAGE_MAIN);
    AddDialogPage(POET_PAGE_MAIN, "Would you like to hear a poem? 1GP per recital!");
    AddDialogNode(POET_PAGE_MAIN, "Who are you?", POET_PAGE_INFO);
    AddDialogNode(POET_PAGE_MAIN, "Mary Had A Little Lamb", POET_PAGE_MARY);
    AddDialogNode(POET_PAGE_MAIN, "Sick, by Shel Silverstein", POET_PAGE_SICK);
    AddDialogNode(POET_PAGE_MAIN, "I can't afford that.", POET_PAGE_POOR);
    EnableDialogEnd("Goodbye", POET_PAGE_MAIN);

    // PC asked "Who are you?"
    AddDialogPage(POET_PAGE_INFO,
        "I am demonstrating continued pages. Continued pages are used when " +
        "you want to have several pages of text with a continue button in " +
        "between.");
    AddDialogPage(POET_PAGE_INFO,
        "To continue a page, simply call the AddDialogPage() function using " +
        "the same page name. A child page will be created and a \"Continue\" " +
        "node will be added to the parent page. Do this as many times as is " +
        "necessary to add sufficient text.");
    AddDialogPage(POET_PAGE_INFO,
        "The child pages are full pages like any other. They can have their " +
        "own nodes, etc. The AddDialogPage() function returns the name of " +
        "the child page, so you can catch it and change things without " +
        "having to keep track of how many pages are in the chain.");
    AddDialogPage(POET_PAGE_INFO,
        "You can add automated nodes such as end or back responses. In this " +
        "example, I get mad and attack you if you interrupt my beautiful " +
        "poetry, so I suggest not doing that.");
    sPage = AddDialogPage(POET_PAGE_INFO,
        "You can also add \"Continue\" nodes to a page using the function " +
        "ContinueDialogPage(). This function links a page to an existing " +
        "page. It's useful for ending a chain of continued pages. In fact, " +
        "that's what links the \"Continue\" node below back to the main page.");
    ContinueDialogPage(sPage, POET_PAGE_MAIN);

    // PC does not have enough money to list to the chosen poem.
    AddDialogPage(POET_PAGE_POOR,
        "Oh, I'm sorry. It seems you don't have enough coin on you. I don't " +
        "recite poetry for free, you know.");
    AddDialogNode(POET_PAGE_POOR,
        "Can you tell me who you are instead?", POET_PAGE_INFO);
    EnableDialogEnd("Goodbye", POET_PAGE_POOR);

    // PC chose poem "Mary Had A Little Lamb"
    AddDialogPage(POET_PAGE_MARY,
            "Mary had a little lamb,\n" +
            "Little lamb,\nLittle lamb.\n" +
            "Mary had a little lamb.\n" +
            "Its fleece was white as snow.");
    sPage = AddDialogPage(POET_PAGE_MARY,
            "Everywhere that Mary went,\n" +
            "Mary went,\nMary went,\n" +
            "Everywhere that Mary went,\n" +
            "The lamb was sure to go.");
    EnableDialogEnd("I've had enough of this. Good day!", sPage);

    sPage = AddDialogPage(POET_PAGE_MARY,
            "It followed her to school one day,\n" +
            "School one day,\nSchool one day,\n" +
            "It followed her to school one day,\n" +
            "Which was against the rules.");
    EnableDialogEnd("Booooring! Learn to recite poetry!", sPage);

    sPage = AddDialogPage(POET_PAGE_MARY,
            "It made the children laugh and play,\n" +
            "Laugh and play,\nLaugh and play,\n" +
            "It made the children laugh and play,\n" +
            "To see a lamb at school.");
    EnableDialogEnd("Oh, gods! I thought it would never end!", sPage);
    ContinueDialogPage(sPage, POET_PAGE_END);

    // PC chose poem "Sick, by Shel Silverstein"
    AddDialogPage(POET_PAGE_SICK,
            "I cannot go to school today,\n" +
            "Said little Peggy Ann McKay.\n" +
            "I have the measles and the mumps,\n" +
            "A gash, a rash and purple bumps.");
    AddDialogPage(POET_PAGE_SICK,
            "My mouth is wet, my throat is dry,\n" +
            "I'm going blind in my right eye.\n" +
            "My tonsils are as big as rocks,\n" +
            "I've counted sixteen chicken pox\n" +
            "And there's one more--that's seventeen,\n" +
            "And don't you think my face looks green?");
    AddDialogPage(POET_PAGE_SICK,
            "My leg is cut--my eyes are blue--\n" +
            "It might be instamatic flu.\n" +
            "I cough and sneeze and gasp and choke,\n" +
            "I'm sure that my left leg is broke--\n" +
            "My hip hurts when I move my chin,\n" +
            " My belly button's caving in.");
    sPage = AddDialogPage(POET_PAGE_SICK,
            "My back is wrenched, my ankle's sprained,\n" +
            "My 'pendix pains each time it rains.\n" +
            "My nose is cold, my toes are numb.\n" +
            "I have a sliver in my thumb.\n" +
            "My neck is stiff, my voice is weak,\n" +
            "I hardly whisper when I speak.");
    EnableDialogEnd("I've had enough of this. Good day!", sPage);

    sPage = AddDialogPage(POET_PAGE_SICK,
            "My tongue is filling up my mouth,\n" +
            "I think my hair is falling out.\n" +
            "My elbow's bent, my spine ain't straight,\n" +
            "My temperature is one-o-eight.\n" +
            "My brain is shrunk, I cannot hear,\n" +
            "There is a hole inside my ear.");
    EnableDialogEnd("Booooring! Learn to recite poetry!", sPage);

    sPage = AddDialogPage(POET_PAGE_SICK,
            "I have a hangnail, and my heart is--what?\n" +
            "What's that? What's that you say?\n" +
            "You say today is... Saturday?\n" +
            "G'bye, I'm going out to play!");
    EnableDialogEnd("Oh, gods! I thought it would never end!", sPage);
    ContinueDialogPage(sPage, POET_PAGE_END);

    // Poem is finished
    AddDialogPage(POET_PAGE_END, "I hope you enjoyed it! Would you like to " +
        "hear another poem? Only 1GP per recital!");
    SetDialogNodes(POET_PAGE_END, POET_PAGE_MAIN);
    EnableDialogEnd("That's it for me, thanks.", POET_PAGE_END);
}

void PoetDialog_Page()
{
    string sPage = GetDialogPage();
    object oPC = GetPCSpeaker();
    int nGold = GetGold(oPC);

    if (sPage == POET_PAGE_MAIN || sPage == POET_PAGE_END)
    {
        // This only happens on the first run
        if (GetDialogNode() == DLG_NODE_NONE)
            ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING);

        if (nGold < 1)
            FilterDialogNodes(1, 2);
        else
            FilterDialogNodes(3);
    }
    else if (sPage == POET_PAGE_MARY || sPage == POET_PAGE_SICK)
    {
        if (nGold < 1)
            SetDialogPage(POET_PAGE_POOR);
        else
            TakeGoldFromCreature(1, oPC);
    }

    // We don't use history in this dialog, so don't store it up
    ClearDialogHistory();
}

void PoetDialog_Quit()
{
    string sPage = GetDialogPage();

    if (GetStringLeft(sPage, 5) == "Poem:")
    {
        object oPC = GetPCSpeaker();
        ActionSpeakString("You'll pay for that!");
        ActionDoCommand(SetIsTemporaryEnemy(oPC));
        ActionAttack(oPC);
    }
    else
    {
        ActionSpeakString("Perhaps another time, then? Good day!");
        ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING);
    }
}

void OnLibraryLoad()
{
    Debug("Loading library dlg_l_demo");
    RegisterLibraryScript(POET_DIALOG_INIT);
    RegisterLibraryScript(POET_DIALOG_PAGE);
    RegisterLibraryScript(POET_DIALOG_QUIT);

    RegisterDialogScript(POET_DIALOG, POET_DIALOG_INIT, DLG_EVENT_INIT);
    RegisterDialogScript(POET_DIALOG, POET_DIALOG_PAGE, DLG_EVENT_PAGE);
    RegisterDialogScript(POET_DIALOG, POET_DIALOG_QUIT, DLG_EVENT_END | DLG_EVENT_ABORT);
}

void OnLibraryScript(string sScript, int nEntry)
{
    if      (sScript == POET_DIALOG_PAGE) PoetDialog_Page();
    else if (sScript == POET_DIALOG_QUIT) PoetDialog_Quit();
    else if (sScript == POET_DIALOG_INIT) PoetDialog_Init();
}
