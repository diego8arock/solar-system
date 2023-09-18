@tool
extends Resource
class_name PlanetNoise

@export var noise_map : FastNoiseLite : set = set_noise_map
@export var amplitude : float = 1.0 : set = set_amplitude
@export var min_height : float = 1.0 : set = set_min_height
@export var use_first_layer_as_mask : bool = false : set = set_use_first_layer_as_mask

func set_amplitude(val):
	amplitude = val
	emit_changed()
	
func set_min_height(val):
	min_height = val
	emit_changed()

func set_use_first_layer_as_mask(val):
	use_first_layer_as_mask = val
	emit_changed()
	
func set_noise_map(val):
	noise_map = val
	emit_changed()
	var callable = Callable(self,"on_data_changed")
	if noise_map != null and not noise_map.changed.is_connected(callable):
		noise_map.changed.connect(callable)
		
func on_data_changed():
	emit_changed()
