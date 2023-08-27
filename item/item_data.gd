class_name ItemData
extends Resource

@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
@export var texture: AtlasTexture

## Simulate using something. Overidden in subclass.
func use(_target) -> void:
	pass
