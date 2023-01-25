global function ColorPickerDialog_Init
global function OpenColorPickerDialog
global function OpenColorPickerDialogCalc

struct {
    var picker
} file

void function ColorPickerDialog_Init()
{
    AddSubmenu( "ColorPickerMenu", $"resource/ui/menus/internal/colorpicker_dialog.menu", InitColorPickerMenu )
}

void function InitColorPickerMenu()
{
    var menu = GetMenu( "ColorPickerMenu" )
    file.picker = Hud_GetChild( menu, "ColorPicker" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnDialog_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnDialog_Close )

	var screen = Hud_GetChild( menu, "Screen" )
	var rui = Hud_GetRui( screen )
	RuiSetFloat( rui, "basicImageAlpha", 0.0 )
	Hud_AddEventHandler( screen, UIE_CLICK, OnScreen_BGActivate )

    RegisterColorPicker( file.picker )
}

void function OnDialog_Open()
{
    Signal( uiGlobal.signalDummy, "ColorPickerRevive" )
}

void function OnDialog_Close()
{
    Signal( uiGlobal.signalDummy, "ColorPickerKill" )
}

void function OnDialog_Open()
{
    Signal( uiGlobal.signalDummy, "ColorPickerRevive" )
}

void function OnDialog_Close()
{
    Signal( uiGlobal.signalDummy, "ColorPickerKill" )
}

void function OnScreen_BGActivate( var button )
{
    CloseSubmenu()
}

void function OpenColorPickerDialog()
{
	OpenColorPickerDialog_Internal(DefaultSubmenuPosition )
}

// Needed because default params need to be const and it's impossible to cast ornull to a functionref
void function OpenColorPickerDialogCalc( int[2] functionref( var ) positionCallback )
{
	OpenColorPickerDialog_Internal( positionCallback )
}

void function OpenColorPickerDialog_Internal( int[2] functionref( var ) positionCallback )
{
    OpenDropDownSubmenu( GetMenu( "ColorPickerMenu" ), positionCallback )
}