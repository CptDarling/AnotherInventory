class_name InventoryDataEquip
extends InventoryData

## An inventory that only holds equipable items.

signal item_equipped(ItemDataEquip)
signal item_unequipped(ItemDataEquip)


func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:

	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data

	item_equipped.emit(grabbed_slot_data.item_data)
	return super.drop_slot_data(grabbed_slot_data, index)


func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:

	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data

	item_equipped.emit(grabbed_slot_data.item_data)
	return super.drop_single_slot_data(grabbed_slot_data, index)


func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]

	if slot_data:
		item_unequipped.emit(slot_data.item_data)

	return super.grab_slot_data(index)
