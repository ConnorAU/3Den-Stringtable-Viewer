class stringtable_viewer {
	idd = 19995;
	enableSimulation = 1;
	onLoad = "['onload',_this] call stringtable_fnc_stringtable_viewer;";
	class controlsbackground {
		class background_tiles: ctrlStaticBackgroundDisableTiles {};
		class title: ctrlStaticTitle {
			x = "((getResolution select 2) * 0.5 * pixelW) - 94 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 6 * (pixelH * pixelGrid * 0.50)";
			w = "188 * (pixelW * pixelGrid * 0.50)";
			h = "6 * (pixelH * pixelGrid * 	0.50)";
			text = $STR_STRINGTABLE_TITLE;
		};
		class background: ctrlStaticBackground {
			x = "((getResolution select 2) * 0.5 * pixelW) - 94 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 12 * (pixelH * pixelGrid * 0.50)";
			w = "188 * (pixelW * pixelGrid * 0.50)";
			h = "132 * (pixelH * pixelGrid * 0.50)";
		};
		class stringtable_subtitle_background: background {
			h = "6 * (pixelH * pixelGrid * 	0.50)";
			colorBackground[] = {0,0,0,0.8};
		};
		class stringtable_list_background: stringtable_subtitle_background {
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 18 * (pixelH * pixelGrid * 0.50)";
			h = "120 * (pixelH * pixelGrid * 0.50)";
			colorBackground[] = {0,0,0,0.55};
		};
	};
	class controls {
		class exitButton: ctrlActivePicture {
			idc = 2;
			text = "A3\Ui_f\data\GUI\Rsc\RscDisplayArcadeMap\icon_exit_cross_ca.paa";
			x = "((getResolution select 2) * 0.5 * pixelW) + 88 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 6 * (pixelH * pixelGrid * 0.50)";
			w = "6 * (pixelW * pixelGrid * 	0.50)";
			h = "6 * (pixelH * pixelGrid * 	0.50)";
			tooltip = "Close";
			colorActive[] = {1,1,1,1};
		};
		class subtitle_key: ctrlStructuredText {
			idc = 9999;
			text = $STR_STRINGTABLE_SUBTITLE_KEY;
			tooltip = $STR_STRINGTABLE_TOOLTIP_KEY;
			x = "((getResolution select 2) * 0.5 * pixelW) - 94 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 12 * (pixelH * pixelGrid * 0.50)";
			w = "80 * (pixelW * pixelGrid *  0.50)";
			h = "6 * (pixelH * pixelGrid * 	0.50)";
			size = "5 * (pixelH * pixelGrid * 0.50)";
			sizeEx = "5 * (pixelH * pixelGrid * 0.50)";
			class Attributes {
				align = "left";
				color = "#ffffff";
				colorLink = "";
				size = 1;
				font = "PuristaBold";
			};
		};
		class subtitle_output: subtitle_key {
			idc = 9998;
			text = $STR_STRINGTABLE_SUBTITLE_OUTPUT;
			tooltip = $STR_STRINGTABLE_TOOLTIP_OUTPUT;
			x = "((getResolution select 2) * 0.5 * pixelW) + 0 * (pixelW * pixelGrid * 0.50)";
			w = "80 * (pixelW * pixelGrid *  0.50)";
		};
		class subtitle_number: subtitle_key {
			idc = 9997;
			text = $STR_STRINGTABLE_SUBTITLE_NUMBER;
			x = "((getResolution select 2) * 0.5 * pixelW) + 66 * (pixelW * pixelGrid * 0.50)";
			w = "(18*0) * (pixelW * pixelGrid *  0.50)";
		};

		class stringtable_list: ctrlListNBox {
			idc = 2000;
			x = "((getResolution select 2) * 0.5 * pixelW) - 94 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 18 * (pixelH * pixelGrid * 0.50)";
			w = "188 * (pixelW * pixelGrid *  0.50)";
			h = "120 * (pixelH * pixelGrid * 0.50)";

			blinkingPeriod = 0;
			shadow = 0; // Shadow (0 - none, 1 - directional, color affected by colorShadow, 2 - black outline)

			colorSelectBackground[] = {1,1,1,0.3}; // Selected item fill color
			colorSelectBackground2[] = {1,1,1,0.3}; // Selected item fill color (oscillates between this and colorSelectBackground)
			colorText[] = {1,1,1,1}; // Text and frame
			colorcolorDisabled[] = {1,1,1,0.5}; // Disabled text
			colorcolorSelect[] = {1,1,1,1}; // Text selection
			colorcolorSelect2[] = {1,1,1,1}; // Text selection color (oscillates between this and colorSelect)
			colorShadow[] = {0,0,0,0.5}; // Text shadow color (used only when shadow is 1)

			tooltip = ""; // Tooltip text
			columns[] = {0,0.5,0.97}; // Horizontal coordinates of columns (relative to list width, in range from 0 to 1)
			disableOverflow = true;

			drawSideArrows = 0; // 1 to draw buttons linked by idcLeft and idcRight on both sides of selected line. They are resized to line height
			idcLeft = -1; // Left button IDC
			idcRight = -1; // Right button IDC

			period = 0; // Oscillation time between colorSelect/colorSelectBackground2 and colorSelect2/colorSelectBackground when selected

			rowHeight = "0.4 * (pixelH * pixelGrid * 0.50)"; // Row height
			maxHistoryDelay = 1; // Time since last keyboard type search to reset it

			soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1}; // Sound played when an item is selected

			// Scrollbar configuration (applied only when LB_TEXTURES style is used)
			class ListScrollBar {
				width = 0; // width of ListScrollBar
				height = 0; // height of ListScrollBar
				scrollSpeed = 0.01; // scrollSpeed of ListScrollBar

				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically)
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically)

				color[] = {1,1,1,1}; // Scrollbar color
			};
		};
		class stringtable_search_edit: ctrlEdit {
			idc = 3000;
			style = 512;
			x = "((getResolution select 2) * 0.5 * pixelW) - 94 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 138 * (pixelH * pixelGrid * 0.50)";
			w = "40 * (pixelW * pixelGrid *  0.50)";
			h = "6 * (pixelH * pixelGrid * 	0.50)";
			tooltip = $STR_STRINGTABLE_TOOLTIP_EDIT_BOX;
			colorBackground[] = {
				0,
				0,
				0,
				0.4
			};
		};
		class searchEditButton: ctrlButtonSearch {
			idc = 4000;
			x = "((getResolution select 2) * 0.5 * pixelW) - 54 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 138 * (pixelH * pixelGrid * 0.50)";
			w = "6 * (pixelW * pixelGrid * 	0.50)";
			h = "6 * (pixelH * pixelGrid * 	0.50)";
			colorBackground[] = {0,0,0,0};
			colorBackgroundDisabled[] = {0,0,0,0};
			colorBackgroundActive[] = {
				"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08])",
				1
			};
			colorFocused[] = {0,0,0,0};
			tooltip = $STR_STRINGTABLE_BUTTON_SEARCH;
		};
		class searchCopyButton: SearchEditButton {
			idc = 5000;
			x = "((getResolution select 2) * 0.5 * pixelW) - 48 * (pixelW * pixelGrid * 0.50)";
			text = "\a3\3den\Data\Displays\Display3DEN\PanelLeft\entityList_duplicate_ca.paa";
			tooltip = $STR_STRINGTABLE_BUTTON_COPY;
		};
		class searchExportButton: SearchEditButton {
			idc = 6000;
			x = "((getResolution select 2) * 0.5 * pixelW) - 42 * (pixelW * pixelGrid * 0.50)";
			text = "\stringtable\ui_f_stringtable\data\export_to_clipboard_ca.paa";
			tooltip = $STR_STRINGTABLE_BUTTON_EXPORT;
		};
		class manageCustomFilepathsButton: SearchEditButton {
			idc = 6500;
			x = "((getResolution select 2) * 0.5 * pixelW) - 36 * (pixelW * pixelGrid * 0.50)";
			text = "\a3\3den\Data\Displays\Display3DEN\PanelLeft\entitylist_layer_ca.paa";
			tooltip = $STR_STRINGTABLE_BUTTON_CUSTOM_PATHS;
		};
		class comboStringtable: CtrlCombo {
			idc = 7000;
			x = "((getResolution select 2) * 0.5 * pixelW) - 30 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 138 * (pixelH * pixelGrid * 0.50)";
			w = "56 * (pixelW * pixelGrid * 0.50)";
			h = "6 * (pixelH * pixelGrid * 	0.50)";
			tooltip = $STR_STRINGTABLE_COMBO_ORIGIN;
		};
		class comboLanguage: CtrlCombo {
			idc = 8000;
			x = "((getResolution select 2) * 0.5 * pixelW) + 26 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 138 * (pixelH * pixelGrid * 0.50)";
			w = "56 * (pixelW * pixelGrid * 0.50)";
			h = "6 * (pixelH * pixelGrid * 	0.50)";
			tooltip = $STR_STRINGTABLE_COMBO_LANGUAGE;
		};
		class helpIcon: ctrlStaticPicture {
			text = "\stringtable\ui_f_stringtable\data\github_logo_light_ca.paa";
			x = "((getResolution select 2) * 0.5 * pixelW) + 82 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 138 * (pixelH * pixelGrid * 0.50)";
			w = "12 * (pixelW * pixelGrid * 0.50)";
			h = "6 * (pixelH * pixelGrid * 0.50)";
			tooltip = $STR_STRINGTABLE_GITHUB_TOOLTIP;
		};
		class helpLink: ctrlStructuredText {
			x = "((getResolution select 2) * 0.5 * pixelW) + 80.5 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 138 * (pixelH * pixelGrid * 0.50)";
			w = "15.2 * (pixelW * pixelGrid * 0.50)";
			h = "6 * (pixelH * pixelGrid * 0.50)";
			text = "<a href='https://github.com/Asaayu/3Den-Stringtable-Viewer'>AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA</a>";
			fade = 1;
			class Attributes {
				align = "left";
				color = "#ffffff";
				colorLink = "";
				size = 0.4;
				font = "PuristaLight";
			};
		};
		class background_busy: ctrlStatic {
			idc = 55000;
			style = 2;
			text = $STR_STRINGTABLE_INFO_LOADING;
			font = "PuristaBold";
			x = "((getResolution select 2) * 0.5 * pixelW) - 94 * (pixelW * pixelGrid * 0.50)";
			y = "0.5 - (safezoneH min (160 * (pixelH * pixelGrid * 0.50))) * 0.5 + 12 * (pixelH * pixelGrid * 0.50)";
			w = "188 * (pixelW * pixelGrid * 0.50)";
			h = "132 * (pixelH * pixelGrid * 0.50)";
			size = "10 * (pixelH * pixelGrid * 0.50)";
			sizeEx = "10 * (pixelH * pixelGrid * 0.50)";
			colorBackground[] = {0.2,0.2,0.2,0.7};
			show = 0;
		};
		class background_busy_preload: background_busy {
			idc = 56000;
			text = $STR_STRINGTABLE_INFO_PRELOADING;
			show = 1;
		};
	};
};
