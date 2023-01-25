global function ColorPickerDialog_Init
global function OpenColorPickerDialog
global function OpenColorPickerDialogCalc

struct {
    table<string, var> picker
    string conVar
    var menu
} file

void function ColorPickerDialog_Init()
{
    AddSubmenu( "ColorPickerMenu", $"resource/ui/menus/internal/colorpicker_dialog.menu", InitColorPickerMenu )
}

void function InitColorPickerMenu()
{
    file.menu = GetMenu( "ColorPickerMenu" )
    // file.picker = Hud_GetChild( menu, "ColorPicker" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnDialog_Open )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, OnDialog_Close )

	var screen = Hud_GetChild( file.menu, "Screen" )
	var rui = Hud_GetRui( screen )
	RuiSetFloat( rui, "basicImageAlpha", 0.0 )
	Hud_AddEventHandler( screen, UIE_CLICK, OnScreen_BGActivate )

    file.picker = RegisterColorPicker( Hud_GetChild( file.menu, "ColorPicker" ) )
}

void function OnDialog_Open()
{
    Signal( uiGlobal.signalDummy, "ColorPickerRevive", { picker = file.picker } )
    array<string> split = split( GetConVarString( file.conVar ), " " )
    Hud_SetColor( Hud_GetChild( file.menu, "LastColorIndicator" ), float( split[0]), float( split[1]), float( split[2] ) )
    
}

void function OnDialog_Close()
{
    Signal( uiGlobal.signalDummy, "ColorPickerKill" )
    SetConVarV()
}

void function OnScreen_BGActivate( var button )
{
    CloseSubmenu()
    SetConVarV()
}

void function SetConVarV()
{
    vector ornull rgb = expect vector ornull( file.picker.lastColor )
    if(rgb == null)
        return
    expect vector( rgb )
    printt( "UPDATING CONVAR: " + file.conVar, "^^^^^^^^^^^^^^^^^^" )
    SetConVarString( file.conVar, format( "%.2f %.2f %.2f", rgb.x, rgb.y, rgb.z ) )
}

void function OpenColorPickerDialog( string conVar )
{
    file.conVar = conVar
    file.picker.lastColor = null
	OpenColorPickerDialog_Internal(DefaultSubmenuPosition )
}

// Needed because default params need to be const and it's impossible to cast ornull to a functionref
void function OpenColorPickerDialogCalc( int[2] functionref( var ) positionCallback )
{
	OpenColorPickerDialog_Internal( positionCallback )
}

void function OpenColorPickerDialog_Internal( int[2] functionref( var ) positionCallback )
{
    OpenDropDownSubmenu( file.menu, positionCallback )
}