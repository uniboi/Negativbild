untyped // required becaues of file.tooltips indexing

global function RegisterToolTip
global function AddTooltipToElement

struct {
    table<var, var> tooltips
} file

const float APPROX_AVERAGE_CHAR_WIDTH = 12.5
const float TOOLTIP_MARGIN = 5.0

void function RegisterToolTip( var menu, var tooltip )
{
    file.tooltips[ menu ] <- tooltip
}

void function AddTooltipToElement( var elem, string tooltipText, int width = 0 )
{
    Hud_AddEventHandler( elem, UIE_GET_FOCUS,
        var function( var focused ) : ( tooltipText, width )
        {
            if( !( GetActiveMenu() in file.tooltips ) )
                return

            var tooltip = file.tooltips[ GetActiveMenu() ]
            Hud_Show( tooltip )
            Hud_SetPos( tooltip,
                Hud_GetAbsX( focused ) + Hud_GetWidth( focused ) / 2 - tooltipText.len() * APPROX_AVERAGE_CHAR_WIDTH / 2,
                Hud_GetAbsY( focused ) + Hud_GetHeight( focused ) + TOOLTIP_MARGIN )
            SetLabelRuiText( Hud_GetChild( tooltip, "Display" ), tooltipText )

            var frame = Hud_GetChild( tooltip, "Frame" )
            int finalWidth = width
            if( width )
                finalWidth += 40
            Hud_SetWidth( frame, finalWidth )
        }
    )

    Hud_AddEventHandler( elem, UIE_LOSE_FOCUS,
        var function( var focused )
        {
            if( GetActiveMenu() in file.tooltips )
                Hud_Hide( file.tooltips[ GetActiveMenu() ] )
        }
    )
}