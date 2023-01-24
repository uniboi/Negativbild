global function ModSettingsTest

void function ModSettingsTest()
{
    AddModTitle("SL TEST")
    AddModCategory( "lessgo" )
    AddConVarSettingEnum( "dotres_debug_draw_dimensions", "dotres debug", ["0", "1"] )

    AddModSettingsDropDown( "debug draw dimensions (dotres) - using index", "dotres_debug_draw_dimensions", ["Disabled", "Enabled" ], true )
}