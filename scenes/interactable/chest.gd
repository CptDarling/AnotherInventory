extends StaticBody3D
class_name Chest

## An interactable treasure chest.

signal toggle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData

func player_interact() -> void:
	toggle_inventory.emit(self)
