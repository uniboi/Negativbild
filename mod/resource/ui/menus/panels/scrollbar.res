resource/ui/menus/panels/scrollbar.res
{
	MouseMovementCapture
	{
		ControlName	CMouseMovementCapturePanel

		wide	50
		tall	50
		zpos	2
	}

	SliderButton
	{
		ControlName			RuiButton
		InheritProperties	RuiSmallButton

		wide	50
		tall	50
		zpos	2

		image		"vgui/hud/white"
		drawColor	"255 255 255 128"
	}

//	SliderButton
//	{
//		ControlName	RuiButton
//		style		RuiButtons
//
//		rui			"ui/loadout_button_medium.rpak"
//		labelText	""
//
//		wide	50
//		tall	50
//		zpos	2
//	}

	BtnModListSliderPanel
	{
		ControlName	RuiPanel

		wide	50
		tall	50
		zpos	0
		visible 1

		rui		"ui/knowledgebase_panel.rpak"
		//rui ""
	}
}