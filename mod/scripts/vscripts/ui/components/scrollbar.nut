global function RegisterScrollbar
global function SetScrollbarComponentContentHeight

void function RegisterScrollbar( var scrollbar, void functionref( int x, int y ) callback )
{
    var representative = GetComponentContentRepresentative( scrollbar )
    AddMouseMovementCaptureHandler( representative, void function( int x, int y ) : ( scrollbar, representative, callback )
    {
        int representativeHeight = Hud_GetY( representative )

        int min = Hud_GetY( scrollbar )
        int max = min + Hud_GetHeight( scrollbar ) - Hud_GetHeight( representative )
        int new = representativeHeight + y

        if( new > max ) new = max
        else if( new < min ) new = min

        int movedY = new - Hud_GetY( representative )

        Hud_SetFocused( Hud_GetChild( scrollbar, "SliderButton" ) )
        SetComponentContentY( scrollbar, new )

        callback( x, movedY )
    } )
}

void function SetScrollbarComponentContentHeight( var component, int height )
{
    Hud_SetHeight( Hud_GetChild( component, "MouseMovementCapture" ), height )
    Hud_SetHeight( Hud_GetChild( component, "SliderButton" ), height )
    Hud_SetHeight( Hud_GetChild( component, "BtnModListSliderPanel" ), height )
}

void function SetComponentContentY( var component, int y )
{
    Hud_SetY( Hud_GetChild( component, "MouseMovementCapture" ), y )
    Hud_SetY( Hud_GetChild( component, "SliderButton" ), y )
    Hud_SetY( Hud_GetChild( component, "BtnModListSliderPanel" ), y )
}

var function GetComponentContentRepresentative( var component )
{
    return Hud_GetChild( component, "MouseMovementCapture" )
}