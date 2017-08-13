# UnrealMacroNuke
*[Unreal Engine tool] Include that 3rd-party library in a decontaminated macro environment*

If you have ever tried to include a 3rd party library into an Unreal Engine project, you probably know by now that UE pollutes the macro environment with macros like check(), dynamic_cast() etc., causing compile failures for virtually anything you try to include. Related discussions on the web:
  - https://answers.unrealengine.com/questions/391017/constant-library-conflicts.html
  - https://answers.unrealengine.com/questions/664876/ue-macros-and-3rd-party-library-conflicts.html
  - https://forums.unrealengine.com/showthread.php?123809-Enabling-C-14-using-Sol2-Lua-wrapper
  - https://github.com/ThePhD/sol2/issues/235

This small script scans all UE headers in the Runtime/ folder and generates a pair of header files for temporarily undefining (almost) all macros that are defined there. Macros starting with an underscore are ignored, because UE touches some Visual Studio macros, too, and just blindly undefining them would break VS.

## Download

If you have Cygwin, MSYS2 or something alike installed, then you can download and run the script by yourself. Otherwise, download a generated pair of headers for your version of UE from the [releases page](https://github.com/hiili/UnrealMacroNuke/releases).

## Usage

Due to some compiler switches that Unreal Engine enables, you probably need to disable also some warnings. If you know that your 3rd-party library compiles cleanly in a clean non-UE project, then just keep disabling any warnings you get with UE, as shown below, and pray. :)

```cpp
#pragma warning( push )
#pragma warning( disable: <...> )    // For example: 4268 4582 4583 4868

#include "UndefineMacros_UE_4.17.h"
#include "your/third/party/library.hpp"
#include "RedefineMacros_UE_4.17.h"

#pragma warning( pop )
```

Also, please consider dropping a vote or a comment in the aforementioned Answerhub questions to give Epic some pressure to fix this madness for good.
