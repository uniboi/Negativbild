untyped
globalize_all_functions

global const bool NEGATIVBILD_DEV = true

void function Negativbild_Init()
{
	#if NEGATIVBILD_DEV
		print("███░░░██░███████░░██████░░░█████░░████████░██░██░░░░██░██████░░██░██░░░░░░██████╗░")
		print("████░░██░██░░░░░░██░░░░░░░██░░░██░░░░██░░░░██░██░░░░██░██░░░██░██░██░░░░░░██░░░██░")
		print("██░██░██░█████░░░██░░░██░░███████░░░░██░░░░██░░██░░██░░██████░░██░██░░░░░░██░░░██░")
		print("██░░████░██░░░░░░██░░░░██░██░░░██░░░░██░░░░██░░░████░░░██░░░██░██░██░░░░░░██░░░██░")
		print("██░░░███░███████░░██████░░██░░░██░░░░██░░░░██░░░░██░░░░██████░░██░███████░██████░░")
	#endif

	RegisterButtonPressedCallback( MOUSE_WHEEL_UP,
		void function( var button )
		{
			try
			{
				var p = Hud_GetParent( Hud_GetParent( GetFocus() ) )
				if( Hud_HasChild( p, "SLScrollbar" ) )
				{
					var scrollbar = Hud_GetChild( p, "SLScrollbar" )
					var cpt = Hud_GetChild( scrollbar, "MouseMovementCapture" )
					UICodeCallback_MouseMovementCapture( cpt, 0, -Hud_GetHeight( cpt ) )
				}
			}
			catch ( e ) {} // to high up in stack, doesn't matter
		}
	)

	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN,
		void function( var button )
		{
			try
			{
				var p = Hud_GetParent( Hud_GetParent( GetFocus() ) )
				if( Hud_HasChild( p, "SLScrollbar" ) )
				{
					var scrollbar = Hud_GetChild( p, "SLScrollbar" )
					var cpt = Hud_GetChild( scrollbar, "MouseMovementCapture" )
					UICodeCallback_MouseMovementCapture( cpt, 0, Hud_GetHeight( cpt ) )
				}
			}
			catch ( e ) {} // to high up in stack, doesn't matter
		}
	)
}

void function ModSettings_AddDropDown( string conVar, string buttonLabel, array<string> options, bool useIndex = false )
{
    ModSettings_AddButton( buttonLabel, 
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

/*
void function ModSettings_AddColorPicker( string conVar, string buttonLabel, bool liveUpdate = false )
{
    ModSettings_AddButton( buttonLabel,
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
*/

void function ModSettings_AddColorPicker( string conVar, string buttonLabel, bool liveUpdate = false, int depth = 3 )
{
  ModSettings_AddButton(
    buttonLabel,
    void function() : ( conVar )
    {
      OpenColorPickerDialog( conVar )
    },
    depth
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
