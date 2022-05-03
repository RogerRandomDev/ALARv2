extends Node
class_name CraftingSystem
var thread=Thread.new()
var s=Semaphore.new()
var cur_function=""
var cur_funciton_data=[]
var player=null
var crafting_menu=null
func _ready():
	player=GB.player
	thread.start(run_check)




func run_check():
	while true:
		s.wait()
		if !has_method(cur_function):continue
		call(cur_function)

#loads craftable items to the players inventory crafting menu
func load_available_items():
	var menu_list=crafting_menu.get_node("List")
	for item in menu_list.get_item_count():menu_list.remove_item(0)
	var player_owned_items=player.inventory.get_owned_items()
	for recipe in ItemSystem.allRecipes:
		var add=true
		for needs in recipe.input:
			if !player_owned_items.has(needs):
				add=false
				break
		if add:
			menu_list.add_item(recipe.out,ItemSystem.loadItemTexture(recipe.out))
