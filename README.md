# Core Framework

This project is a framework for managing a [Neverwinter
Nights](https://neverwintervault.org) module. At the most basic, it is a set of
scripts to hook all events in a module. Scripts can then subscribe to the hooks
and be run when the event is triggered. This allows the module builder to
modularize script systems instead of combining scripts.

This system is in alpha. Things will change and will break. You have been
warned.

## Prerequisites
- NWN:EE >= v87.8193.34
- [nwnsc](https://github.com/nwneetools/nwnsc)
- [neverwinter.nim](https://github.com/niv/neverwinter.nim) >= 1.5.5
- [nasher](https://github.com/squattingmonk/nasher) >= 0.20.x

## Installation
Get the code:
```
git clone https://github.com/squattingmonk/nwn-core-framework.git
cd nwn-core-framework
git submodule update --init
```

Run the build script:
```
nasher install demo erf
```

This will create the following files in your Neverwinter Nights user directory:
- `modules/core_framework.mod`: a demo module showing the framework in action
  (currently a barebones testing ground).
- `erf/core_framework.erf`: an installable erf for use in new or existing
  modules.

Note: `sm-utils` relies on script extensions added by
[nwnsc](https://github.com/nwneetools/nwnsc). This prevents error messages when
compiling with `nwnsc`, but prevents compilation in the Toolset. If you want to
compile the scripts in the toolset instead, you can comment out the lines
beginning with `#pragma` near the bottom of the script `util_i_library.nss`.
Note that `util_i_library.nss` will still not compile on its own, since it's
meant to be included in other scripts that implement its functions.

## Usage
- Import `core_framework.erf` into your module.
- Read and customize `core_c_config.nss`. If you make changes, be sure to
  recompile all scripts.
- Set the module's `OnModuleLoad` event script to `hook_nwn.nss`. If you set
  `AUTO_HOOK_MODULE_EVENTS` in `core_c_config.nss` to `FALSE`, you will need to
  set all other module events to `hook_nwn.nss` as well.
- Set other event scripts to `hook_nwn.nss` as you wish. You can do this
  manually in the toolset or by script using `HookObjectEvents()` from
  `core_i_framework.nss`.

Note: some events may be triggered before the module loads. An example is the
OnAreaEnter event being triggered by NPCs placed in the toolset. If you want to
capture these, you will either have to set those event scripts to `hook_nwn.nss`
manually or somehow call `InitializeCoreFramework()` from `core_i_framework.nss`
before they are run (e.g., using NWNX).

## Acknowledgements
This system was heavily influenced by [HCR2](https://neverwintervault.org/project/nwn1/script/hcr2-nwn1-core-framework-and-systems-final-nbde-hcr2-15)
and EPOlson's [Common Scripting Framework](https://neverwintervault.org/project/nwn2/script/csf-common-scripting-framework).

Huge thanks to @tinygiant98 for his continued testing and contributions.
