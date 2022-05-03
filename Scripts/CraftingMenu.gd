extends HBoxContainer

var crafting=load("res://global/CraftingHandler.gd").new()

func _ready():
	crafting.crafting_menu=self
	crafting._ready()
	get_parent().get_parent().connect("inventory_opened",load_recipes)



func load_recipes():
	crafting.cur_function="load_available_items"
	crafting.s.post()
