untyped
global function InitProfilesMenu
global function ProfilesAddFooter
global function HSVToRGB
global function round

struct {
	var menu
	var colorTile
	var colorCircle
} file

void function InitProfilesMenu()
{
	AddMenu( "ProfilesMenu", $"resource/ui/menus/profiles_menu.menu", ShowProfilesMenu )
	file.menu = GetMenu( "ProfilesMenu" )

	file.colorCircle = Hud_GetChild( file.menu, "ColorCircle" )
	file.colorTile = Hud_GetChild( file.menu, "ColorIndicator" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnProfileMenuOpened )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, OnProfileMenuClosed )

	// Hud_SetRotation( file.colorCircle, 90.0 )
}

void function OnProfileMenuOpened()
{
	RegisterButtonPressedCallback( MOUSE_LEFT , OnClick )
}

void function OnProfileMenuClosed()
{
	DeregisterButtonPressedCallback( MOUSE_LEFT , OnClick )
}

void function OnClick( var button )
{
	vector ornull p = NSGetCursorPosition()
	if( p == null )
		return
	expect vector( p )

	int circleAbsX = Hud_GetAbsX( file.colorCircle )
	int circleAbsY = Hud_GetAbsY( file.colorCircle )
	int circleDiameter = Hud_GetWidth( file.colorCircle )
	int circleRadius = circleDiameter / 2
	float diagonal = circleRadius / sqrt( 2 )

	if( p.x < circleAbsX ||
		p.x > circleAbsX + circleDiameter ||
		p.y < circleAbsY ||
		p.y > circleAbsY + circleDiameter )
	{
		return
	}

	vector circleCenter = < circleAbsX + circleDiameter / 2, circleAbsY + circleDiameter / 2, 0 >
	vector v = <0.8660254037844, 0.5, 0> * circleRadius

	vector pureRed = < 0, -circleRadius, 0 >
	vector pureGreen = < v.x, v.y, 0 >
	vector pureBlue = < -v.x, v.y, 0 >

	vector rp = p - circleCenter
	rp.x = rp.x / circleRadius
	rp.y = -(rp.y / circleRadius)
	
	vector rgb = rectoToRGB( rp )

	printt( {
		// relative = rp,
		color = rgb
		// toRed = Length( rp - pureRed ),
		// toGreen = Length( rp - pureGreen ),
		// toBlue = Length( rp - pureBlue ),
		// pureRed = pureRed,
		// pureGreen = pureGreen,
		// pureBlue = pureBlue,
	} )

	// vector v = <circleRadius * cos( 240 ), circleRadius * sin( 240 ), 0 >

	// printt( v )

	// Hud_SetPos( Hud_GetChild( file.menu, "ColorIndicator" ), pureRed.x, pureRed.y )
	Hud_SetColor( file.colorTile, rgb.x, rgb.y, rgb.z )
}

float function round( float x )
{
	return floor( x + 0.5 )
}

float function rad2deg( float rad ) {
  return (360 + 180 * rad / PI) % 360;
}

vector function rectoToRGB( vector pos )
{
	float r = sqrt( pos.x * pos.x + pos.y * pos.y )
	float sat = r > 1.0 ? 0.0 : r
	float hue = rad2deg( atan2( pos.y, pos.x ) )
	printt( hue )
	return hsv2rgb( hue, sat, 1.0 )
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

//   return rgb.map(v => (v + value - chroma) * 255);
  return <(rgb.x + value - chroma) * 255, (rgb.y + value - chroma) * 255, (rgb.z + value - chroma) * 255>
}

vector function HSVToRGB( float h, float s, float v )
{
	float r
	float g
	float b
	float i = floor( h * 6)
	float f = h * 6 - i
    float p = v * (1 - s);
    float q = v * (1 - f * s);
    float t = v * (1 - (1 - f) * s);

    switch (i % 6)
	{
        case 0:
			r = v
			g = t
			b = p
			break
        case 1:
			r = q
			g = v
			b = p
			break
        case 2:
			r = p
			g = v
			b = t
			break
        case 3:
			r = p
			g = q
			b = v
			break
        case 4:
			r = t
			g = p
			b = v
			break
        case 5:
			r = v
			g = p
			b = q
			break
    }

	return < round( r * 255.0 ), round( g * 255.0 ), round( b * 255.0 ) >
}

void function ProfilesAddFooter()
{
	AddMenuFooterOption( GetMenu( "MainMenu" ), BUTTON_X, PrependControllerPrompts( BUTTON_X, " Profiles" ), "Profiles", void function(var button){AdvanceMenu( GetMenu( "ProfilesMenu" ) )} )
	ScrollableList sl1 = RegisterScrollableList( Hud_GetChild( file.menu, "TestList" ), [
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"],
		[
			_ScrollbarContentListener( UIE_GET_FOCUS,
				void function( var button, ScrollbarContent sc )
				{
					printt( "FOCUS: " + sc.title )
				}
			),
			_ScrollbarContentListener( UIE_CLICK,
				void function( var button, ScrollbarContent sc )
				{
					printt( "CLICK: " + sc.title )
				}
			)
		]
	)
	ScrollableList sl2 = RegisterScrollableList( Hud_GetChild( file.menu, "TestList2" ), [
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"],
		[_ScrollbarContentListener( UIE_CLICK,
			void function( var button, ScrollbarContent sc )
			{
				sc.SetDisabled( true )
			}
		)]
	)

	RegisterToolTip( file.menu, Hud_GetChild( file.menu, "Tooltip" ) )

	// AddTooltipToElement( Hud_GetChild( file.menu, "TooltipButton1" ), "test 1" )
	// AddTooltipToElement( Hud_GetChild( file.menu, "TooltipButton2" ), "Really Long Tooltip" )
	AddTooltipToElement( Hud_GetChild( file.menu, "TooltipButton3" ), "WOW so cool", 150 )

	// RegisterDropDownMenu( Hud_GetChild( file.menu, "DropDownButton1" ) )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "DropDownButton1" ), UIE_CLICK,
		void function( var button )
		{
			thread void function()
			{
				OpenDropDown( ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"] )
				table res = WaitSignal( uiGlobal.signalDummy, "DropDownSelected" )
				printt(res.title, res.index)
			}()
		}
	)
}

void function ShowProfilesMenu()
{
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	printt( bool(RandomInt(1)))
}