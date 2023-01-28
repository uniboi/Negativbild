global function ColorPickers_Init
global function RegisterColorPicker

struct {
    table ornull lastPicker = null
} file

void function ColorPickers_Init()
{
    RegisterSignal( "ColorPickerSelected" )
    RegisterSignal( "ColorPickerKill" )
    RegisterSignal( "ColorPickerRevive" )
	RegisterSignal( "ColorPickerLiveUpdate" )
	RegisterButtonPressedCallback( MOUSE_LEFT , OnClick )
}

void function OnClick( var button )
{
    table ornull picker = file.lastPicker
    if( picker == null )
        return
    expect table( picker )

    Signal( uiGlobal.signalDummy, "ColorPickerSelected", { color = picker.lastColor } )
}

table<string, var> function RegisterColorPicker( var elem )
{
    table<string, var> pc
    pc.circle <- Hud_GetChild( elem, "ColorCircle" )
    pc.indicator <- Hud_GetChild( elem, "ColorIndicator" )
    pc.lastColor <- null
    thread CursorPositionChecker_Guard( elem )
    return pc
}

void function CursorPositionChecker_Guard( var elem )
{
    while( true ) // Query rgb from pos only when the signal is triggered
    {
        file.lastPicker = expect table ornull( WaitSignal( uiGlobal.signalDummy, "ColorPickerRevive" )[ "picker" ] )
		if( file.lastPicker != null )
        	thread CursorPositionChecker_Threaded( expect table( file.lastPicker ) )
    }
}

void function CursorPositionChecker_Threaded( table observedPicker )
{
    EndSignal( uiGlobal.signalDummy, "ColorPickerKill" )

    OnThreadEnd(
        void function()
        {
            file.lastPicker = null
        }
    )

    while( true ) // Get rgb from cursor position every frame
    {
        vector ornull p = NSGetCursorPosition()
        if( p != null )
        {
            expect vector( p )

            var circle = observedPicker[ "circle" ]
	        int circleAbsX = Hud_GetAbsX( circle )
	        int circleAbsY = Hud_GetAbsY( circle )
	        int circleDiameter = Hud_GetWidth( circle )
	        int circleRadius = circleDiameter / 2
            vector origin = < circleAbsX + circleRadius, circleAbsY + circleRadius, 0 >

            if( Length2DSqr( origin - p ) < circleRadius * circleRadius )
            {
                vector circleCenter = < circleAbsX + circleDiameter / 2, circleAbsY + circleDiameter / 2, 0 >
                vector rp = p - circleCenter
                rp.x = rp.x / circleRadius
                rp.y = -( rp.y / circleRadius )

                vector rgb = PositionToRGB( rp )

                Hud_SetColor( observedPicker[ "indicator" ], rgb.x, rgb.y, rgb.z )
                observedPicker[ "lastColor" ] <- rgb
				Signal( uiGlobal.signalDummy, "ColorPickerLiveUpdate", { color = rgb } )
            }
        }
        WaitFrame()
    }
}

vector function PositionToRGB( vector pos )
{
	float r = sqrt( pos.x * pos.x + pos.y * pos.y )
	float sat = r > 1.0 ? 0.0 : r
	float hue = RadiansToDegree( atan2( pos.y, pos.x ) )
	return HSVToRGB( hue, sat, 1.0 )
}

float function RadiansToDegree( float rad ) {
  return (360 + 180 * rad / PI) % 360;
}

vector function HSVToRGB( float hue, float saturation, float value ) {
  hue /= 60;
  float chroma = value * saturation;
  float x = chroma * ( 1 - fabs( ( hue % 2 ) - 1 ) );
  vector rgb = hue <= 1 ?
  			< chroma, x, 0 > : hue <= 2 ?
			< x, chroma, 0 > : hue <= 3 ?
			< 0, chroma, x > : hue <= 4 ?
			< 0, x, chroma > : hue <= 5 ?
			< x, 0, chroma > : < chroma, 0, x >;

  return < ( rgb.x + value - chroma  ) * 255, ( rgb.y + value - chroma ) * 255, ( rgb.z + value - chroma ) * 255 >
}