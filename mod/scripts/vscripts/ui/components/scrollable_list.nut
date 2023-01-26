global function RegisterScrollableList
global function UpdateScrollableListContent
global function ScrollList
global function BuildScrollbarContentListener

global struct ScrollbarContent {
    string title
    int contentIndex
    bool disabled
    void functionref( bool ) SetDisabled
}

global struct ScrollbarContentListener {
    int event
    void functionref( var, ScrollbarContent ) callback
}

global struct ScrollableList {
    array<var> nodes
    var component
    var scrollbar
    var buffer
    var frame
    array<ScrollbarContent> contents
    int contentOffset = 0
    int fullHeight
}

global const int SCROLLBAR_ITEM_HEIGHT = 50
const int SCROLLABLE_LIST_MAX_ITEMS = 16
const vector COLOR_INACTIVE = <230, 230, 230>
const vector COLOR_ACTIVE = <0, 0, 0>
const vector COLOR_DISABLED = <50, 50, 50>

ScrollbarContentListener function BuildScrollbarContentListener( int event, void functionref( var, ScrollbarContent ) callback )
{
    ScrollbarContentListener l
    l.event = event
    l.callback = callback
    return l
}

// TODO: implement upscaling from less than 16 initial items
ScrollableList function RegisterScrollableList( var scrollableList, array<string> items, array<ScrollbarContentListener> listeners )
{
    int barHeight = Hud_GetHeight( scrollableList )
    int allItemHeight = items.len() * SCROLLBAR_ITEM_HEIGHT
    float heightPercentage = float( barHeight ) / float( allItemHeight )
    float cappedHeightPercentage = heightPercentage > 1.0 ? 1.0 : heightPercentage
    int calculatedHeight = int( barHeight * cappedHeightPercentage )

    ScrollableList sl
    sl.component = scrollableList
    sl.scrollbar = Hud_GetChild( scrollableList, "Scrollbar" )
    sl.buffer = Hud_GetChild( scrollableList, "ItemBuffer" )
    sl.frame = Hud_GetChild( scrollableList, "Frame" )
    sl.fullHeight = allItemHeight

    // TODO: LIMIT MAX HEIGHT TO 800 (16 * 50 = Buttonslength - extra button * button height )

    int buttonsLength = items.len() > SCROLLABLE_LIST_MAX_ITEMS ? SCROLLABLE_LIST_MAX_ITEMS : items.len()
    if( buttonsLength * SCROLLBAR_ITEM_HEIGHT > barHeight )
        buttonsLength = barHeight / SCROLLBAR_ITEM_HEIGHT

    int itemWidth = Hud_GetWidth( scrollableList ) - Hud_GetWidth( sl.scrollbar )

    // Register the node buffer
    var bufferButton = Hud_GetChild( sl.buffer, "Button" )
    var bufferLabel = Hud_GetChild( sl.buffer, "Label" )
    RegisterScrollableListItem( sl.buffer, itemWidth, SCROLLBAR_ITEM_HEIGHT )
    RegisterAllCallbacksOnNode( bufferButton, listeners, sl, buttonsLength )

    AddButtonEventHandler( bufferButton, UIE_GET_FOCUS, void function( var button ) : ( sl, buttonsLength ) {
        Hud_Show( Hud_GetChild( Hud_GetParent( button ), "Frame" ) )
		SetLabelColor( Hud_GetChild( Hud_GetParent( button ), "Label" ), COLOR_ACTIVE )
    } )

    AddButtonEventHandler( bufferButton, UIE_LOSE_FOCUS, void function( var button ) : ( sl, buttonsLength ) {
        Hud_Hide( Hud_GetChild( Hud_GetParent( button ), "Frame" ) )
        if( !sl.contents[ sl.contentOffset + buttonsLength ].disabled )
			SetLabelColor( Hud_GetChild( Hud_GetParent( button ), "Label" ), COLOR_INACTIVE )
    } )

    // Build contents
    foreach( int i, title in items )
    {
        ScrollbarContent sc
        sc.title = title
        sc.contentIndex = i
        sc.SetDisabled = void function( bool disabled ) : ( sl, sc, i ) {
            sl.contents[ i ].disabled = disabled
            Hud_SetEnabled( Hud_GetChild( sl.nodes[ abs( sl.contentOffset - i ) ], "Button" ), !disabled )
			SetLabelColor( Hud_GetChild( sl.nodes[ abs( sl.contentOffset - i ) ], "Label" ), COLOR_DISABLED )
        }
        sl.contents.append( sc )
    }

    var prevNodeButton = null

    // Build nodes
    for( int i; i < buttonsLength; i++ )
    {
        // int itemIndex = SCROLLABLE_LIST_MAX_ITEMS - buttonsLength + i
        var item = Hud_GetChild( scrollableList, format( "Item%i", i ) )
        var button = Hud_GetChild( item, "Button" )
        var label = Hud_GetChild( item, "Label" )
        sl.nodes.append( item )
        RegisterScrollableListItem( item, itemWidth, SCROLLBAR_ITEM_HEIGHT )
        Hud_SetY( item, SCROLLBAR_ITEM_HEIGHT * i )
        Hud_SetText( label, sl.contents[ i ].title )
        Hud_Show( item )

        RegisterAllCallbacksOnNode( button, listeners, sl, i )

        AddButtonEventHandler( button, UIE_GET_FOCUS, void function( var button ) : ( label ) {
            Hud_Show( Hud_GetChild( Hud_GetParent( button ), "Frame" ) )
			SetLabelColor( label, COLOR_ACTIVE )
        } )

        AddButtonEventHandler( button, UIE_LOSE_FOCUS, void function( var button ) : ( sl, i, label ) {
            Hud_Hide( Hud_GetChild( Hud_GetParent( button ), "Frame" ) )
            if( !sl.contents[ sl.contentOffset + i ].disabled )
				SetLabelColor( label, COLOR_INACTIVE )
        } )

        if( prevNodeButton )
        {
            Hud_SetNavDown( prevNodeButton, button )
            prevNodeButton = button
        }
    }

    Hud_SetSize( Hud_GetChild( scrollableList, "Frame" ), Hud_GetWidth( scrollableList ), Hud_GetHeight( scrollableList ) )

    RegisterScrollbar( sl.scrollbar, void function( int x, int y ) : ( scrollableList, sl, bufferButton, bufferLabel, buttonsLength ) {
        int usable = Hud_GetHeight( sl.scrollbar ) - Hud_GetHeight( Hud_GetChild( sl.scrollbar, "MouseMovementCapture" ) )

        if( !usable )
            return // do nothing if scrollbar can't be moved

        int offset = Hud_GetY( Hud_GetChild( sl.scrollbar, "MouseMovementCapture" ) )
        float offset_p = float( offset ) / float( usable )
        float calculatedContentOffset = ( sl.fullHeight - (sl.nodes.len() - 0) * SCROLLBAR_ITEM_HEIGHT ) * offset_p
        float calcHeightModulo = calculatedContentOffset % SCROLLBAR_ITEM_HEIGHT

        sl.contentOffset = int( calculatedContentOffset / SCROLLBAR_ITEM_HEIGHT )

        foreach( int i, var node in sl.nodes )
        {
            ScrollbarContent sc = sl.contents[ i + sl.contentOffset ]
            var button = Hud_GetChild( node, "Button" )
            var label = Hud_GetChild( node, "Label" )
            Hud_SetY( node, ( i * SCROLLBAR_ITEM_HEIGHT ) - calcHeightModulo )
            Hud_SetText( label, sc.title )
            SetLabelColor( label, sc.disabled ? COLOR_DISABLED : COLOR_INACTIVE )
            Hud_SetEnabled( button, !sc.disabled )
        }

        if( sl.nodes.len() + sl.contentOffset < sl.contents.len() )
        {
            ScrollbarContent sc = sl.contents[ sl.nodes.len() + sl.contentOffset ]
            Hud_SetText( bufferLabel, sc.title )
            Hud_SetY( sl.buffer, sl.nodes.len() * SCROLLBAR_ITEM_HEIGHT - calcHeightModulo )
            Hud_Show( sl.buffer )
            Hud_SetEnabled( bufferButton, !sc.disabled )
            SetLabelColor( bufferLabel, sc.disabled ? COLOR_DISABLED : COLOR_INACTIVE )
        } else {
            Hud_Hide( sl.buffer )
        }
    } )
    
    SetScrollbarComponentHeight( sl.scrollbar, barHeight )
    SetScrollbarComponentContentHeight( sl.scrollbar, calculatedHeight )

    return sl
}

