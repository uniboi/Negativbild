resource/ui/menus/panels/color_picker.res
{
	ColorCircle
	{
		ControlName	ImagePanel
		image		vgui/color_circle
		scaleImage	1

		tall	300
		wide	300

		pin_to_sibling				TestList
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	ColorIndicator
	{
		ControlName ImagePanel
		image		vgui/hud/white
		scaleImage	1

		tall	50
		wide	50

        xpos    25

		pin_to_sibling				ColorCircle
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		RIGHT
	}
}