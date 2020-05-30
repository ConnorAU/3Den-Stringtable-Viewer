#include "cfgpatches.hpp"

class Cfg3DEN {
    class Notifications {
		class 3DENStringtableViewer_preloading {
			isWarning = 0;
			text = "3den Stringtable Viewer: Preloading Strings"; // TODO: Localize
		};
    };
	class EventHandlers {
		class 3DENStringtableViewer {
			onTerrainNew="['preload'] spawn STRINGTABLE_fnc_stringtable_viewer;";
		};
	};
};