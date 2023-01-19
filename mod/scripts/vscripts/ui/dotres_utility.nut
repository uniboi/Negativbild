globalize_all_functions

bool function dotresDimensions()
{
    return GetConVarBool( "dotres_debug_draw_dimensions" )
}

void function DrawDebugFrame( var p, var frame = null )
{
    if( !frame ) frame = Hud_GetChild( p, "DebugFrame" )
    Hud_SetSize( frame, Hud_GetWidth( p ), Hud_GetHeight( p ) )
    if( dotresDimensions() )  Hud_Show( frame )
}

void function HideDebugFrame( var p, var frame = null )
{
    if( !frame ) frame = Hud_GetChild( p, "DebugFrame" )
    if( dotresDimensions() ) Hud_Hide( frame )
}