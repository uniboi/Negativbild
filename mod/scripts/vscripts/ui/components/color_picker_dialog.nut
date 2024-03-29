global function ColorPickerDialog_Init
global function OpenColorPickerDialog

struct {
    table<string, var> picker
    string conVar
    var menu
	bool reset
} file

void function ColorPickerDialog_Init()
{
    AddSubmenu( "ColorPickerMenu", $"resource/ui/menus/internal/colorpicker_dialog.menu", InitColorPickerMenu )
}

void function InitColorPickerMenu()
{
	RegisterSignal( "ColorPickerDialogReset" )

    file.menu = GetMenu( "ColorPickerMenu" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnDialog_Open )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, OnDialog_Close )

	var screen = Hud_GetChild( file.menu, "Screen" )
	var rui = Hud_GetRui( screen )
	RuiSetFloat( rui, "basicImageAlpha", 0.0 )

	Hud_AddEventHandler( screen, UIE_CLICK, OnScreen_BGActivate )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "ResetButton" ), UIE_CLICK, OnResetButtonPressed )

//    file.picker = RegisterColorPicker( Hud_GetChild( file.menu, "ColorPicker" ) )
}

void function OnDialog_Open()
{
    Signal( uiGlobal.signalDummy, "ColorPickerRevive", { picker = file.picker } )
    array<string> split = split( GetConVarString( file.conVar ), " " )

		if( split.len() >= 3 )
		{
			Hud_SetColor( Hud_GetChild( file.menu, "LastColorIndicator" ), 255 * float( split[0] ), 255 * float( split[1] ), 266 * float( split[2] ) )
			Hud_SetColor( file.picker.indicator, 255 * float( split[0] ), 255 * float( split[1] ), 266 * float( split[2] ) )
		}
		else
		{
			Hud_SetColor( file.picker.indicator, 255, 255, 255 )
		}
}

void function OnDialog_Close()
{
    Signal( uiGlobal.signalDummy, "ColorPickerKill" )
}

void function OnScreen_BGActivate( var button )
{
    CloseSubmenu()
}

void function OnResetButtonPressed( var button )
{
	Signal( uiGlobal.signalDummy, "ColorPickerDialogReset" )
	if( file.reset )
		SetConVarToDefault( file.conVar )
}

void function SetConVarV()
{
    vector ornull rgb = expect vector ornull( WaitSignal( uiGlobal.signalDummy, "ColorPickerSelected" )[ "color" ] )
    if(rgb == null)
        return
    expect vector( rgb )
    SetConVarString( file.conVar, format( "%.2f %.2f %.2f", rgb.x, rgb.y, rgb.z ) )
}

void function SetConVarLive( bool update )
{
	EndSignal( uiGlobal.signalDummy, "ColorPickerSelected" )
	while( true )
	{
		vector ornull rgb = expect vector ornull( WaitSignal( uiGlobal.signalDummy, "ColorPickerLiveUpdate" )[ "color" ] )
		if( rgb == null )
			continue
		expect vector( rgb )
		if( update )
			SetConVarString( file.conVar, format( "%.2f %.2f %.2f", rgb.x, rgb.y, rgb.z ) )
	}
}

void function OpenColorPickerDialog( string conVar, bool liveUpdate = false, bool update = true, bool reset = false )
{
    file.conVar = conVar
    file.picker.lastColor = null
	file.reset = reset
	if( update )
    	thread SetConVarV()
	if( liveUpdate )
		thread SetConVarLive( update )
	OpenColorPickerDialog_Internal( DefaultSubmenuPosition )
}

void function OpenColorPickerDialog_Internal( int[2] functionref( var ) positionCallback )
{
    OpenDropDownSubmenu( file.menu, positionCallback )
}
