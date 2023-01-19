untyped
global function InitProfilesMenu
global function ProfilesAddFooter

struct {
	var menu
	var colorTile
} file

void function InitProfilesMenu()
{
	AddMenu( "ProfilesMenu", $"resource/ui/menus/profiles_menu.menu", ShowProfilesMenu )
	file.menu = GetMenu( "ProfilesMenu" )
}

void function ProfilesAddFooter()
{
	AddMenuFooterOption( GetMenu( "MainMenu" ), BUTTON_X, PrependControllerPrompts( BUTTON_X, " Profiles" ), "Profiles", void function(var button){AdvanceMenu( GetMenu( "ProfilesMenu" ) )} )
	ScrollableList sl1 = RegisterScrollableList( Hud_GetChild( file.menu, "TestList" ), [
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"],
		[
			_ScrollbarContentListener( UIE_GET_FOCUS,
				void function( var button, ScrollbarContent sc )
				{
					printt( "FOCUS: " + sc.title )
				}
			),
			_ScrollbarContentListener( UIE_CLICK,
				void function( var button, ScrollbarContent sc )
				{
					printt( "CLICK: " + sc.title )
				}
			)
		]
	)
	ScrollableList sl2 = RegisterScrollableList( Hud_GetChild( file.menu, "TestList2" ), [
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"],
		[_ScrollbarContentListener( UIE_CLICK,
			void function( var button, ScrollbarContent sc )
			{
				sc.SetDisabled( true )
			}
		)]
	)

	RegisterToolTip( file.menu, Hud_GetChild( file.menu, "Tooltip" ) )

	AddTooltipToElement( Hud_GetChild( file.menu, "TooltipButton1" ), "test 1" )
	AddTooltipToElement( Hud_GetChild( file.menu, "TooltipButton2" ), "Really Long Tooltip" )
	AddTooltipToElement( Hud_GetChild( file.menu, "TooltipButton3" ), "WOW so cool", 150 )

	// RegisterDropDownMenu( Hud_GetChild( file.menu, "DropDownButton1" ) )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "DropDownButton1" ), UIE_CLICK,
		void function( var button )
		{
			OpenDropDown( ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"] )
			// OpenDropDown( [ "a", "b", "c", "d", "e" ] )
		}
	)
}

void function ShowProfilesMenu()
{
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	printt( bool(RandomInt(1)))
}