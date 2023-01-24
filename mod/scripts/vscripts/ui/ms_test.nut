global function ModSettingsTest

void function ModSettingsTest()
{
    AddModTitle("SL TEST")
    AddModCategory( "lessgo" )
    AddConVarSettingEnum( "dotres_debug_draw_dimensions", "dotres debug", ["0", "1"] )

    AddModSettingsDropDown( "dotres_debug_draw_dimensions", "debug draw dimensions (dotres) - using index", ["Disabled", "Enabled" ], true )
    AddModSettingsColorPicker( "dotres_debug_draw_dimensions", "color picker test" )
}