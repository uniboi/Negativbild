untyped
global function InitNegativTestMenu
global function InitNegativTestMenuAddFooter

struct {
	var menu
	table<string, var> picker
} file

void function InitNegativTestMenu()
{
	#if NEGATIVBILD_DEV
		AddMenu( "NegativTestMenu", $"resource/ui/menus/negativ_test_menu.menu", ShowProfilesMenu )
		file.menu = GetMenu( "NegativTestMenu" )

		AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnProfileMenuOpened )
		AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, OnProfileMenuClosed )

		file.picker = RegisterColorPicker( Hud_GetChild( file.menu, "ColorPicker" ) )
	#endif
}

void function InitNegativTestMenuAddFooter()
{
	#if NEGATIVBILD_DEV
	AddMenuFooterOption( GetMenu( "MainMenu" ), BUTTON_X, PrependControllerPrompts( BUTTON_X, " Profiles" ), "Profiles", void function(var button){AdvanceMenu( GetMenu( "ProfilesMenu" ) )} )
	ScrollableList sl1 = RegisterScrollableList( Hud_GetChild( file.menu, "TestList" ), [
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"],
		[
			BuildScrollbarContentListener( UIE_GET_FOCUS,
				void function( var button, ScrollbarContent sc )
				{
					printt( "FOCUS: " + sc.title )
				}
			),
			BuildScrollbarContentListener( UIE_CLICK,
				void function( var button, ScrollbarContent sc )
				{
					printt( "CLICK: " + sc.title )
				}
			)
		]
	)
	ScrollableList sl2 = RegisterScrollableList( Hud_GetChild( file.menu, "TestList2" ),
		["item 1", "item 2", "item 3", "item 4"],
		[BuildScrollbarContentListener( UIE_CLICK,
			void function( var button, ScrollbarContent sc )
			{
				printt( sc.title )
				sc.SetDisabled( true )
			}
		)]
	)

	RegisterToolTip( file.menu, Hud_GetChild( file.menu, "Tooltip" ) )

	// AddTooltipToElement( Hud_GetChild( file.menu, "TooltipButton1" ), "test 1" )
	// AddTooltipToElement( Hud_GetChild( file.menu, "TooltipButton2" ), "Really Long Tooltip" )
	AddTooltipToElement( Hud_GetChild( file.menu, "TooltipButton3" ), "WOW so cool", 150 )

	// RegisterDropDownMenu( Hud_GetChild( file.menu, "DropDownButton1" ) )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "DropDownButton1" ), UIE_CLICK,
		void function( var button )
		{
			thread void function()
			{
				OpenDropDown( ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"] )
				table res = WaitSignal( uiGlobal.signalDummy, "DropDownSelected" )
				printt(res.title, res.index)
			}()
		}
	)

	thread void function() : ( sl2 )
	{
		wait 2.0
		UpdateScrollableListContent( sl2, [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"] )
	}()

	#endif
}

#if NEGATIVBILD_DEV

	void function OnProfileMenuOpened()
	{
		// Signal( uiGlobal.signalDummy, "ColorPickerRevive", { picker = file.picker } )

		thread void function()
		{
			while( true )
			{
				printt( WaitSignal( uiGlobal.signalDummy, "ColorPickerSelected" ) )
			}
		}()
	}

	void function OnProfileMenuClosed()
	{
		// Signal( uiGlobal.signalDummy, "ColorPickerKill" )
	}


	void function ShowProfilesMenu()
	{
		AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
		printt( bool(RandomInt(1)))
	}

#endif