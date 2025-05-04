extends Node

signal phase_changed(new_phase)
signal battle_started
signal planning_started
signal recap_started

enum GamePhase { PLANNING, BATTLE, RECAP }

var current_phase: GamePhase = GamePhase.PLANNING
var current_quarter: int = 1
var max_quarters: int = 4
var target_market_cap: int = 1000
var player_score: int = 0
var enemy_score: int = 0

@onready var planning_layer = $GameScene/PlanningLayer
@onready var battle_layer = $GameScene/BattleLayer
@onready var pump_unit_container = $GameScene/PumpSide/PumpUnitContainer
@onready var dump_unit_container = $GameScene/DumpSide/DumpUnitContainer
@onready var market_cap_meter = $MainUI/TopPanel/MarketCapMeter
@onready var score_counter = $MainUI/TopPanel/ScoreCounter
@onready var cycle_indicator = $MainUI/TopPanel/CycleIndicator
@onready var recap_scene = $RecapScene

func _ready():
	#set_phase(GamePhase.PLANNING)
	#update_ui()
	print(pump_unit_container.name)  # This will error out at runtime


func set_phase(new_phase: GamePhase) -> void:
	current_phase = new_phase
	emit_signal("phase_changed", new_phase)

	match new_phase:
		GamePhase.PLANNING:
			planning_layer.visible = true
			battle_layer.visible = false
			emit_signal("planning_started")
		GamePhase.BATTLE:
			planning_layer.visible = false
			battle_layer.visible = true
			start_battle()
		GamePhase.RECAP:
			planning_layer.visible = false
			battle_layer.visible = false
			show_recap()
			emit_signal("recap_started")

	update_ui()

func start_battle() -> void:
	emit_signal("battle_started")
	# Instantiate and activate unit logic here
	# Score calculation logic goes here, too
	await get_tree().create_timer(3.0).timeout  # Simulate battle duration
	conclude_battle()

func conclude_battle() -> void:
	# Compare scores and adjust market cap
	var diff = player_score - enemy_score
	target_market_cap += diff
	update_ui()

	if current_quarter < max_quarters:
		current_quarter += 1
		set_phase(GamePhase.PLANNING)
	else:
		set_phase(GamePhase.RECAP)

func show_recap() -> void:
	recap_scene.visible = true
	# Populate recap details...

func update_ui() -> void:
	market_cap_meter.value = target_market_cap
	score_counter.text = "📈 %d  |  📉 %d" % [player_score, enemy_score]
	cycle_indicator.text = "Q%d" % current_quarter
