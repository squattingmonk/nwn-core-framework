// -----------------------------------------------------------------------------
//    File: dlg_l_demo.nss
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
    AddDialogNode(POET_PAGE_MAIN, POET_PAGE_INFO, "Who are you?");
    AddDialogNode(POET_PAGE_MAIN, POET_PAGE_MARY, "Mary Had A Little Lamb");
    AddDialogNode(POET_PAGE_MAIN, POET_PAGE_SICK, "Sick, by Shel Silverstein");
    AddDialogNode(POET_PAGE_MAIN, POET_PAGE_POOR, "I can't afford that.");
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
    AddDialogNode(POET_PAGE_POOR, POET_PAGE_INFO,
        "Can you tell me who you are instead?");
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

// -----------------------------------------------------------------------------
//                                 Anvil Dialog
// -----------------------------------------------------------------------------
// This dialog demonstrates dynamic node generation and automatic pagination.
// -----------------------------------------------------------------------------

const string ANVIL_DIALOG      = "AnvilDialog";
const string ANVIL_PAGE_MAIN   = "Main Page";
const string ANVIL_PAGE_ITEM   = "Item Chosen";
const string ANVIL_PAGE_ACTION = "Item Action";
const string ANVIL_ITEM        = "AnvilItem";

void AnvilDialog()
{
    switch (GetDialogEvent())
    {
        case DLG_EVENT_INIT:
        {
            AddDialogToken("Action");
            AddDialogToken("Item");

            EnableDialogEnd();
            SetDialogPage(ANVIL_PAGE_MAIN);
            AddDialogPage(ANVIL_PAGE_MAIN, "Select an item:");

            AddDialogPage(ANVIL_PAGE_ITEM, "What would you like to do with the <Item>?");
            AddDialogNode(ANVIL_PAGE_ITEM, ANVIL_PAGE_ACTION, "Clone it", "Copy");
            AddDialogNode(ANVIL_PAGE_ITEM, ANVIL_PAGE_ACTION, "Destroy it", "Destroy");
            EnableDialogNode(DLG_NODE_BACK, ANVIL_PAGE_ITEM);

            AddDialogPage(ANVIL_PAGE_ACTION, "<Action>ing <Item>");
            EnableDialogNode(DLG_NODE_BACK, ANVIL_PAGE_ACTION);
            SetDialogTarget(ANVIL_PAGE_MAIN, ANVIL_PAGE_ACTION, DLG_NODE_BACK);
        } break;

        case DLG_EVENT_PAGE:
        {
            object oPC = GetPCSpeaker();
            string sPage = GetDialogPage();
            int nNode = GetDialogNode();

            if (sPage == ANVIL_PAGE_MAIN)
            {
                DeleteDialogNodes(sPage);
                DeleteObjectList(DLG_SELF, ANVIL_ITEM);
                object oItem = GetFirstItemInInventory(oPC);

                while (GetIsObjectValid(oItem))
                {
                    AddDialogNode(sPage, ANVIL_PAGE_ITEM, GetName(oItem));
                    AddListObject(DLG_SELF, oItem, ANVIL_ITEM);
                    oItem = GetNextItemInInventory(oPC);
                }
            }
            else if (sPage == ANVIL_PAGE_ITEM)
            {
                object oItem = GetListObject(DLG_SELF, nNode, ANVIL_ITEM);
                SetLocalObject(DLG_SELF, ANVIL_ITEM, oItem);
                CacheDialogToken("Item", GetName(oItem));
            }
            else if (sPage == ANVIL_PAGE_ACTION)
            {
                int nNode = GetDialogNode();
                string sData = GetDialogData(ANVIL_PAGE_ITEM, nNode);
                object oItem = GetLocalObject(DLG_SELF, ANVIL_ITEM);
                CacheDialogToken("Action", sData);

                if (sData == "Copy")
                    CopyItem(oItem, oPC);
                else if (sData == "Destroy")
                    DestroyObject(oItem);
            }
        } break;
    }
}

// -----------------------------------------------------------------------------
//                                 Token Dialog
// -----------------------------------------------------------------------------
// This dialog demonstrates the use of dialog tokens.
// -----------------------------------------------------------------------------

