global function DropDownSubMenu_Init
global function OpenDropDown

struct {
    ScrollableList& sl
} file

const MAX_LIST_NODES = 5

void function DropDownSubMenu_Init()
{
    AddSubmenu( "DropDownMenu", $"resource/ui/menus/internal/dropdown.menu", InitDropDownMenu )
}

void function InitDropDownMenu()
{
    var menu = GetMenu( "DropDownMenu" )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnDropDown_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnDropDown_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnDropDown_NavigateBack )

	var screen = Hud_GetChild( menu, "Screen" )
	var rui = Hud_GetRui( screen )
	RuiSetFloat( rui, "basicImageAlpha", 0.0 )
	Hud_AddEventHandler( screen, UIE_CLICK, OnDropDown_BGActivate )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	file.sl = RegisterScrollableList( Hud_GetChild( menu, "OptionsList" ), [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16" ],
		[
			_ScrollbarContentListener( UIE_CLICK,
				void function( var button, ScrollbarContent sc )
				{
					printt( "CLICK:", sc.title, sc.contentIndex )
				}
			)
		]
	)
}

void function OnDropDown_Open()
{

}

void function OnDropDown_Close()
{

}

void function OnDropDown_BGActivate( var button )
{
    OnDropDown_NavigateBack()
}

void function OnDropDown_NavigateBack()
{
    CloseSubmenu()
}

// void function RegisterDropDownMenu( var opener )
// {
//     Hud_AddEventHandler( opener, UIE_CLICK, OpenDropDown )
// }

void function OpenDropDown( array<string> contents )
{
    OpenDropDownSubmenu( GetMenu( "DropDownMenu" ) )

    int height = contents.len() * SCROLLBAR_ITEM_HEIGHT

    if( contents.len() > MAX_LIST_NODES )
    {
        height = MAX_LIST_NODES * SCROLLBAR_ITEM_HEIGHT
    }
    // UpdateScrollableListHeight( file.sl, 250 )
    UpdateScrollableListContent( file.sl, contents, height )
    Hud_SetHeight( Hud_GetChild( GetMenu( "DropDownMenu" ), "Frame" ), height )
}

//? maybe change back to OpenSubmenu instead

// slightly modified version of OpenSubmenu in _menus.nut
void function OpenDropDownSubmenu( var menu, bool updateMenuPos = true )
{
	if ( uiGlobal.activeMenu )
	{
		// Don't open the same menu again if it's already open
		if ( uiGlobal.activeMenu == menu )
			return
	}

	array submenuPos = expect array( Hud_GetAbsPos( GetFocus() ) )

	uiGlobal.menuStack.push( menu )
	uiGlobal.activeMenu = menu

	OpenMenuWrapper( uiGlobal.activeMenu, true )

	if ( updateMenuPos )
	{
		var vguiButtonFrame = Hud_GetChild( uiGlobal.activeMenu, "Frame" )
		Hud_SetPos( vguiButtonFrame, expect int( submenuPos[0] ), expect int( submenuPos[1] ) + Hud_GetHeight( GetFocus() ) )
	}

	uiGlobal.lastMenuNavDirection = MENU_NAV_FORWARD

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}