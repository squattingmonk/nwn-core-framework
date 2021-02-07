// -----------------------------------------------------------------------------
//    File: chat_c_config.nss
//  System: Chat Command System
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// This file contains user-definable toggles and settings for the chat command
// system.
// -----------------------------------------------------------------------------

// Delimiters must be single characters; multiple consecutive delimiters will be
// ignored. If a delimiter is passed that is greater than one character, the
// first character will be used.
const string CHAT_DELIMITER = " ";

// This string contains characters used to designate a chat command. If a chat
// message uses one of these characters as its first character, it will be
// treated as a command. Do not use "-", "=", ":", any characters in
// CHAT_GROUPS below, or any normal alphanumeric characters.
const string CHAT_DESIGNATORS = "!@#$%^&*;,./?`~|\\";

// This string contains pairs of characters used to group words into a single
// parameter. Grouping characters must be paired and, if necessary, escaped.
// Unpaired grouping characters will result in grouping functions being lost and
// error provided in log. Do not use "-", "=", ":", any characters in
// CHAT_COMMAND_DESIGNATORS above, or any normal alphanumeric characters.
const string CHAT_GROUPS = "``{}[]()<>";

// To keep grouping symbols as part of the returned data, set this to FALSE.
const int REMOVE_GROUPING_SYMBOLS = TRUE;

// To force logging of all chat commands, set this to TRUE.
const int LOG_ALL_CHAT_COMMANDS = TRUE;

// To force logging of all chat command results that are not errors, set this to
// TRUE.
const int LOG_ALL_CHAT_RESULTS = TRUE;