const string TOKEN_DIALOG = "TokenDialog";
const string TOKEN_PAGE_MAIN = "Main Page";
const string TOKEN_PAGE_INFO = "Token Info";
const string TOKEN_PAGE_LIST = "Token List";

void TokenDialog()
{
    if (GetDialogEvent() != DLG_EVENT_INIT)
        return;

    EnableDialogEnd();
    SetDialogLabel(DLG_NODE_CONTINUE, "<StartAction>[Listen]</Start>");

    SetDialogPage(TOKEN_PAGE_MAIN);

    AddDialogPage(TOKEN_PAGE_MAIN,
        "Hello, <FirstName>. Isn't this a fine <quarterday>?");
    AddDialogNode(TOKEN_PAGE_MAIN, TOKEN_PAGE_INFO, "Who are you?");
    AddDialogNode(TOKEN_PAGE_MAIN, TOKEN_PAGE_LIST, "What tokens are available?");

    AddDialogPage(TOKEN_PAGE_INFO,
        "I'm demonstrating the use of dialog tokens. A token is a word or " +
        "choice in angle brackets such as <token>FullName</token>. Tokens " +
        "can be embedded directly into page or node text when initializing " +
        "the dialog and are evaluated at display time. This means you don't " +
        "need to know the value of the token to make the text work.");
    AddDialogPage(TOKEN_PAGE_INFO,
        "There are lots of tokens available, such as <token>class</token>, " +
        "<token>race</token>, and <token>level</token>.\n\n" +
        "That's how I can know you're a level <level> <racial> <class>.");
    AddDialogPage(TOKEN_PAGE_INFO,
        "You can also add your own tokens using AddDialogToken() in your " +
        "dialog's init script. This function takes three arguments:\n\n" +
        "- sToken: the token text (not including the brackets)\n" +
        "- sEvalScript: a library script that sets the token value\n" +
        "- sValues: an optional CSV list of possible values for the token");
    AddDialogPage(TOKEN_PAGE_INFO,
        "The library script referenced by sEvalScript can read the token " +
        "and possible values and then set the proper value for the token. " +
        "Refer to dlg_l_tokens.nss to see how this is done.");
    AddDialogPage(TOKEN_PAGE_INFO,
        "Some tokens can have uppercase and lowercase variants. When the " +
        "token is all lowercase, the value will be converted to lowercase; " +
        "otherwise the value will be used as is. For example:\n\n" +
        "<token>Class</token> -> <Class>\n" +
        "<token>class</token> -> <class>");
    AddDialogPage(TOKEN_PAGE_INFO,
        "Some tokens cannot be converted to lowercase; if there are any " +
        "uppercase characters in sToken, the text must be typed exactly and " +
        "its value will always be exact. For example:\n\n" +
        "<token>FullName</token> -> <FullName>\n" +
        "<token>fullname</token> -> <fullname>");
    string sPage = AddDialogPage(TOKEN_PAGE_INFO,
        "Tokens are specific to a dialog, so if you add your own tokens, you " +
        "don't have to worry about making them unique across all dialogs. " +
        "You could have a <token>value</token> token in two different " +
        "dialogs that are evaluated by different library scripts. This gives " +
        "you a lot of flexibility when designing dialogs.");
    EnableDialogNode(DLG_NODE_BACK, sPage);
    SetDialogTarget("Main Page", sPage, DLG_NODE_BACK);

    AddDialogPage(TOKEN_PAGE_LIST,
        "Gender tokens (case insensitive):\n\n" +
        "- <token>bitch/bastard</token> -> <bitch/bastard>\n" +
        "- <token>boy/girl</token> -> <boy/girl>\n" +
        "- <token>brother/sister</token> -> <brother/sister>\n" +
        "- <token>he/she</token> -> <he/she>\n" +
        "- <token>him/her</token> -> <him/her>\n" +
        "- <token>his/her</token> -> <his/her>\n" +
        "- <token>his/hers</token> -> <his/hers>\n" +
        "- <token>lad/lass</token> -> <lad/lass>\n" +
        "- <token>lord/lady</token> -> <lord/lady>\n" +
        "- <token>male/female</token> -> <male/female>\n" +
        "- <token>man/woman</token> -> <man/woman>\n" +
        "- <token>master/mistress</token> -> <master/mistress>\n" +
        "- <token>mister/missus</token> -> <mister/missus>\n" +
        "- <token>sir/madam</token> -> <sir/madam>");
    AddDialogPage(TOKEN_PAGE_LIST,
        "Alignment tokens (case insensitive):\n\n" +
        "- <token>alignment</token> -> <alignment>\n" +
        "- <token>good/evil</token> -> <good/evil>\n" +
        "- <token>law/chaos</token> -> <law/chaos>\n" +
        "- <token>lawful/chaotic</token> -> <lawful/chaotic>");
    AddDialogPage(TOKEN_PAGE_LIST,
        "Character tokens (case insensitive):\n\n" +
        "- <token>class</token> -> <class>\n" +
        "- <token>classes</token> -> <classes>\n" +
        "- <token>level</token> -> <level>\n" +
        "- <token>race</token> -> <race>\n" +
        "- <token>races</token> -> <races>\n" +
        "- <token>racial</token> -> <racial>\n" +
        "- <token>subrace</token> -> <subrace>\n\n" +
        "Character tokens (case sensitive):\n\n" +
        "- <token>Deity</token> -> <Deity>");
    AddDialogPage(TOKEN_PAGE_LIST,
        "Time tokens (case insensitive):\n\n" +
        "- <token>day/night</token> -> <day/night>\n" +
        "- <token>gameday</token> -> <gameday>\n" +
        "- <token>gamedate</token> -> <gamedate>\n" +
        "- <token>gamehour</token> -> <gamehour>\n" +
        "- <token>gameminute</token> -> <gameminute>\n" +
        "- <token>gamemonth</token> -> <gamemonth>\n" +
        "- <token>gamesecond</token> -> <gamesecond>\n" +
        "- <token>gametime12</token> -> <gametime12>\n" +
        "- <token>gametime24</token> -> <gametime24>\n" +
        "- <token>gameyear</token> -> <gameyear>\n" +
        "- <token>quarterday</token> -> <quarterday>");
    AddDialogPage(TOKEN_PAGE_LIST,
        "Name tokens (case sensitive):\n\n" +
        "- <token>FirstName</token> -> <FirstName>\n" +
        "- <token>FullName</token> -> <FullName>\n" +
        "- <token>LastName</token> -> <LastName>\n" +
        "- <token>PlayerName</token> -> <PlayerName>");
    sPage = AddDialogPage(TOKEN_PAGE_LIST,
        "Special tokens (case sensitive):\n\n" +
        "- <token>StartAction</token>foo<token>/Start</token> -> " +
            "<StartAction>foo</Start>\n" +
        "- <token>StartCheck</token>foo<token>/Start</token> -> " +
            "<StartCheck>foo</Start>\n" +
        "- <token>StartHighlight</token>foo<token>/Start</token> -> " +
            "<StartHighlight>foo</Start>\n\n" +
        "Special tokens (case insensitive):\n\n" +
        "- <token>token</token>foo<token>/token</token> -> <token>foo</token>");
    EnableDialogNode(DLG_NODE_BACK, sPage);
    SetDialogTarget("Main Page", sPage, DLG_NODE_BACK);
}


void OnLibraryLoad()
{
    RegisterLibraryScript(POET_DIALOG_INIT);
    RegisterLibraryScript(POET_DIALOG_PAGE);
    RegisterLibraryScript(POET_DIALOG_QUIT);

    RegisterDialogScript(POET_DIALOG, POET_DIALOG_INIT, DLG_EVENT_INIT);
    RegisterDialogScript(POET_DIALOG, POET_DIALOG_PAGE, DLG_EVENT_PAGE);
    RegisterDialogScript(POET_DIALOG, POET_DIALOG_QUIT, DLG_EVENT_END | DLG_EVENT_ABORT);

    RegisterLibraryScript(ANVIL_DIALOG);
    RegisterDialogScript (ANVIL_DIALOG);

    RegisterLibraryScript(TOKEN_DIALOG);
}

void OnLibraryScript(string sScript, int nEntry)
{
    if      (sScript == POET_DIALOG_PAGE) PoetDialog_Page();
    else if (sScript == POET_DIALOG_QUIT) PoetDialog_Quit();
    else if (sScript == POET_DIALOG_INIT) PoetDialog_Init();
    else if (sScript == ANVIL_DIALOG)     AnvilDialog();
    else if (sScript == TOKEN_DIALOG)     TokenDialog();
}
