extends Node3D


func _ready():
	for child in get_children():
		var face = child as PlanetFaceMesh
		face.regenerate_mesh()

