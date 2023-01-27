resource/ui/menus/panels/scrollable_list.res
{
	Frame
	{
		ControlName			ImagePanel

		tall	f0
		wide	f0

		ypos	-1
		visible	0
		
		image		vgui/hud/white
		drawcolor	"0 255 0 128"
		scaleImage	1
	}

	SLScrollbar
	{
		ControlName			CNestedPanel

		wide	50

		controlSettingsFile	"resource/ui/menus/panels/scrollbar.res"

		pin_to_sibling				Frame
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		RIGHT
	}

	Item0
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}

	Item1
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
	
	Item2
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
	
	Item3
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
	
	Item4
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
	
	Item5
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}

	Item6
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
	
	Item7
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
	
	Item8
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
	
	Item9
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
	
	Item10
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
	
	Item11
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
	
	Item12
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}

	Item13
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
	
	
	Item14
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}

	Item15
	{
		ControlName			CNestedPanel
		classname			listItem
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}

	ItemBuffer
	{
		ControlName			CNestedPanel
		visible				0

		controlSettingsFile	"resource/ui/menus/panels/internal/scrollable_list_item.res"
	}
}