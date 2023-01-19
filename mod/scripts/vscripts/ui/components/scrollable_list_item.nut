global function RegisterScrollableListItem

const PLAIN_RUI_BUTTON_LEFT_OFFSET = 60

void function RegisterScrollableListItem( var item, int width, int height )
{
    SetScrollableListItemComponentWidth( item, width )
    SetScrollableListItemComponentContentWidth( item, width )
    SetScrollableListItemComponentHeight( item, height )
    SetScrollableListItemComponentContentHeight( item, height )

    var button = Hud_GetChild( item, "Button" )
    var label = Hud_GetChild( item, "Label" )
}

void function SetScrollableListItemComponentHeight( var component, int height )
{
    Hud_SetHeight( component, height )
    Hud_SetHeight( Hud_GetChild( component, "Frame" ), height )
}

void function SetScrollableListItemComponentContentHeight( var component, int height )
{
    Hud_SetHeight( Hud_GetChild( component, "Button" ), height )
}

void function SetScrollableListItemComponentWidth( var component, int width )
{
    Hud_SetWidth( component, width )   
    Hud_SetWidth( Hud_GetChild( component, "Frame" ), width )
    Hud_SetWidth( Hud_GetChild( component, "Label" ), width )
    Hud_SetWidth( Hud_GetChild( component, "Button" ), width )
}

void function SetScrollableListItemComponentContentWidth( var component, int width )
{
    Hud_SetWidth( Hud_GetChild( component, "Button" ), width )
}