untyped
globalize_all_functions

void function Negativbild_Init()
{
    // print("███░░░██░███████░░██████░░░█████░░████████░██░██░░░░██░██████░░██░██░░░░░░██████╗░")
	// print("████░░██░██░░░░░░██░░░░░░░██░░░██░░░░██░░░░██░██░░░░██░██░░░██░██░██░░░░░░██░░░██░")
	// print("██░██░██░█████░░░██░░░██░░███████░░░░██░░░░██░░██░░██░░██████░░██░██░░░░░░██░░░██░")
	// print("██░░████░██░░░░░░██░░░░██░██░░░██░░░░██░░░░██░░░████░░░██░░░██░██░██░░░░░░██░░░██░")
	// print("██░░░███░███████░░██████░░██░░░██░░░░██░░░░██░░░░██░░░░██████░░██░███████░██████░░")
}

bool function dotresDimensions()
{
    return GetConVarBool( "dotres_debug_draw_dimensions" )
}

void function DrawDebugFrame( var p, var frame = null )
{
    if( !frame ) frame = Hud_GetChild( p, "DebugFrame" )
    Hud_SetSize( frame, Hud_GetWidth( p ), Hud_GetHeight( p ) )
    if( dotresDimensions() )  Hud_Show( frame )
}

void function HideDebugFrame( var p, var frame = null )
{
    if( !frame ) frame = Hud_GetChild( p, "DebugFrame" )
    if( dotresDimensions() ) Hud_Hide( frame )
}

void function AddModSettingsDropDown( string conVar, string buttonLabel, array<string> options, bool useIndex = false )
{
    AddModSettingsButton( buttonLabel, 
        void function() : ( options, conVar, useIndex )
        {
            OpenDropDown( options )
            thread void function() : ( conVar, useIndex )
            {
                if( useIndex )
                {
                    SetConVarInt( conVar, expect int( WaitSignal( uiGlobal.signalDummy, "DropDownSelected" ).index ) )
                }
                else
                {
                    SetConVarString( conVar, expect string( WaitSignal( uiGlobal.signalDummy, "DropDownSelected" ).title ) )
                }
            }()
        }, 3
    )
}

void function AddModSettingsColorPicker( string conVar, string buttonLabel )
{
    AddModSettingsButton( buttonLabel,
        void function() : ( conVar )
        {
            OpenColorPickerDialog( conVar )
            thread void function() : ( conVar )
            {
                WaitSignal( uiGlobal.signalDummy, "ColorPickerSelected" )
                CloseSubmenu()
            }()
        }, 3
    )
}

void function Hud_SetAbsPos( var elem, int x, int y )
{
    // TODO
}