extends Node2D

#This is to load things before the Ready function
@onready var tile_map : TileMap = $TileMap

#These are all the layers of our tilemap!
var base_layer = 0 #background
var pattern_layer = 1 #drawn pattern of the work
var border_layer = 2 #layer with the border stitched in!
var anchor_layer = 3 #anchor thread layer (for visibility / extra tiles)
var stitch_layer = 4 #layer where we add our stitches
var icon_layer = 5 #layer where we can render indicators

@export var cell_size = 128

@export var anchor_line_renderer : Line2D

enum State {
	STATE_STITCHDOWN,
	STATE_SELECTSTARTPOS,
	STATE_ANCHORLINE,
	STATE_STITCHING,
	STATE_PAUSED
	}

#This is the direciton the stitches are going in!
enum Direction {
	Left,
	Right,
	Up,
	Down
}

#This keeps a list of our starting tiles
var _starting_positions : Array = [] #Vector2i
var _starting_positions_directions : Array = [] #enum Direction

#Keeps track of game state
var game_state : State
var invalid_position : Vector2i = Vector2i(-100000, -100000)

var original_starting_position : Vector2i 
var start_of_row : Vector2i = Vector2i(-100000, -100000)
var row_direction : Direction 
var end_of_row : Vector2i


# Called when the node enters the scene tree for the first time.
func _ready():
	game_state = State.STATE_SELECTSTARTPOS
	_determine_starting_positions()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_state == State.STATE_ANCHORLINE:
		anchor_line_renderer.visible = true
		anchor_line_renderer.set_point_position (1, get_local_mouse_position())
	else:
		anchor_line_renderer.visible = false
	
func _input(event):
	if game_state == State.STATE_SELECTSTARTPOS:
		_pick_starting_position()
		
	if game_state == State.STATE_ANCHORLINE:
		_draw_anchor_line_dynamic(end_of_row, row_direction)
		
	#if game_state == State.STATE_ANCHORLINE:
		

#Allows the player to select the beginning position for their lace project from a series of starting tiles
func _pick_starting_position():
	if Input.is_action_just_pressed("Click"):
			print("Trying to get start pos")
			print(start_of_row)
			var mouse_pos = get_global_mouse_position()
			var tile_pos = tile_map.local_to_map(mouse_pos)
			for index in _starting_positions.size(): # Same as: `for index in range(items.size()):`
				var check_pos = _starting_positions[index]
				if check_pos == tile_pos:
					print("Is a valid starting position")
					start_of_row = check_pos
					original_starting_position = check_pos
					tile_map.clear_layer(icon_layer)
					row_direction = _starting_positions_directions[index]
					print(Direction.keys()[row_direction])
					_get_end_of_current_row()
			if start_of_row == invalid_position:
				print("Not a valid position")
				

#Getting the last tile in a 'row' of tiles
#This will go up to the border! 
func _get_end_of_current_row():
	var starting_tile = start_of_row
	var current_tile = starting_tile
	var dir = row_direction
	print(starting_tile)
	print(Direction.keys()[row_direction])
	for n in 4000:
		var next_tile : Vector2i = _get_next_tile(current_tile, row_direction)
		var tile_data = tile_map.get_cell_tile_data(border_layer, next_tile)
		print(next_tile)
		if !tile_data:
			current_tile = next_tile
			print("End of row not found")
			continue
	
		if tile_data:
			end_of_row = current_tile
			game_state = State.STATE_ANCHORLINE
			tile_map.set_cell(icon_layer, end_of_row, 0, Vector2i(2,1))
			print("End of row found")
			print (end_of_row)
			break
			
func _draw_anchor_line_dynamic(tile_pos :Vector2i, dir : Direction):
	var tile_top_right_pos : Vector2 = tile_map.map_to_local(tile_pos) + Vector2(cell_size / 2, -cell_size / 2) 
	var tile_top_left_pos : Vector2 = tile_map.map_to_local(tile_pos) + Vector2(-cell_size / 2, -cell_size / 2)
	var tile_bottom_right_pos : Vector2 = tile_map.map_to_local(tile_pos) + Vector2(cell_size / 2, cell_size / 2) 
	var tile_bottom_left_pos : Vector2 = tile_map.map_to_local(tile_pos) + Vector2(-cell_size / 2, cell_size / 2)
	
	var anchor_start_pos : Vector2
	
	if(dir == Direction.Down):
		anchor_start_pos = tile_bottom_right_pos
		
	if(dir == Direction.Left):
		anchor_start_pos = tile_bottom_left_pos
		
	if(dir == Direction.Right):
		anchor_start_pos = tile_top_right_pos
		
	if(dir == Direction.Up):
		anchor_start_pos = tile_top_left_pos
	
	anchor_line_renderer.set_point_position (0, anchor_start_pos)
	


