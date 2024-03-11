# Hello from Mary
extends Node

var samples:Array
var pads:Dictionary

@export var path_str = "res://samples" 
@export var pad_scene:PackedScene
@export var row_scene:PackedScene

@export var num_pads = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the path to the folder containing the WAV fes
	# make_pads()
	load_samples()
	make_sample_buttons()

func make_pads():
	var w
	var g
	for i in range(num_pads):
		var pad = pad_scene.instantiate()
		var ww:ColorRect = pad.get_node("rect")
		w = ww.get_size().x
		g = w * 0.1
		
		var p = Vector2((i * (w + g)), 0)
		pad.position = p
		add_child(pad)

func button_pressed(i):
	# $AudioStreamPlayer.stream = samples[i]
	# $AudioStreamPlayer.play()
	print(i)

func play_sample(i):
	
	var p:AudioStream = samples[i]
	# $AudioStreamPlayer.stream = p
	# $AudioStreamPlayer.play()

func make_sample_buttons():	
	var cols = 2
	var col = 0
	var row_node
	var col_node
	for i in range(samples.size()):
		if col == 0:
			row_node = row_scene.instantiate()
			$HScrollBar/VBoxContainer.add_child(row_node)
			col_node = row_node.get_node("col0")
			col = 1
		else:
			col_node = row_node.get_node("col1")
			col = 0
		col_node.set_text(samples[i].resource_name)	
		# player.hit.connect(_on_player_hit.bind("sword", 100))

		col_node.pressed.connect(play_sample.bind("i", i))
		# sample.get_node("label").set_text(samples[i].resource_name)
		# sample.get_node("AudioStreamPlayer2D").stream = samples[i]
		
func load_samples():
	var dir = DirAccess.open(path_str)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		# From https://forum.godotengine.org/t/loading-an-ogg-or-wav-file-from-res-sfx-in-gdscript/28243/2
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			if file_name.ends_with('.wav.import'):			
				file_name = file_name.left(len(file_name) - len('.import'))
				# var asp = AudioStreamPlayer.new()
				# asp.set_stream(load(SOUND_DIR + '/' + filename))
				# add_child(asp)
				# var arr = file_name.split('/')
				# var name = arr[arr.size()-1].split('.')[0]
				# samples[name] = asp
			
				var stream = load(path_str + "/" + file_name)
				stream.resource_name = file_name
				samples.push_back(stream)
				# $AudioStreamPlayer.play()
				# break
			file_name = dir.get_next()	
