params
[
        ["_mode","",[""]],
        ["_params",[],[[]]]
];

#include "\a3\ui_f\hpp\definedikcodes.inc"

#define DISPLAY (uiNamespace getVariable ["asaayu_stringtable_display",displayNull])

#define LIST (DISPLAY displayCtrl 2000)

#define SEARCH_EDIT (DISPLAY displayCtrl 3000)
#define SEARCH_BUTTON (DISPLAY displayCtrl 4000)

#define COPY_BUTTON (DISPLAY displayCtrl 5000)
#define EXPORT_BUTTON (DISPLAY displayCtrl 6000)

#define ORIGIN_COMBO (DISPLAY displayCtrl 7000)
#define LANGUAGE_COMBO (DISPLAY displayCtrl 8000)

#define BUSY_BACKGROUND (DISPLAY displayCtrl 55000)
#define BUSY_BACKGROUND_PRELOADING (DISPLAY displayCtrl 56000)

switch _mode do
{
        case "onload":
        {
                _params params [["_display",displayNull,[displayNull]]];
                uiNamespace setVariable ["asaayu_stringtable_display",_display];

                missionNamespace setVariable ["stringtable_viewer_origin","a3"];
                missionNamespace setVariable ["stringtable_viewer_origin_index",0];
                missionNamespace setVariable ["stringtable_viewer_language",language];

                private _languages = ("true" configClasses (configfile >> "CfgLanguages")) apply {configname _x};
                missionNamespace setVariable ["stringtable_viewer_language_index",_languages find language];

                ["preload"] spawn STRINGTABLE_fnc_stringtable_viewer;
        };
        case "preload":
        {
                if (uiNamespace getVariable ["stringtable_viewer_allow_preload",true]) then
                {
                        private _diag_ticktime = diag_ticktime;

                        startLoadingScreen [""];
                        private _languages = ("true" configClasses (configfile >> "CfgLanguages")) apply {configname _x};
                        private _master = ("true" configClasses (configfile >> "cfgstringtables")) apply {
                                [configname _x,("true" configClasses _x) apply {
                                        private _key = _x;
                                       [configname _x,_languages apply {str parseText getText(_key >> _x)}]
                                }]
                        };
                        
                        uiNamespace setVariable ["stringtable_viewer_allow_preload",false];
                        uiNamespace setVariable ["stringtable_viewer_data",_master];
                        endLoadingScreen;

                        private _time = diag_ticktime - _diag_ticktime;
                        diag_log format[localize "STR_STRINGTABLE_PRELOAD_DIAG_LOG",str _time];
                };
                BUSY_BACKGROUND_PRELOADING ctrlShow false;
                BUSY_BACKGROUND_PRELOADING ctrlCommit 0;

                ["initgui"] call STRINGTABLE_fnc_stringtable_viewer;
                ["eventhandlers"] call STRINGTABLE_fnc_stringtable_viewer;
                ["loadstringtable"] spawn STRINGTABLE_fnc_stringtable_viewer;

                SEARCH_EDIT ctrlSetText "";
                SEARCH_EDIT ctrlSetTooltip "";
                SEARCH_EDIT ctrlCommit 0;
        };
        case "initgui":
        {
                private _languages = "true" configClasses (configfile >> "CfgLanguages");
                {
                        private _name = getText (_x >> "name");
                        private _configname = configName _x;
                        private _index = LANGUAGE_COMBO lbAdd format["%1 (%2)",_name,_configname];
                        LANGUAGE_COMBO lbSetData [_index, _configname];
                        if (language isEqualTo _configname) then
                        {
                                LANGUAGE_COMBO lbSetCurSel _index;
                        };
                } foreach _languages;
                private _origins = "true" configClasses (configfile >> "cfgstringtables");
                {
                        private _name = getText (_x >> "displayName");
                        private _configname = configName _x;
                        private _index = ORIGIN_COMBO lbAdd format["%1 (%2)",_name,_configname];
                        ORIGIN_COMBO lbSetData [_index, _configname];
                } foreach _origins;
                ORIGIN_COMBO lbSetCurSel 0;

                SEARCH_EDIT ctrlSetText "";

                { _x ctrlCommit 0 } count [LIST, SEARCH_EDIT, SEARCH_BUTTON, COPY_BUTTON, EXPORT_BUTTON, ORIGIN_COMBO, LANGUAGE_COMBO];
        };
        case "eventhandlers":
        {
                DISPLAY displayAddEventHandler ["KeyDown",{ ["keydown",_this] call STRINGTABLE_fnc_stringtable_viewer }];
                ORIGIN_COMBO ctrlAddEventHandler ["LBSelChanged",{ ["lbselchanged",[0,_this#1]] call STRINGTABLE_fnc_stringtable_viewer }];
                LANGUAGE_COMBO ctrlAddEventHandler ["LBSelChanged",{ ["lbselchanged",[1,_this#1]] call STRINGTABLE_fnc_stringtable_viewer }];
                SEARCH_BUTTON ctrlAddEventHandler ["ButtonClick",{ ["search",[tolower ctrlText SEARCH_EDIT]] spawn STRINGTABLE_fnc_stringtable_viewer }];
                COPY_BUTTON ctrlAddEventHandler ["ButtonClick",{ ["KeyDown",[nil,DIK_C,false,true]] call STRINGTABLE_fnc_stringtable_viewer }];
                EXPORT_BUTTON ctrlAddEventHandler ["ButtonClick",{ ["KeyDown",[nil,DIK_X,false,true]] call STRINGTABLE_fnc_stringtable_viewer }];
        };
        case "keydown":
        {
                _params params ["_control", "_keydown_key", "_shift", "_ctrl", "_alt"];
                private _key = LIST lnbText [lbCurSel LIST,0];
                switch true do
                {
                        // Enter, Numpad Enter
                        case (_keydown_key in [DIK_RETURN,DIK_NUMPADENTER]):
                        {
                                ["search",[tolower ctrlText SEARCH_EDIT]] spawn STRINGTABLE_fnc_stringtable_viewer;
                                true
                        };
                        // Ctrl-C
                        case (_ctrl && {_keydown_key == DIK_C && {_key != ""}}):
                        {
                                playSound "RscDisplayCurator_ping01";
                                copyToClipboard format['%1',_key];
                                true
                        };
                        // Ctrl-X
                        case (_ctrl && {_keydown_key == DIK_X && {_key != ""}}):
                        {

                                playSound "RscDisplayCurator_ping06";
                                copyToClipboard format['localize "%1"',_key];
                                true
                        };
                        default {false};
                };
        };
        case "lbselchanged":
        {
                _params params ["_ctrl_index","_index"];
                private _ctrl = [ORIGIN_COMBO, LANGUAGE_COMBO] select _ctrl_index;
                private _old_variables = [stringtable_viewer_origin,stringtable_viewer_language];
                switch _ctrl_index do
                {
                        // Origin
                        case 0:
                        {
                                stringtable_viewer_origin = _ctrl lbData _index;
                                stringtable_viewer_origin_index = _index;
                        };
                        // Language
                        case 1:
                        {
                                stringtable_viewer_language = _ctrl lbData _index;
                                stringtable_viewer_language_index = _index;
                        };
                };
                if !(_old_variables isEqualTo [stringtable_viewer_origin,stringtable_viewer_language]) then
                {
                        ["search",[tolower ctrlText SEARCH_EDIT]] spawn STRINGTABLE_fnc_stringtable_viewer;
                };
        };
        case "loadstringtable":
        {
                _params params [["_search_term",""]];

                lnbClear LIST;

                private _diag_ticktime = diag_ticktime;

                private _keys = uiNamespace getVariable ["stringtable_viewer_data",[]];
                if (count _keys < 0) exitWith { systemchat "Error: View data < 0"; };
                {
                        _x params ["_key","_text_list"];
                        private _text = _text_list#stringtable_viewer_language_index;
                        if (_search_term isEqualTo "" || {_search_term in toLower _key || _search_term in toLower _text}) then {
                                private _row = LIST lnbAddRow [_key, _text, str 1];
                                LIST lnbSetTooltip [[_row,0], _text];
                        };
                } foreach ((_keys#stringtable_viewer_origin_index)#1);

                private _time = diag_ticktime - _diag_ticktime;
                diag_log format[localize "STR_STRINGTABLE_INFO_DIAG_LOG",stringtable_viewer_origin,stringtable_viewer_language,str _time];
        };
        case "search":
        {
                BUSY_BACKGROUND ctrlShow true;
                ctrlSetFocus BUSY_BACKGROUND;
                BUSY_BACKGROUND ctrlCommit 0;

                ["loadstringtable",_params] call stringtable_fnc_stringtable_viewer;

                BUSY_BACKGROUND ctrlShow false;
                BUSY_BACKGROUND ctrlCommit 0;
        };
};