#Gets the next tile, accounting for the 'direction'
func _get_next_tile(tile : Vector2i, dir : Direction):
	var next_tile : Vector2i
	var direction_vec : Vector2i
	
	#These are all of the coordinate shifts used to get tiles on the cardinal directions 
	#(based on the Godot tile system)
	if(dir == Direction.Down):
		direction_vec = Vector2i(0, 1)
		
	if(dir == Direction.Left):
		direction_vec = Vector2i(-1, 0)
		
	if(dir == Direction.Right):
		direction_vec = Vector2i(1, 0)
		
	if(dir == Direction.Up):
		direction_vec = Vector2i(0, -1)
		
	next_tile = tile + direction_vec
	
	#We return the Vector2i of the adjacent tile
	return next_tile
	
	
#SELECT START POS FUNC
func _determine_starting_positions():

	#iterate over tilemap tiles
	for y in range(-40, 40):
		for x in range(-60,60):
			var tile_pos : Vector2i = Vector2i(x, y)
			
#			print_debug(tile_pos)
			var tile_data = tile_map.get_cell_tile_data(border_layer, tile_pos)
			if !tile_data: #if there's no tile data, it's not an edge tile, and we want to know if there's edges around it!
#				print(tile_data.get_custom_data("isEdge"))
#				print(tile_pos)
				
				#We check each of the cardinal directions around it 
				var north_tile = tile_map.get_cell_tile_data(border_layer, Vector2i(x, y - 1))
				var south_tile = tile_map.get_cell_tile_data(border_layer, Vector2i(x, y + 1))
				var east_tile = tile_map.get_cell_tile_data(border_layer, Vector2i(x + 1, y))
				var west_tile = tile_map.get_cell_tile_data(border_layer, Vector2i(x - 1, y))
				
				#For it to be a corner where you can start, it needs to border more than just one edge tile
				#We can keep that count here
				#Now those tiles need to be diagonal to each other (eg, north and west, not north and south)
				#We can get the direction at the same time
				var number_of_edges_around_it_north = 0
				var number_of_edges_around_it_south = 0
				var direction : Direction
				
				#For each tile that is an edge, we can increment by one! 
				
				if north_tile:
					number_of_edges_around_it_north = number_of_edges_around_it_north + 1
					if east_tile:
						number_of_edges_around_it_north = number_of_edges_around_it_north + 1
						direction = Direction.Left
						print(Direction.keys()[direction])
					if west_tile:
						number_of_edges_around_it_north = number_of_edges_around_it_north + 1
						direction = Direction.Down
						print(Direction.keys()[direction])
					
				if south_tile:
					number_of_edges_around_it_south = number_of_edges_around_it_south + 1
					if east_tile:
						number_of_edges_around_it_south = number_of_edges_around_it_south + 1
						direction = Direction.Up
						print(Direction.keys()[direction])
					if west_tile:
						number_of_edges_around_it_south = number_of_edges_around_it_south + 1
						direction = Direction.Right
						print(Direction.keys()[direction])
					
				if number_of_edges_around_it_north >= 2:
					print("Has two edges - north")
					_starting_positions.append(tile_pos)
					_starting_positions_directions.append(direction)
					tile_map.set_cell(icon_layer, tile_pos, 0, Vector2i(2,1))
					
					#void set_cell(layer: int, coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0)
					
				if number_of_edges_around_it_south >= 2:
					print("Has two edges - south")
					_starting_positions.append(tile_pos)
					_starting_positions_directions.append(direction)
					tile_map.set_cell(icon_layer, tile_pos, 0, Vector2i(2,1))
					
	pass


	
#This is the most basic version! 
#func _input(event):
#	if Input.is_action_just_pressed("Click"):
#		var mouse_pos = get_global_mouse_position()
#		var tile_pos = tile_map.local_to_map(mouse_pos)
#		#This is the tileset ID
#		var source_id = 0
#		#This is to select the tile
#		var atlas_coord = Vector2i(22, 13)
#		print_debug(tile_pos)
#		tile_map.set_cell(base_layer, tile_pos, source_id, atlas_coord)
