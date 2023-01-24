global function InitDropDownMenu
global function OpenDropDown
global function OpenDropDownCalc

struct {
    ScrollableList& sl
} file

const MAX_LIST_NODES = 5

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
					Signal( uiGlobal.signalDummy, "DropDownSelected", { title = sc.title, index = sc.contentIndex } )
					CloseSubmenu()
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
    CloseSubmenu()
}

void function OnDropDown_NavigateBack()
{
    CloseSubmenu()
}

// void function RegisterDropDownMenu( var opener )
// {
//     Hud_AddEventHandler( opener, UIE_CLICK, OpenDropDown )
// }

void function OpenDropDown_Internal( array<string> contents, int[2] functionref( var ) positionCallback )
{
    OpenDropDownSubmenu( GetMenu( "DropDownMenu" ), positionCallback )

    int height = contents.len() * SCROLLBAR_ITEM_HEIGHT

    if( contents.len() > MAX_LIST_NODES )
    {
        height = MAX_LIST_NODES * SCROLLBAR_ITEM_HEIGHT
    }
    // UpdateScrollableListHeight( file.sl, 250 )
    UpdateScrollableListContent( file.sl, contents, height )
    Hud_SetHeight( Hud_GetChild( GetMenu( "DropDownMenu" ), "Frame" ), height )
}

void function OpenDropDown( array<string> contents )
{
	OpenDropDown_Internal( contents, DefaultSubmenuPosition )
}

// Needed because default params need to be const and it's impossible to cast ornull to a functionref
void function OpenDropDownCalc( array<string> contents, int[2] functionref( var ) positionCallback )
{
	OpenDropDown_Internal( contents, positionCallback )
}

int[2] function DefaultSubmenuPosition( var frame )
{
	int[2] p
	vector ornull c = NSGetCursorPosition()

	if( c == null )
	{
		var focus = GetFocus()
		array focusPos = expect array( Hud_GetAbsPos( focus ) )
		p[0] = expect int( focusPos[0] ) + Hud_GetWidth( focus ) - Hud_GetWidth( frame )
		p[1] = expect int( focusPos[1] ) + Hud_GetHeight( focus )
	}
	else
	{
		expect vector( c )
		int[2] screenSize = GetScreenSize()

		if( c.x + Hud_GetWidth( frame ) > screenSize[0] )
			p[0] = screenSize[0] - Hud_GetWidth( frame )
		else
			p[0] = int( c.x )
		p[1] = int( c.y )
	}
	return p
}

// slightly modified version of OpenSubmenu in _menus.nut
void function OpenDropDownSubmenu( var menu, int[2] functionref( var ) positionCallback )
{
	if ( uiGlobal.activeMenu )
	{
		// Don't open the same menu again if it's already open
		if ( uiGlobal.activeMenu == menu )
			return
	}


	uiGlobal.menuStack.push( menu )
	uiGlobal.activeMenu = menu

	OpenMenuWrapper( uiGlobal.activeMenu, true )

	var vguiFrame = Hud_GetChild( uiGlobal.activeMenu, "Frame" )
	int[2] submenuPos = positionCallback( vguiFrame )
	Hud_SetPos( vguiFrame, submenuPos[0], submenuPos[1] )

	uiGlobal.lastMenuNavDirection = MENU_NAV_FORWARD

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}