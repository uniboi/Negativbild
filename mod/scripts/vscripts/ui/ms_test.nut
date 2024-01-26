global function Negativbild_ModSettingsTest

void function Negativbild_ModSettingsTest()
{
    #if NEGATIVBILD_DEV
        AddModTitle("SL TEST")
        AddModCategory( "lessgo" )
        AddConVarSetting( "dotres_debug_draw_dimensions", "dotres debug", "float3" )

        ModSettings_AddColorPicker( "dotres_debug_test_color", "color picker test 2" )
    #endif
}
