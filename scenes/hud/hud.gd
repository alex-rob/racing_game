extends Control

@export var player: Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_energy(player.max_energy, player.energy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func draw_energy(max_energy: int, energy: int) -> void:
	var current_cell: EnergyCell
	for n in max_energy:
		current_cell = EnergyCell.new()
		$EnergyContainer.add_child(current_cell)
		if n <= energy:
			current_cell.set_full()
		else:
			current_cell.set_empty()
		
