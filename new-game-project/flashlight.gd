extends Node3D

var light_on = false

func set_light_on() -> void:
	$SpotLight3D.light_energy = 16

func set_ligt_off() -> void:
	$SpotLight3D.light_energy = 0

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Toggle"):
		light_on = !light_on
		if light_on:
			set_light_on()
		else:
			set_light_off()

func _physics_process(delta: float) -> void:
	if light_on:
		$Battery.value -= 0.05

		if $Batter.value <= 0:
			light_on = false
			set_light_off()
