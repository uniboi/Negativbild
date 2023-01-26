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

// TODO: is this right? idk
void function Hud_SetAbsPos( var elem, int x, int y )
{
    array pos = expect array( Hud_GetAbsPos( elem ) )
	int px = expect int( pos[0] )
	int py = expect int( pos[1] )
	Hud_SetPos( elem, px + ( x - px ), py + ( y - py ) )
}