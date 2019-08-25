# Core Framework

This project is a framework for managing a [Neverwinter
Nights](https://neverwintervault.org) module.

This system is in alpha. Things will change and will break. You have been
warned.

## Prerequisites
- [nwnsc](https://gitlab.com/glorwinger/nwnsc)
- [neverwinter.nim](https://github.com/niv/neverwinter.nim)
- [nasher.nim](https://github.com/squattingmonk/nasher.nim)

## Installation
Get the code:
```
git clone https://github.com/squattingmonk/nwn-core-framework.git
```

Run the build script:
```
cd nwn-core-framework
nasher install all
```

This will create the following files in your Neverwinter Nights install
directory:
- `modules/core_framework.mod`: a demo module showing the framework in action
  (currently a barebones testing ground).
- `erf/core_framework.erf`: an installable erf for use in new or existing
  modules.
- `erf/core_utilities.erf`: an installable erf with stand-alone utilities for
  use in new or existing module. This contains all scripts in `src/utils`. You
  don't need this if you import `core_framework.erf`.

Note: `util_i_library.nss` relies on script extensions added by
[nwnsc](https://gitlab.com/glorwinger/nwnsc). This prevents error messages when
compiling with `nwnsc`, but prevents compilation in the Toolset. If you want to
compile the scripts in the toolset instead, you can comment out the lines
beginning with `#pragma` near the bottom of the script. Note that
`util_i_library.nss` will still not compile on its own, since it's meant to be
included in other scripts that implement its functions.

## Usage
- Utilities
  - [Debugging](docs/debugging.md)
  - [Datapoints](docs/datapoints.md)
  - [Lists](docs/lists.md)
  - [Libraries](docs/libraries.md)

## Acknowledgements
- This system was heavily influenced by
  [HCR2](https://neverwintervault.org/project/nwn1/script/hcr2-nwn1-core-framework-and-systems-final-nbde-hcr2-15)
  and EPOlson's [Common Scripting
  Framework](https://neverwintervault.org/project/nwn2/script/csf-common-scripting-framework).
- `util_i_varlists.nss` and `util_i_libraries.nss` adapted from
  [MemeticAI](https://sourceforge.net/projects/memeticai/).
