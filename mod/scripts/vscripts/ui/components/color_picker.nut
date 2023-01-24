global function ColorPickers_Init
global function RegisterColorPicker

struct ColorPicker {
    var circle
    var indicator
}

struct {
    array<ColorPicker> pickers
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
    vector ornull p = NSGetCursorPosition()

    if( p == null )
        return
    expect vector( p )


    foreach( picker in file.pickers)
    {
        int circleAbsX = Hud_GetAbsX( picker.circle )
        int circleAbsY = Hud_GetAbsY( picker.circle )
        int circleDiameter = Hud_GetWidth( picker.circle )
        int circleRadius = circleDiameter / 2

        if( p.x < circleAbsX || p.x > circleAbsX + circleDiameter || p.y < circleAbsY || p.y > circleAbsY + circleDiameter )
              continue
            
        vector circleCenter = < circleAbsX + circleDiameter / 2, circleAbsY + circleDiameter / 2, 0 >
        vector rp = p - circleCenter
	    rp.x = rp.x / circleRadius
	    rp.y = -(rp.y / circleRadius)

        vector rgb = rectoToRGB( rp )

        Signal( uiGlobal.signalDummy, "ColorPickerSelected", { color = rgb } )
        break
    }
}

void function RegisterColorPicker( var elem )
{
    ColorPicker pc
    pc.circle = Hud_GetChild( elem, "ColorCircle" )
    pc.indicator = Hud_GetChild( elem, "ColorIndicator" )
    file.pickers.append( pc )
    thread CursorPositionChecker_Guard( elem )
}

void function CursorPositionChecker_Guard( var elem )
{
    while( true )
    {
        WaitSignal( uiGlobal.signalDummy, "ColorPickerRevive" )
        thread CursorPositionChecker_Threaded( elem )
    }
}

void function CursorPositionChecker_Threaded( var elem )
{
    EndSignal( uiGlobal.signalDummy, "ColorPickerKill" )
    while( true )
    {
        vector ornull p = NSGetCursorPosition()
        if( p != null )
        {
            expect vector( p )
            foreach( picker in file.pickers)
            {
	            int circleAbsX = Hud_GetAbsX( picker.circle )
	            int circleAbsY = Hud_GetAbsY( picker.circle )
	            int circleDiameter = Hud_GetWidth( picker.circle )
	            int circleRadius = circleDiameter / 2

            	if( p.x < circleAbsX || p.x > circleAbsX + circleDiameter || p.y < circleAbsY || p.y > circleAbsY + circleDiameter )
                    continue

                vector circleCenter = < circleAbsX + circleDiameter / 2, circleAbsY + circleDiameter / 2, 0 >
                vector rp = p - circleCenter
	            rp.x = rp.x / circleRadius
	            rp.y = -(rp.y / circleRadius)

                vector rgb = rectoToRGB( rp )

                Hud_SetColor( picker.indicator, rgb.x, rgb.y, rgb.z )
                break
            }
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