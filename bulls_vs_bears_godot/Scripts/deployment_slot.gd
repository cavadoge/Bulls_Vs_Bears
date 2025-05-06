extends Panel

@export var slot_index: int = 0

signal slot_selected(index: int)

func _ready():
	# Optional: Highlight when hovered, etc.
	mouse_filter = Control.MOUSE_FILTER_PASS

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Slot clicked:", slot_index)
		emit_signal("slot_selected", slot_index)
