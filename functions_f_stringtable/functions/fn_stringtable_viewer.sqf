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

switch (tolower _mode) do
{
        case ("exit"):
        {
                DISPLAY closeDisplay 2;
        };
        case ("onload"):
        {
                _params params [["_display",displayNull,[displayNull]]];
                uiNamespace setVariable ["asaayu_stringtable_display",_display];

                missionNamespace setVariable ["stringtable_viewer_origin","a3"];
                missionNamespace setVariable ["stringtable_viewer_origin_index",0];
                missionNamespace setVariable ["stringtable_viewer_language",language];

                {
                        if ((tolower configName _x) isEqualTo (tolower language)) then
                        {
                                missionNamespace setVariable ["stringtable_viewer_language_index",_foreachindex];
                        };
                } foreach ("true" configClasses (configfile >> "CfgLanguages"));

                ["preload"] spawn STRINGTABLE_fnc_stringtable_viewer;
        };
        case ("onunload"):
        {
                _params params [["_display",displayNull,[displayNull]]];
                _display closeDisplay 2;
                uiNamespace setVariable ["asaayu_stringtable_display",displayNull];
        };
        case ("preload"):
        {
                private _check = (uiNamespace getVariable ["stringtable_viewer_allow_preload",true]);
                if (_check) then
                {
                        private _diag_ticktime = diag_ticktime;

                        startLoadingScreen [""];
                        private _languages = ("true" configClasses (configfile >> "CfgLanguages"));
                        private _origins = ("true" configClasses (configfile >> "cfgstringtables"));
                        private _master = [];
                        {
                                private _config = _x;
                                private _configname = configName _config;
                                private _keys = ("true" configClasses (_config));
                                private _data = [];
                                {
                                        private _key_text = [];
                                        private _config = _x;
                                        private _configname = configName _x;
                                        {
                                                // Need to parseText because some contin html entites :|
                                                private _text = str (parseText (getText (_config >> (configName _x))));
                                                _key_text pushBack _text
                                        } foreach _languages;
                                        _data pushBack [_configname,_key_text];
                                } foreach _keys;

                                _master pushBack [_configname, _data];
                        } foreach _origins;
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
        };
        case ("initgui"):
        {
                private _languages = ("true" configClasses (configfile >> "CfgLanguages"));
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
                private _origins = ("true" configClasses (configfile >> "cfgstringtables"));
                {
                        private _name = getText (_x >> "displayName");
                        private _configname = configName _x;
                        private _index = ORIGIN_COMBO lbAdd format["%1 (%2)",_name,_configname];
                        ORIGIN_COMBO lbSetData [_index, _configname];
                } foreach _origins;
                ORIGIN_COMBO lbSetCurSel 0;

                SEARCH_EDIT ctrlSetText "";

                { _x ctrlCommit 0 } foreach [LIST, SEARCH_EDIT, SEARCH_BUTTON, COPY_BUTTON, EXPORT_BUTTON, ORIGIN_COMBO, LANGUAGE_COMBO];
        };
        case ("eventhandlers"):
        {
                STRINGTABLE_KEYDOWN_EVH = DISPLAY displayAddEventHandler ["KeyDown",{ ["keydown",_this] call STRINGTABLE_fnc_stringtable_viewer }];
                ORIGIN_COMBO ctrlAddEventHandler ["LBSelChanged",{ ["lbselchanged",[0,(_this#1)]] call STRINGTABLE_fnc_stringtable_viewer }];
                LANGUAGE_COMBO ctrlAddEventHandler ["LBSelChanged",{ ["lbselchanged",[1,(_this#1)]] call STRINGTABLE_fnc_stringtable_viewer }];
                SEARCH_BUTTON ctrlAddEventHandler ["ButtonClick",{ ["search",[tolower (ctrlText SEARCH_EDIT)]] spawn STRINGTABLE_fnc_stringtable_viewer }];
                COPY_BUTTON ctrlAddEventHandler ["ButtonClick",{ ["KeyDown",[nil,DIK_C,false,true]] call STRINGTABLE_fnc_stringtable_viewer }];
                EXPORT_BUTTON ctrlAddEventHandler ["ButtonClick",{ ["KeyDown",[nil,DIK_X,false,true]] call STRINGTABLE_fnc_stringtable_viewer }];
        };
        case ("keydown"):
        {
                _params params ["_control", "_keydown_key", "_shift", "_ctrl", "_alt"];
                private _key = (["getkey"] call STRINGTABLE_fnc_stringtable_viewer);
                private _return = false;
                switch (true) do
                {
                        // Enter, Numpad Enter
                        case (_keydown_key in [DIK_RETURN,DIK_NUMPADENTER]):
                        {
                                ["search",[tolower (ctrlText SEARCH_EDIT)]] spawn STRINGTABLE_fnc_stringtable_viewer;
                                _return = true;
                        };
                        // Ctrl-C
                        case (_ctrl && {_keydown_key in [DIK_C] && {!(_key isEqualTo "")}}):
                        {
                                playSound "RscDisplayCurator_ping01";
                                copyToClipboard format['%1',_key];
                                _return = true;
                        };
                        // Ctrl-X
                        case (_ctrl && {_keydown_key in [DIK_X] && {!(_key isEqualTo "")}}):
                        {

                                playSound "RscDisplayCurator_ping06";
                                copyToClipboard format['localize "%1"',_key];
                                _return = true;
                        };
                };
                _return
        };
        case ("lbselchanged"):
        {
                _params params ["_ctrl_index","_index"];
                private _ctrl = ([ORIGIN_COMBO, LANGUAGE_COMBO] select _ctrl_index);
                private _old_variables = [stringtable_viewer_origin,stringtable_viewer_language];
                switch (_ctrl_index) do
                {
                        // Origin
                        case 0:
                        {
                                stringtable_viewer_origin = (_ctrl lbData _index);
                                stringtable_viewer_origin_index = _index;
                        };
                        // Language
                        case 1:
                        {
                                stringtable_viewer_language = (_ctrl lbData _index);
                                stringtable_viewer_language_index = _index;
                        };
                };
                if !(_old_variables isEqualTo [stringtable_viewer_origin,stringtable_viewer_language]) then
                {
                        ["search",[tolower (ctrlText SEARCH_EDIT)]] spawn STRINGTABLE_fnc_stringtable_viewer;
                };
        };
        case ("getkey"):
        {
                private _index = lbCurSel LIST;
                if (_index > -1) then
                {
                        (LIST lnbText [_index,0])
                } else { "" };
        };
        case ("loadstringtable"):
        {
                lnbClear LIST;

                private _diag_ticktime = diag_ticktime;

                private _keys = uiNamespace getVariable ["stringtable_viewer_data",[]];
                if (count _keys < 0) exitWith { systemchat "Error: View data < 0"; };
                {
                        _x params ["_key","_text_list"];
                        private _text = (_text_list#stringtable_viewer_language_index);
                        private _row = LIST lnbAddRow [_key, _text, str 1];
                        LIST lnbSetTooltip [[_row,0], _text];
                } foreach ((_keys#stringtable_viewer_origin_index)#1);

                private _time = diag_ticktime - _diag_ticktime;
                diag_log format[localize "STR_STRINGTABLE_INFO_DIAG_LOG",stringtable_viewer_origin,stringtable_viewer_language,str _time];

                SEARCH_EDIT ctrlSetText "";
                SEARCH_EDIT ctrlSetTooltip "";
                SEARCH_EDIT ctrlCommit 0;
        };
        case ("search"):
        {
                _params params ["_search_term"];

                BUSY_BACKGROUND ctrlShow true;
                ctrlSetFocus BUSY_BACKGROUND;
                BUSY_BACKGROUND ctrlCommit 0;

                private _diag_ticktime = diag_ticktime;

                lnbClear LIST;
                private _keys = uiNamespace getVariable ["stringtable_viewer_data",[]];
                {
                        _x params ["_key","_text_list"];
                        private _original_key = _key;
                        private _original_text = (_text_list#stringtable_viewer_language_index);
                        private _text = toLower _original_text;
                        private _key = toLower _original_key;
                        private _value = switch (true) do
                        {
                                case (_search_term isEqualTo ""):
                                {
                                        1
                                };
                                case ((_key find _search_term) > -1):
                                {
                                        1
                                };
                                case ((_text find _search_term) > -1):
                                {
                                        1
                                };
                                default
                                {
                                        0
                                };
                        };
                        if (_value > 0) then
                        {
                                private _row = LIST lnbAddRow [_original_key, _original_text, str 1];
                                LIST lnbSetTooltip [[_row,0], _original_text];
                        };
                } foreach ((_keys#stringtable_viewer_origin_index)#1);

                private _time = diag_ticktime - _diag_ticktime;
                diag_log format[localize "STR_STRINGTABLE_INFO_DIAG_LOG",stringtable_viewer_origin,stringtable_viewer_language,str _time];

                BUSY_BACKGROUND ctrlShow false;
                BUSY_BACKGROUND ctrlCommit 0;
        };
};