void function UpdateScrollableListContent( ScrollableList sl, array<string> contents, int ornull height = null )
{
    UICodeCallback_MouseMovementCapture( Hud_GetChild( sl.scrollbar, "MouseMovementCapture" ), 0, -( sl.contents.len() * SCROLLBAR_ITEM_HEIGHT ) ) // Scroll to top
    sl.contents.clear()
    sl.contentOffset = 0

    int barHeight = height == null ? Hud_GetHeight( sl.component ) : expect int( height )
    int allItemHeight = contents.len() * SCROLLBAR_ITEM_HEIGHT
    float heightPercentage = float( barHeight ) / float( allItemHeight )
    float cappedHeightPercentage = heightPercentage > 1.0 ? 1.0 : heightPercentage
    int calculatedHeight = int( barHeight * cappedHeightPercentage )

    int buttonsLength = contents.len() > SCROLLABLE_LIST_MAX_ITEMS ? SCROLLABLE_LIST_MAX_ITEMS : contents.len()
    if( buttonsLength * SCROLLBAR_ITEM_HEIGHT > barHeight )
        buttonsLength = barHeight / SCROLLBAR_ITEM_HEIGHT

    sl.fullHeight = allItemHeight

    // Build contents
    foreach( int i, title in contents )
    {
        ScrollbarContent sc
        sc.title = title
        sc.contentIndex = i
        sc.SetDisabled = void function( bool disabled ) : ( sl, sc, i ) {
            sl.contents[ i ].disabled = disabled
            Hud_SetEnabled( Hud_GetChild( sl.nodes[ abs( sl.contentOffset - i ) ], "Button" ), !disabled )
			SetLabelColor( Hud_GetChild( sl.nodes[ abs( sl.contentOffset - i ) ], "Label" ), COLOR_DISABLED )
        }
        sl.contents.append( sc )
    }

    // todo: instead of clearing all nodes, append only nodes that were previously hidden
    foreach( node in sl.nodes )
        Hud_Hide( node )
    sl.nodes.clear()

    if( buttonsLength < sl.nodes.len() )
        sl.nodes = sl.nodes.slice( 0, buttonsLength )
    else
        for( int i; i < buttonsLength; i++ )
        {
            sl.nodes.append( Hud_GetChild( sl.component, format( "Item%i", i     ) ) )
        }

    // reset nodes
    foreach( i, node in sl.nodes )
    {
        Hud_Show( node )
        Hud_SetText( Hud_GetChild( node, "Label" ), sl.contents[ i ].title )
        Hud_SetEnabled( Hud_GetChild( node, "Button" ), true )
        Hud_SetY( node, SCROLLBAR_ITEM_HEIGHT * i )
        sl.contents[ i ].disabled = false
    }

    SetScrollbarComponentContentHeight( sl.scrollbar, calculatedHeight )
    if( height != null )
    {
        expect int( height )
        SetScrollbarComponentHeight( sl.scrollbar, height )
        Hud_SetHeight( Hud_GetChild( sl.component, "Frame" ), height )
        Hud_SetHeight( sl.component, height )
    }
}

void function RegisterAllCallbacksOnNode( var button, array<ScrollbarContentListener> listeners, ScrollableList sl, int add )
{
    foreach( ScrollbarContentListener listener in listeners )
    {
        AddButtonEventHandler( button, listener.event,
            void function( var button ) : ( sl, listener, add )
            {
                listener.callback( button, sl.contents[ sl.contentOffset + add ] )
            }
        )
    }
}

void function SetLabelColor( var label, vector c )
{
    Hud_SetColor( label, c.x, c.y, c.z, 255 )
}

void function ScrollList( ScrollableList sl, int height )
{
    UICodeCallback_MouseMovementCapture( Hud_GetChild( sl.scrollbar, "MouseMovementCapture" ), 0, height )
}
