resource/ui/menus/panels/internal/scrollable_list_items.res
{
	Frame
	{
		ControlName			ImagePanel

		tall	f0
		wide	f0

		zpos	-1
		visible	0
		
		image		vgui/hud/white
		drawcolor	"235 235 235 255"
		scaleImage	1
	}

	UpDummy
	{
		ControlName	Label
		labelText	""
	}

	DownDummy
	{
		ControlName	Label
		labelText	""
	}

	Label
	{
		ControlName		Label

		labelText		""
		tall			50
		xpos			-20

		pin_to_sibling				Frame
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		LEFT
	}

	Button
	{
		ControlName 			RuiButton
		//InheritProperties	RuiLoadoutSelectionButton
		xpos	0

		labelText		""

		tall	50

		navUp	UpDummy
		navDown	DownDummy
	}
}