# Introduction
This repository is a combination of Edward Beck's (0100010) HCR2 1.50 persistent world/module management system and Michael Sinclair's (Squatting Monk) core-framework event management system.

## HCR2
Most of the original HCR2 core system remains intact, but has been modified to be a plug-in to the core-framework instead of being the primary module management system.  Because of this, some components of the original HCR2 system had to be modified or removed.  However, HCR2 functions still act the primary managment system for player data and handling.  Here are the most significant changes to the HCR2 system:
* The event management system has been removed.
* The database/persistence functions have been removed.
* Individual event scripts, timer expiration scripts and tag-based scripting scripts have been combined into single scripts that handle all events, at all levels (module, area, item, etc.).

Edward Beck's original code and documentation can still be found on the [Neverwinter Vault](https://neverwintervault.org/project/nwn1/script/hcr2-nwn1-core-framework-and-systems-final-nbde-hcr2-15).

## Core-Framework
The core-framework is an advanced event handling/management system designed for NWN1/EE and is compatible with NWNXEE.  It includes event management, database access (SQLite, MySQL, Campaign Database), timing functions and advanced debugging functions.  Additionally, it provides library and script routing functions.

Michael Sinclair's original code and documentation can be found at his public [core-framework GitHub repository](https://github.com/squattingmonk/nwn-core-framework).









