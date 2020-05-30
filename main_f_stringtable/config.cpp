#include "cfgpatches.hpp"

class Cfg3DEN {
    class Notifications {
		class 3DENStringtableViewer_preloading_start {
			isWarning = 0;
			text = "$STR_STRINGTABLE_3DEN_NOTIFICATION_PRELOADING_START";
		};
		class 3DENStringtableViewer_preloading_end {
			isWarning = 0;
			text = "$STR_STRINGTABLE_3DEN_NOTIFICATION_PRELOADING_END";
		};
    };
	class EventHandlers {
		class 3DENStringtableViewer {
			onTerrainNew="['preload'] spawn STRINGTABLE_fnc_stringtable_viewer;";
		};
	};
};