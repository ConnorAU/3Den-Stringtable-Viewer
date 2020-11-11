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
		onTerrainNew="if ('Preferences' get3DENMissionAttribute '3DENStringtableViewer_EnablePreloading') then {['preload'] spawn STRINGTABLE_fnc_stringtable_viewer;}";
	};
};
class Mission {
	class Preferences {
		class AttributeCategories {	
			class Misc {
				class Attributes {
					class 3DENStringtableViewer_EnablePreloading
					{
					  displayName = $STR_STRINGTABLE_3DEN_PREFERENCES_ENABLEPRELOADING_DISPLAYNAME;
       				          tooltip = $STR_STRINGTABLE_3DEN_PREFERENCES_ENABLEPRELOADING_TOOLTIP;
					  property = "3DENStringtableViewer_EnablePreloading";
					  control = "Checkbox";
					  expression = "";
					  defaultValue = "false";
					};
				};
			};
		};
	};
};				
};
