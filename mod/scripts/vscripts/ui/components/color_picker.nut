global function ColorPickers_Init
global function RegisterColorPicker

struct ColorPicker {
    var circle
    var indicator
    vector lastColor
}

struct {
    array<ColorPicker> pickers
    int did
    table ornull lastPicker = null
} file

void function ColorPickers_Init()
{
    RegisterSignal( "ColorPickerSelected" )
    RegisterSignal( "ColorPickerKill" )
    RegisterSignal( "ColorPickerRevive" )
	RegisterButtonPressedCallback( MOUSE_LEFT , OnClick )
}

void function OnClick( var button )
{
    printt(file.lastPicker)
    table ornull picker = file.lastPicker
    if( picker == null )
        return
    expect table( picker )

    // printt( picker.lastColor )
    Signal( uiGlobal.signalDummy, "ColorPickerSelected", { color = picker.lastColor } )

        // while( true )
        // {
        //     table picker = expect table( WaitSignal( uiGlobal.signalDummy, "ColorPickerRevive" )["picker"] )
        //     var circle = picker["circle"]
        //     vector ornull p = NSGetCursorPosition()

        //     if( p == null )
        //         return
        //     expect vector( p )

        //     // foreach( picker in file.pickers)
        //     // {
        //         // int circleAbsX = Hud_GetAbsX( picker.circle )
        //         // int circleAbsY = Hud_GetAbsY( picker.circle )
        //         // int circleDiameter = Hud_GetWidth( picker.circle )
                
        //         int circleAbsX = Hud_GetAbsX( circle )
        //         int circleAbsY = Hud_GetAbsY( circle )
        //         int circleDiameter = Hud_GetWidth( circle )

        //         printt( picker )

        //         if( !(p.x < circleAbsX || p.x > circleAbsX + circleDiameter || p.y < circleAbsY || p.y > circleAbsY + circleDiameter) )
        //         {
        //             printt( picker.lastColor )
        //             Signal( uiGlobal.signalDummy, "ColorPickerSelected", { color = picker.lastColor } )
        //         }

        //         // break
        //     // }
        // }
}

table<string, var> function RegisterColorPicker( var elem )
{
    table<string, var> pc
    // ColorPicker pc
    pc.circle <- Hud_GetChild( elem, "ColorCircle" )
    pc.indicator <- Hud_GetChild( elem, "ColorIndicator" )
    pc.lastColor <- < 0, 0, 0 >
    pc.id <- file.did
    file.did++
    // file.pickers.append( pc )
    thread CursorPositionChecker_Guard( elem )
    return pc
}

void function CursorPositionChecker_Guard( var elem )
{
    while( true )
    {
        table picker = expect table( WaitSignal( uiGlobal.signalDummy, "ColorPickerRevive" )["picker"] )
        file.lastPicker = picker
        thread CursorPositionChecker_Threaded( picker )
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

    while( true )
    {
        vector ornull p = NSGetCursorPosition()
        if( p != null )
        {
            expect vector( p )
            // foreach( picker in file.pickers)
            // {
                var circle = observedPicker["circle"]
	            int circleAbsX = Hud_GetAbsX( circle )
	            int circleAbsY = Hud_GetAbsY( circle )
	            int circleDiameter = Hud_GetWidth( circle )
	            int circleRadius = circleDiameter / 2

            	if( !(p.x < circleAbsX || p.x > circleAbsX + circleDiameter || p.y < circleAbsY || p.y > circleAbsY + circleDiameter) )
                {
                    vector circleCenter = < circleAbsX + circleDiameter / 2, circleAbsY + circleDiameter / 2, 0 >
                    vector rp = p - circleCenter
                    rp.x = rp.x / circleRadius
                    rp.y = -(rp.y / circleRadius)

                    vector rgb = rectoToRGB( rp )

                    Hud_SetColor( observedPicker["indicator"], rgb.x, rgb.y, rgb.z )
                    observedPicker["lastColor"] <- rgb
                }

            //     break
            // }
        }
        WaitFrame()
    }
}

vector function rectoToRGB( vector pos )
{
	float r = sqrt( pos.x * pos.x + pos.y * pos.y )
	float sat = r > 1.0 ? 0.0 : r
	float hue = rad2deg( atan2( pos.y, pos.x ) )
	return hsv2rgb( hue, sat, 1.0 )
}

float function rad2deg( float rad ) {
  return (360 + 180 * rad / PI) % 360;
}

vector function hsv2rgb(float hue, float saturation, float value) {
  hue /= 60;
  float chroma = value * saturation;
  float x = chroma * (1 - fabs((hue % 2) - 1));
  vector rgb = hue <= 1? <chroma, x, 0>:
            hue <= 2? <x, chroma, 0>:
            hue <= 3? <0, chroma, x>:
            hue <= 4? <0, x, chroma>:
            hue <= 5? <x, 0, chroma>:
                      <chroma, 0, x>;

  return <(rgb.x + value - chroma) * 255, (rgb.y + value - chroma) * 255, (rgb.z + value - chroma) * 255>
}