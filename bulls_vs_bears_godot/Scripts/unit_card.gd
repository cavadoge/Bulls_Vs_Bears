extends Button

@export var unit_data: Dictionary
signal card_selected(unit_data)

func _ready():
	pressed.connect(_on_pressed)
	update_display()

func _on_pressed():
	emit_signal("card_selected", unit_data)

func update_display():
	$Icon.texture = unit_data.get("icon", null)
	$NameLabel.text = unit_data.get("name", "Unnamed")
	$StatsLabel.text = "ATK: %d | HP: %d" % [
		unit_data.get("atk", 0),
		unit_data.get("hp", 0)
	]
