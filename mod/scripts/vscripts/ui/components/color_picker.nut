global function ColorPickers_Init
global function RegisterColorPicker
global function EnableColorPicker
global function DisableColorPicker
global function ResetColorPicker
global function OnColorPickerSelected

global struct Color {
  float r
  float g
  float b
  float a
  float hue
}

global struct ColorPicker {
  var palette
  var indicator
  var brightnessSlider
  vector lastRelativePos // to recalculate color when changing brightness
  vector ornull lastColor
  float brightness = 1.0 // 0.0 -> 1.0
  bool liveUpdates // send a signal every frame the use hovers over the color picker with the selected color
}

global const SIGNAL_COLOR_PICKER_DISABLED = "Negativbild_ColorPickerDisabled"
global const SIGNAL_COLOR_PICKER_UPDATED = "Negativbild_ColorPickerUpdated"
global const SIGNAL_COLOR_PICKER_SELECTED = "Negativbild_ColorPickerSelected"

struct {
    ColorPicker ornull lastPicker
    array<ColorPicker> pickers
} file

void function ColorPickers_Init()
{
  RegisterSignal( SIGNAL_COLOR_PICKER_DISABLED )
  RegisterSignal( SIGNAL_COLOR_PICKER_UPDATED )
  RegisterSignal( SIGNAL_COLOR_PICKER_SELECTED )
  RegisterSignal( "ColorPickerRevive" ) // TODO required?

  RegisterButtonPressedCallback( MOUSE_LEFT, OnPaletteClick )
}

ColorPicker function RegisterColorPicker( var picker, bool liveUpdates = false )
{
  ColorPicker pc
  pc.palette = Hud_GetChild( picker, "ColorCircle" )
  pc.indicator = Hud_GetChild( picker, "ColorIndicator" )
  pc.brightnessSlider = Hud_GetChild( picker, "BrightnessSlider" )
  pc.liveUpdates = liveUpdates

  RegisterScrollbar(
    pc.brightnessSlider,
    void function( int x, int y ) : ( pc )
    {
      var slider = Hud_GetChild( pc.brightnessSlider, "MouseMovementCapture" )
      int usable = Hud_GetHeight( pc.brightnessSlider ) - Hud_GetHeight( slider )
      int offset = Hud_GetY( slider )
      pc.brightness = 1.0 - ( float( offset ) / float( usable ) )

      UpdateColorIndicator( pc, PositionToRGB( pc.lastRelativePos, pc.brightness ) )
    }
  )

  SetScrollbarComponentContentHeight( pc.brightnessSlider, Hud_GetHeight( pc.brightnessSlider ) / 10 )

  file.pickers.push( pc )

  return pc
}

void function EnableColorPicker( ColorPicker pc )
{
  thread UpdateColorPickerIndicator( pc )
}

void function DisableColorPicker( ColorPicker pc )
{
  Signal( pc, SIGNAL_COLOR_PICKER_DISABLED )
}

void function OnColorPickerSelected( ColorPicker pc, void functionref( vector ) callback )
{
  thread OnColorPickerSelected_Threaded( pc, callback )
}

void function OnColorPickerSelected_Threaded( ColorPicker pc, void functionref( vector ) callback )
{
  EndSignal( pc, SIGNAL_COLOR_PICKER_DISABLED )

  table result = WaitSignal( pc, SIGNAL_COLOR_PICKER_SELECTED )

  callback( expect vector( result.color ) )
}

// reset indicator to white and reset lastColor
void function ResetColorPicker( ColorPicker pc )
{
  pc.lastColor = null
  pc.lastRelativePos = < 0, 0, 0 >
  pc.brightness = 1.0
  UpdateColorIndicator( pc, < 255, 255, 255 > )
}

