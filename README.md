# Core Framework

This project is a framework for managing a [Neverwinter
Nights](https://neverwintervault.org) module.

This system is in alpha. Things will change and will break. You have been
warned.

## Prerequisites
- [nwnsc](https://github.com/nwneetools/nwnsc)
- [neverwinter.nim](https://github.com/niv/neverwinter.nim) >= 1.5.5
- [nasher](https://github.com/squattingmonk/nasher) >= 0.18.x
- [sm-utils](https://github.com/squattingmonk/sm-utils)
- [sm-dialogs](https://github.com/squattingmonk/sm-dialogs)

## Installation
Get the code:
```
git clone https://github.com/squattingmonk/nwn-core-framework.git
git clone https://github.com/squattingmonk/sm-utils.git
git clone https://github.com/squattingmonk/sm-dialogs.git
```

Run the build script:
```
cd nwn-core-framework
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

## Acknowledgements

This system was heavily influenced by [HCR2](https://neverwintervault.org/project/nwn1/script/hcr2-nwn1-core-framework-and-systems-final-nbde-hcr2-15)
and EPOlson's [Common Scripting Framework](https://neverwintervault.org/project/nwn2/script/csf-common-scripting-framework).
