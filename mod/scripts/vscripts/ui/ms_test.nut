global function Negativbild_ModSettingsTest

void function Negativbild_ModSettingsTest()
{
    #if NEGATIVBILD_DEV
        AddModTitle("SL TEST")
        AddModCategory( "lessgo" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )

        // ModSettings_AddDropDown( "dotres_debug_draw_dimensions", "debug draw dimensions (dotres) - using index", ["Disabled", "Enabled" ], true )
        ModSettings_AddColorPicker( "dotres_debug_draw_dimensions", "color picker test" )
        ModSettings_AddColorPicker( "dotres_debug_test_color", "color picker test 2" )
    #endif
}