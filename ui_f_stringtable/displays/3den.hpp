class display3DEN
{
       class Controls
	{
		class MenuStrip: ctrlMenuStrip
		{
			class Items
			{
                                items[] += {"stringtable_tools"};
                                class Seperator;
				class stringtable_tools
				{
                                        text = "Stringtable Viewer";
					items[] =
                                        {
                                                "stringtable_open"
                                        };
				};
                                class stringtable_open
				{
					text = "Stingtable Viewer";
                                        data = "stringtable_open_data";
                                        opensNewWindow = 1;
					action = "(findDisplay 313) createDisplay 'stringtable_viewer';";
				};
			};
		};
	};
};
