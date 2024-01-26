global function ColorPickers_Init
global function RegisterColorPicker
global function EnableColorPicker
global function DisableColorPicker
global function ResetColorPicker
global function OnColorPickerSelected

global struct ColorPicker {
  var palette
  var indicator
  var brightnessSlider
  var marker
  bool onPalette
  vector lastRelativePos // to recalculate color when changing brightness
  vector ornull lastColor
  vector ornull markedColor
  float brightness = 1.0 // 0.0 -> 1.0
  bool liveUpdates // send a signal every frame the use hovers over the color picker with the selected color
}

global const SIGNAL_COLOR_PICKER_DISABLED = "Negativbild_ColorPickerDisabled"
global const SIGNAL_COLOR_PICKER_UPDATED = "Negativbild_ColorPickerUpdated"
global const SIGNAL_COLOR_PICKER_SELECTED = "Negativbild_ColorPickerSelected"

struct {
    ColorPicker ornull lastPicker
    array<ColorPicker> pickers // enabled pickers
} file

void function ColorPickers_Init()
{
  RegisterSignal( SIGNAL_COLOR_PICKER_DISABLED )
  RegisterSignal( SIGNAL_COLOR_PICKER_UPDATED )
  RegisterSignal( SIGNAL_COLOR_PICKER_SELECTED )
  RegisterSignal( "ColorPickerRevive" ) // TODO required?

  RegisterButtonPressedCallback( MOUSE_LEFT, OnPaletteClick )

  /*
  vector rgb = < 255, 200, 180 >
  vector hsv = RGBToHSV(rgb)

  printt("rgb / hsv test",
    rgb,
    hsv,
    HSVToRGB(hsv.x, hsv.y, hsv.z)
  )
  */
}

ColorPicker function RegisterColorPicker( var picker, bool liveUpdates = false )
{
  ColorPicker pc
  pc.palette = Hud_GetChild( picker, "ColorCircle" )
  pc.indicator = Hud_GetChild( picker, "ColorIndicator" )
  pc.brightnessSlider = Hud_GetChild( picker, "BrightnessSlider" )
  pc.marker = Hud_GetChild( picker, "PositionMarker" )
  pc.liveUpdates = liveUpdates

  // brightness slider
  RegisterScrollbar(
    pc.brightnessSlider,
    void function( int x, int y ) : ( pc )
    {
      var slider = Hud_GetChild( pc.brightnessSlider, "MouseMovementCapture" )
      int usable = Hud_GetHeight( pc.brightnessSlider ) - Hud_GetHeight( slider )
      int offset = Hud_GetY( slider )
      pc.brightness = 1.0 - ( float( offset ) / float( usable ) )

      if( pc.markedColor == null )
	return

      vector hsv = RGBToHSV( expect vector( pc.markedColor ) )
      UpdateColorIndicator( pc, HSVToRGB( hsv.x, hsv.y, pc.brightness ) )
//      UpdateColorIndicator( pc, PositionToRGB( pc.lastRelativePos, pc.brightness ) )
    }
  )

  // set the slider height to be 1/10 of the available space
  SetScrollbarComponentContentHeight( pc.brightnessSlider, Hud_GetHeight( pc.brightnessSlider ) / 10 )

  Hud_AddEventHandler(picker, UIE_CLICK, void function(var button) { print("clicked palette") } )


  return pc
}

void function EnableColorPicker( ColorPicker pc )
{
  file.pickers.push( pc )
  thread UpdateColorPickerIndicator( pc )
}

void function DisableColorPicker( ColorPicker pc )
{
  Signal( pc, SIGNAL_COLOR_PICKER_DISABLED )
  file.pickers.fastremovebyvalue( pc )
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

    bool wasOnPalette = pc.onPalette
    pc.onPalette = PointOnCircle( pos, origin, circleRadius )
    
    if( pc.onPalette )
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
    else if( wasOnPalette && pc.markedColor != null )
    {
      UpdateColorIndicator( pc, expect vector( pc.markedColor ) )
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

vector function RGBToHSV( vector rgb )
{
  float r = rgb.x / 255.0
  float g = rgb.y / 255.0
  float b = rgb.z / 255.0

  float v = max( r, max( g, b ) )
  float c = v - min( r, min( g, b ) )
  float h = c && ((v == r) ? (g - b) / c : ((v == g) ? 2 + (b - r) / c : 4 + (r - g) / c))
  return < 60 * (h < 0 ? h + 6 : h), (v ? c / v : 0.0), v >
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
ColorPicker ornull function FindNearestPickerToPos( vector pos )
{
  ColorPicker ornull nearest = null
  float distToNearest

  foreach( pc in file.pickers )
  {
    int[2] center = GetAbsolutePaletteCenter( pc )
    float dist = Distance2D( < center[0], center[1], 0 >, pos )
    if( nearest == null || ( dist < distToNearest ) )
    {
      nearest = pc
      distToNearest = dist
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

  ColorPicker ornull picker = FindNearestPickerToPos( p )

  if( picker == null )
    return

  expect ColorPicker( picker )

  var circle = picker.palette
  int circleAbsX = Hud_GetAbsX( circle )
  int circleAbsY = Hud_GetAbsY( circle )
  int circleRadius = Hud_GetWidth( circle ) / 2
  vector origin = < circleAbsX + circleRadius, circleAbsY + circleRadius, 0 >

  // no color picker was clicked
  if( !PointOnCircle( p, origin, circleRadius ) )
    return

  // TODO make this dynamic?
  int markerOffset = 3
  Hud_SetAbsPos( picker.marker, int( p.x - circleAbsX ) - markerOffset, int( p.y - circleAbsY ) - markerOffset )
  Hud_Show( picker.marker )

  file.lastPicker = picker
  picker.markedColor = picker.lastColor

  Signal( picker, SIGNAL_COLOR_PICKER_SELECTED, { color = expect vector( picker.lastColor ) } )
}

