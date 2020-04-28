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
// Preload functions
	case "preload":
	{
		private _stringtables = [
			["Arma 3",[
				"\a3\3den_language\stringtable.xml",
				"\a3\language_f_mod\stringtable.xml",
				"\a3\language_f_tank\stringtable.xml",
				"\a3\language_f_mp_mark\stringtable.xml",
				"\a3\languagemissions_f_mp_mark\stringtable.xml",
				"\a3\language_f_argo\stringtable.xml",
				"\a3\language_f\stringtable.xml",
				"\a3\language_f_orange\stringtable.xml",
				"\a3\language_f_oldman\stringtable.xml",
				"\a3\languagemissions_f_mark\stringtable.xml",
				"\a3\languagemissions_f_jets\stringtable.xml",
				"\a3\language_f_exp\stringtable.xml",
				"\a3\languagemissions_f_heli\stringtable.xml",
				"\a3\language_f_destroyer\stringtable.xml",
				"\a3\languagemissions_f_kart\stringtable.xml",
				"\a3\language_f_epc\stringtable.xml",
				"\a3\language_f_epa\stringtable.xml",
				"\a3\language_f_curator\stringtable.xml",
				"\a3\language_f_beta\stringtable.xml",
				"\a3\languagemissions_f_patrol\stringtable.xml",
				"\a3\language_f_epb\stringtable.xml",
				"\a3\language_f_heli\stringtable.xml",
				"\a3\language_f_gamma\stringtable.xml",
				"\a3\language_f_jets\stringtable.xml",
				"\a3\language_f_kart\stringtable.xml",
				"\a3\language_f_mark\stringtable.xml",
				"\a3\languagemissions_f_orange\stringtable.xml",
				"\a3\language_f_patrol\stringtable.xml",
				"\a3\language_f_exp_b\stringtable.xml",
				"\a3\language_f_sams\stringtable.xml",
				"\a3\languagemissions_f_tank\stringtable.xml",
				"\a3\language_f_bootcamp\stringtable.xml",
				"\a3\language_f_warlords\stringtable.xml",
				"\a3\language_f_exp_a\stringtable.xml",
				"\a3\language_f_enoch\stringtable.xml",
				"\a3\language_f_tacops\stringtable.xml",
				"\a3\languagemissions_f_tacops\stringtable.xml",
				"\a3\languagemissions_f_enoch\stringtable.xml",
				"\languagecore_f\stringtable.xml"
			]]
		];

		if (uiNamespace getVariable ["stringtable_viewer_allow_preload",true]) then
		{
			private _diag_ticktime = diag_ticktime;

			startLoadingScreen [""];
			private _master = ["parsestringtables",_stringtables] call STRINGTABLE_fnc_stringtable_viewer;

			uiNamespace setVariable ["stringtable_viewer_allow_preload",false];
			uiNamespace setVariable ["stringtable_viewer_data",_master];
			endLoadingScreen;

			private _time = diag_ticktime - _diag_ticktime;
			diag_log format[localize "STR_STRINGTABLE_PRELOAD_DIAG_LOG",str _time];
		};
		BUSY_BACKGROUND_PRELOADING ctrlShow false;
		BUSY_BACKGROUND_PRELOADING ctrlCommit 0;

		["initgui",_stringtables apply {_x#0}] call STRINGTABLE_fnc_stringtable_viewer;
		["eventhandlers"] call STRINGTABLE_fnc_stringtable_viewer;
		["loadstringtable"] spawn STRINGTABLE_fnc_stringtable_viewer;

		SEARCH_EDIT ctrlSetText "";
		SEARCH_EDIT ctrlSetTooltip "";
		SEARCH_EDIT ctrlCommit 0;
	};
	case "parsestringtables":{
		_params params ["_stringtables"];

		private _languages = ("true" configClasses (configfile >> "CfgLanguages")) apply {tolower configname _x};
		private _output = [];
		{
			private _strings = [];
			{
				_strings append (["extractstringsfromtable",[_x,_languages]] call STRINGTABLE_fnc_stringtable_viewer);
			} forEach (_x#1);
			_output pushback [_x#0,_strings];
		} forEach _params;

		_output
	};
	case "extractstringsfromtable":{
		private _stringStartsWith = {
			params ["_string","_search"];
			tolower _string find tolower _search == 0;
		};

		_params params ["_filePath","_languages"];
		private _stringtable = ((loadFile _filePath) splitString "<>") select {count(toarray _x - [9,10,13,32]) > 0};
		private _strings = [];
		private _activeKey = "";
		private _activeStrings = [];
		_activeStrings resize count _languages;
		private _x = "";

		for "_i" from 0 to (count _stringtable - 1) do {
			_x = _stringtable # _i;

			if (_activeKey == "") then {
				if ([_x,"key "] call _stringStartsWith) then {
					private _key = _x splitstring " ='""";
					_activeKey = _key param [((_key apply {tolower _x}) find "id") + 1,""];
				};
			} else {
				if (_x == "/key") then {
					_strings pushback [_activeKey,_activeStrings apply {if (isNil {_x}) then {""} else {_x}}];
					_activeKey = "";
					_activeStrings = [];
				} else {
					if (tolower _x in _languages) then {
						private _x1 = _stringtable # (_i + 1);
						private _x2 = _stringtable # (_i + 2);
						if (_x2 == format["/%1",_x]) then {
							_activeStrings set [_languages find tolower _x,str parseText _x1];
							_i = _i + 2;
						} else {
							if (_x1 == format["/%1",_x]) then {
								_activeStrings set [_languages find tolower _x,""];
								_i = _i + 1;
							};
						};
					};
				};
			};
		};

		_strings
	};

// UI functions
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
		{
			private _index = ORIGIN_COMBO lbAdd _x;
			ORIGIN_COMBO lbSetData [_index, _x];
		} foreach _params;
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
		COPY_BUTTON ctrlAddEventHandler ["ButtonClick",{ ["keydown",[nil,DIK_C,false,true]] call STRINGTABLE_fnc_stringtable_viewer }];
		EXPORT_BUTTON ctrlAddEventHandler ["ButtonClick",{ ["keydown",[nil,DIK_X,false,true]] call STRINGTABLE_fnc_stringtable_viewer }];
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
			// Ctrl-F
			case (_ctrl && {_keydown_key == DIK_F && {_key != ""}}):
			{
				ctrlSetFocus SEARCH_EDIT;
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
				private _row = LIST lnbAddRow [_key, _text, ""];
				LIST lnbSetTooltip [[_row,0], _text];
			};
		} foreach ((_keys#stringtable_viewer_origin_index)#1);

		private _time = diag_ticktime - _diag_ticktime;
		diag_log format[localize "STR_STRINGTABLE_INFO_DIAG_LOG",stringtable_viewer_origin,stringtable_viewer_language,str _time,(lnbSize LIST)#0];
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
