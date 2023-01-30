# Negativbild

Negativbild is a mod for the [Northstar Client](https://northstar.tf) that implements some UI utilities.

## Documentation

There is no generated documentation available yet.

### Scrollbars

A scrollbar is a movable slider that is usable in a confined space.

- `void function RegisterScrollbar( var scrollbar, void functionref( int x, int y ) callback )`

  Registers a new scrollbar

  The passed vgui element needs to be a `CNestedPanel` loading `scrollbar.res`

  ```
  Scrollbar
  {
  	ControlName	CNestedPanel
  	wide	50
  	controlSettingsFile	"resource/ui/menus/panels/scrollbar.res"
  }
  ```

- `void function SetScrollbarComponentContentHeight( var component, int height )`

  Update the height of all slider contents.

### Scrollable Lists

Scrollable Lists allow representing infinite amounts of data in a list with a smooth scrolling effect.

    	Scrollable Lists can not be taller than 800 pixels!

- `ScrollableList function RegisterScrollableList( var scrollableList, array<string> items, array<ScrollbarContentListener> listeners )`

  Register a new scrollable list

  The passed vgui element needs to be a `CNestedPanel` loading `scrollable_list.res`

  ```
  ScrollableList
  {
  	ControlName	CNestedPanel
  	wide	200
  	tall	800
  }
  ```

- `void function UpdateScrollableListContent( ScrollableList sl, array<string> contents, int ornull height = null )`

  Update the contents and optionally height of a list.

- `void function ScrollList( ScrollableList sl, int height )`

  Scroll the slider `height` amount of pixels down. Negative `height` scrolls up.

- `ScrollbarContentListener function BuildScrollbarContentListener( int event, void functionref( var, ScrollbarContent ) callback )`

  Build a `ScrollbarContentListener` struct instance from the parameters.

#### Structs

Do not change any values directly.

- `ScrollableList`

  | slot          | type                     | description                                                        |
  | ------------- | ------------------------ | ------------------------------------------------------------------ |
  | nodes         | array<var\>              | nodes that are currently in use                                    |
  | component     | var                      | the parent vgui element                                            |
  | buffer        | var                      | buffer element used for a smooth transition effect at max capacity |
  | contents      | array<ScrollbarContent\> | all contents of this list                                          |
  | contentOffset | int                      | first rendered content index                                       |
  | fullHeight    | int                      | combined height of all used nodes used for internal purposes       |

- `ScrollbarContentListener`

  | slot     | type                                      | description                                        |
  | -------- | ----------------------------------------- | -------------------------------------------------- |
  | event    | int                                       | UIE id of for the event that triggers the callback |
  | callback | void functionref( var, ScrollbarContent ) | callback executed for this event                   |

- `ScrollbarContent`

  | slot             | type                     | description                                                                 |
  | ---------------- | ------------------------ | --------------------------------------------------------------------------- |
  | string title     | string                   | displayed title for this item                                               |
  | int contentIndex | int                      | index of this item in the array of all contents                             |
  | bool disabled    | bool                     | denotes if this item is disabled                                            |
  | SetDisabled      | void functionref( bool ) | This function is automatically set up. Use this to disable this item button |

#### Globals

- `global const int SCROLLBAR_ITEM_HEIGHT = 50`

### Tooltips

Tooltips show a label with extra information when `UIE_GET_FOCUS` is triggered.

- `void function RegisterToolTip( var menu, var tooltip )`

  Register a tooltip element for a menu. This element will jump to elements that have been registered with `AddTooltipToElement`. Only one tooltip can be registered per menu.

  The `tooltip` vgui element needs to be a `CNestedPanel` extending `tooltip.res` and should by default be invisible:

  ```
  Tooltip
  {
  	ControlName	CNestedPanel
  	controlSettingsFile	"resource/ui/menus/panels/tooltip.res"
  	visible	0
  }
  ```

- `void function AddTooltipToElement( var elem, string tooltipText, int width = 0 )`

  Register a tooltip for an element. Make sure a registered tooltip exists on the same menu as `elem`.

  The `elem` vgui element should be of a type that receives the `UIE_GET_FOCUS` by hovering like buttons.

## Dropdown

Opens a submenu containing a `ScrollableList` with a set of options. When an element of the list is clicked, the submenu is closed and the selected title and index are signaled on `DropDownSelected`

- `void function OpenDropDown( array<string> contents )`

  Opens a dropdown at the mouse cursors current position.

- `void function OpenDropDownCalc( array<string> contents, int[2] functionref( var ) positionCallback )`

  Opens a dropdown at the returned value of `positionCallback`.

- `int[2] function DefaultSubmenuPosition( var frame )`

  Returns the frame position for opened submenus at the cursor.

  > This is only of value if you are using custom submenus

- `void function OpenDropDownSubmenu( var menu, int[2] functionref( var ) positionCallback )`

  Opens a DropDown submenu at the calculated position

  > This is only of value if you are using custom submenus

### Color Pickers

Color pickers allow the user to select a color from a color circle.

To enable a color picker, signal `ColorPickerRevive` (for example when opening a menu containing one) and disable it with the `ColorPickerKill` signal (e.g. when closing the menu).

- `table<string, var> function RegisterColorPicker( var elem )`

  Registers a new color picker. Like the `DropDown` the picker signals a selected value on the `ColorPickerSelected` signal in the `color` index.

  The selected color is a rgb value stored in a `vector` or `null`

  The passed vgui element needs to be a `CNestedPanel` loading `color_picker.res`:

  ```
  ColorPicker
  {
  	ControlName	CNestedPanel
  	controlSettingsFile	"resource/ui/menus/panels/color_picker.res"

  	wide	375
  	wide	300
  }
  ```

  The vgui element needs to be 75 pixels wider than high to be able to correctly render the color preview patch.

### Color Picker Dialog

The color picker dialog changes the value of a ConVar on select. It does not close on it's own.

- `void function OpenColorPickerDialog( string conVar, bool liveUpdate = false, bool update = true, bool reset = false )`

  Open a color picker dialog at the cursor position.

  #### Parameters

  - `conVar` - The convar that the value will be saved to
  - `liveUpdate` - If `true`, `ColorPickerLiveUpdate` will be triggered every frame the cursor hovers over a color with the color in the color in the `color` slot of the result.
  - `update` - If `true`, the color will be saved to the given ConVar on click and live update, if enabled
  - `reset` - If `true`, `conVar` will be resetted to it's default value. The Reset button emits the `ColorPickerDialogReset` signal that you can use for custom reset logic. 

#### Example

```js
OpenColorPickerDialog( conVar ) // open the dialog
thread void function()
{
	WaitSignal( uiGlobal.signalDummy, "ColorPickerSelected" ) // wait until a color is selected
	CloseSubMenu() // close the dialog
}()
```

### Mod Settings Utilities

- `void function AddModSettingsDropDown( string conVar, string buttonLabel, array<string> options, bool useIndex = false )`

  Adds a button to the last settings category that opens a DropDown on click.

  The value of `conVar` will be set to the index of the option if `useIndex` is `true`, otherwise the title will be stored.

  ```js
  // an example to use the dropdown instead of the common Mod Settings enum
  AddModSettingsDropDown("cv_feature_enabled", "Some Feature Enabled", [
    "Disabled",
    "Enabled",
    true,
  ]);
  ```

- `void function AddModSettingsColorPicker( string conVar, string buttonLabel )`

  Adds a button to the last settings category that opens a Color Picker Dialog when clicked.

  `conVar` needs to be a string in this format: `r g b`. You can retrieve the rgb values like this:

  ```js
  array<string> split = split( GetConVarString( conVar ), " " )
  vector rgb = < float( split[0] ), float( split[1] ), float( split[2] ) >

  // store rgb vector in a convar
  SetConVarString( conVar, format( "%.2f, %.2f, %.2f", r, g, b ) )
  ```

  The submenu is automatically closed when a color is selected.