void function UpdateColorPickerIndicator( ColorPicker pc )
{
  EndSignal( pc, SIGNAL_COLOR_PICKER_DISABLED )

  while( true ) // update the indicator every frame
  {
    vector ornull pos = NSGetCursorPosition()

    if( !pos )
    {
      WaitFrame()
      continue
    }

    expect vector( pos ) // cast to vector since null case terminated above

    int circleAbsX = Hud_GetAbsX( pc.palette )
    int circleAbsY = Hud_GetAbsY( pc.palette )
    int circleDiameter = Hud_GetWidth( pc.palette )
    int circleRadius = circleDiameter / 2
    vector origin = < circleAbsX + circleRadius, circleAbsY + circleRadius, 0 >
    
    if( PointOnCircle( pos, origin, circleRadius ) )
    {
      vector circleCenter = < circleAbsX + circleDiameter / 2, circleAbsY + circleDiameter / 2, 0 >
      vector rp = pos - circleCenter
      rp.x = rp.x / circleRadius
      rp.y = -( rp.y / circleRadius )
    
      vector rgb = PositionToRGB( rp, pc.brightness )
    
      UpdateColorIndicator( pc, rgb )
      pc.lastColor = rgb
      pc.lastRelativePos = rp
      Signal( pc, SIGNAL_COLOR_PICKER_UPDATED, { color = rgb } )
    }

    WaitFrame()
  }
}

void function UpdateColorIndicator( ColorPicker pc, vector rgb )
{
  Hud_SetColor( pc.indicator, rgb.x, rgb.y, rgb.z )
}

bool function PointOnCircle( vector point, vector origin, int radius )
{
  return Length2DSqr( origin - point ) < radius * radius
}

vector function PositionToRGB( vector pos, float brightness )
{
  float r = sqrt( pos.x * pos.x + pos.y * pos.y )
  float sat = r > 1.0 ? 0.0 : r
  float hue = RadiansToDegree( atan2( pos.y, pos.x ) )

  return HSVToRGB( hue, sat, brightness )
}

float function RadiansToDegree( float rad ) {
  return (360 + 180 * rad / PI) % 360;
}

vector function HSVToRGB( float hue, float saturation, float brightness) {
  hue /= 60;
  float chroma = brightness * saturation;
  float x = chroma * ( 1 - fabs( ( hue % 2 ) - 1 ) );
  vector rgb = hue <= 1 ?
    < chroma, x, 0 > : hue <= 2 ?
    < x, chroma, 0 > : hue <= 3 ?
    < 0, chroma, x > : hue <= 4 ?
    < 0, x, chroma > : hue <= 5 ?
    < x, 0, chroma > : < chroma, 0, x >;

  return < ( rgb.x + brightness - chroma  ) * 255, ( rgb.y + brightness - chroma ) * 255, ( rgb.z + brightness - chroma ) * 255 >
}

int[2] function GetAbsolutePaletteCenter( ColorPicker pc )
{
  array pos = expect array( Hud_GetAbsPos( pc.palette ) )
  int radius = Hud_GetWidth( pc.palette) / 2
  int[2] center
  center[0] = expect int( pos[0] ) + radius
  center[1] = expect int( pos[1] ) + radius
  return center
}

// TODO I'm 90% sure this doesn't work
// didn't test with multiple pickers though
ColorPicker function FindNearestPickerToPos( vector pos )
{
  ColorPicker nearest = file.pickers[0]
  int[2] firstCenter = GetAbsolutePaletteCenter( nearest )
  float distToNearest = Distance2D( < firstCenter[0], firstCenter[1], 0 >, pos )

  for( int i = 1; i < file.pickers.len(); i++ )
  {
    ColorPicker pc = file.pickers[i]
    int[2] center = GetAbsolutePaletteCenter( pc )
    if( Distance2D( < center[0], center[1], 0 >, pos ) < distToNearest )
    {
      nearest = pc
    }
  }

  return nearest
}

void function OnPaletteClick( var button )
{
  vector ornull p = NSGetCursorPosition()

  if( p == null )
    return

  expect vector( p )

  ColorPicker picker = FindNearestPickerToPos( p )

  var circle = picker.palette
  int circleAbsX = Hud_GetAbsX( circle )
  int circleAbsY = Hud_GetAbsY( circle )
  int circleRadius = Hud_GetWidth( circle ) / 2
  vector origin = < circleAbsX + circleRadius, circleAbsY + circleRadius, 0 >

  // abort if the user didn't click on any picker
  if( !PointOnCircle( p, origin, circleRadius ) ) return

  Signal( picker, SIGNAL_COLOR_PICKER_SELECTED, { color = expect vector( picker.lastColor ) } )
}

