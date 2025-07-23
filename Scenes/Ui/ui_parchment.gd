extends Control

const FYLDPEN = preload("res://Assets/fyldpen.png")

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var parchment_container = $CanvasLayer/Parchment
@onready var left_button = $CanvasLayer/LeftButton
@onready var right_button = $CanvasLayer/RightButton

# Array of document resources
@export var documents: Array[DocumentResource] = []

var current_document_index := 0
var document_lines: Array[Line2D] = []
var document_nodes: Array = []
var is_animating := false

var is_paused: bool = false
var _pressed: bool = false
var _within_bounds: bool = false
var _current_line: Line2D = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	#var new_doc = preload("res://Assets/Documents/parchment.tres")
	#add_document(new_doc)
	initialize_documents()
	hide_pause_menu()
	
	# Connect button signals
	left_button.pressed.connect(_on_left_button_pressed)
	right_button.pressed.connect(_on_right_button_pressed)
	var emitter = get_node("/root/World/Player")
	emitter.connect("document_collected", _on_document_collected)

func initialize_documents():
	# Clear existing documents if any
	
	for child in parchment_container.get_children():
		if child != $CanvasLayer/Parchment/ColorRect and child != left_button and child != right_button:
			child.queue_free()
	
	document_lines.clear()
	document_nodes.clear()
	
	# Create a TextureRect and Line2D for each document
	for doc in documents:
		if not doc or not doc.texture:
			continue
			
		# Create document display
		var texture_rect = TextureRect.new()
		texture_rect.texture = doc.texture
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.size = parchment_container.size
		texture_rect.position = Vector2.ZERO
		parchment_container.add_child(texture_rect)
		
		# Create a container for this document's drawing lines
		var line_container = Node2D.new()
		line_container.position = Vector2.ZERO
		parchment_container.add_child(line_container)
		
		document_nodes.append({
			"texture": texture_rect,
			"bounds": doc.bounds,
			"line_container": line_container
		})
		
		# Create drawing layer for this document
		var line = Line2D.new()
		line.default_color = Color.BLACK
		line.width = 1
		line_container.add_child(line)
		document_lines.append(line)
		
		# Hide all documents except first one
		texture_rect.visible = false
		line_container.visible = false
	
	# Show first document
	show_document(0)

func _on_document_collected(document):
	add_document(document)

# Add this function to your script
func add_document(document: DocumentResource) -> void:
	if not document or not document.texture:
		return
	
	# Create document display
	var texture_rect = TextureRect.new()
	texture_rect.texture = document.texture
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.size = parchment_container.size
	texture_rect.position = Vector2.ZERO
	parchment_container.add_child(texture_rect)
	
	# Create a container for this document's drawing lines
	var line_container = Node2D.new()
	line_container.position = Vector2.ZERO
	parchment_container.add_child(line_container)
	
	# Add to document nodes array
	document_nodes.append({
		"texture": texture_rect,
		"bounds": document.bounds,
		"line_container": line_container
	})
	
	# Create drawing layer for this document
	var line = Line2D.new()
	line.default_color = Color.BLACK
	line.width = 1
	line_container.add_child(line)
	document_lines.append(line)
	
	# Hide the new document if it's not the first one
	if document_nodes.size() > 1:
		texture_rect.visible = false
		line_container.visible = false
	
	# Add to documents array for persistence
	documents.append(document)

func show_document(index: int, direction: int = 0):
	if document_nodes.size() == 0 or is_animating:
		return
	
	# Handle wrapping around
	if index < 0:
		index = document_nodes.size() - 1
	elif index >= document_nodes.size():
		index = 0
	
	# If no direction (initial load), just show the document
	if direction == 0:
		current_document_index = index
		for i in range(document_nodes.size()):
			document_nodes[i]["texture"].visible = (i == index)
			document_nodes[i]["line_container"].visible = (i == index)
		return
	
	is_animating = true
	
	var old_index = current_document_index
	current_document_index = index
	
	# Get document nodes
	var new_texture = document_nodes[index]["texture"]
	var old_texture = document_nodes[old_index]["texture"]
	var new_line_container = document_nodes[index]["line_container"]
	var old_line_container = document_nodes[old_index]["line_container"]
	
	new_texture.visible = true
	new_line_container.visible = true
	
	# Position new document offscreen based on direction
	# 1 = right, -1 = left
	var start_pos = direction * parchment_container.size.x
	new_texture.position.x = start_pos
	new_line_container.position.x = start_pos
	
	# Create animation
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Animate old document out (both texture and lines)
	tween.tween_property(old_texture, "position:x", 
		-direction * parchment_container.size.x, 0.5)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(old_line_container, "position:x", 
		-direction * parchment_container.size.x, 0.5)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	# Animate new document in (both texture and lines)
	tween.tween_property(new_texture, "position:x", 
		0, 0.5)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(new_line_container, "position:x", 
		0, 0.5)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	# Hide old document after animation
	tween.chain().tween_callback(func(): 
		old_texture.visible = false
		old_line_container.visible = false
		old_texture.position = Vector2.ZERO
		old_line_container.position = Vector2.ZERO
		is_animating = false
	)

func _on_left_button_pressed():
	if not is_paused or is_animating:
		return
	show_document(current_document_index - 1, -1)

func _on_right_button_pressed():
	if not is_paused or is_animating:
		return
	show_document(current_document_index + 1, 1)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("parchment") || event.is_action_pressed("ui_cancel"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
	
	# Document navigation
	if is_paused and not is_animating:
		if event.is_action_pressed("ui_left"):
			_on_left_button_pressed()
		if event.is_action_pressed("ui_right"):
			_on_right_button_pressed()

func _input(event: InputEvent) -> void:
	if not is_paused:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_pressed = event.pressed
			
			if _pressed:
				# Check if mouse is within current document's bounds
				var mouse_pos = get_global_mouse_position()
				var local_pos = document_nodes[current_document_index]["line_container"].get_global_transform().affine_inverse() * mouse_pos
				_within_bounds = document_nodes[current_document_index]["bounds"].has_point(local_pos)
				
				if _within_bounds:
					_current_line = Line2D.new()
					_current_line.default_color = Color.BLACK
					_current_line.width = 1
					document_lines[current_document_index].add_child(_current_line)
					_current_line.add_point(local_pos)
				else:
					_current_line = null
			
	elif event is InputEventMouseMotion and _current_line and _pressed:
		var mouse_pos = get_global_mouse_position()
		var local_pos = document_nodes[current_document_index]["line_container"].get_global_transform().affine_inverse() * mouse_pos
		_within_bounds = document_nodes[current_document_index]["bounds"].has_point(local_pos)
		if _within_bounds:
			_current_line.add_point(local_pos)

func show_pause_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	var hotspot = Vector2(4,24)
	Input.set_custom_mouse_cursor(FYLDPEN, Input.CURSOR_ARROW, hotspot)
	get_tree().paused = true
	canvas_layer.visible = true
	is_paused = true

func hide_pause_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_tree().paused = false
	canvas_layer.visible = false
	is_paused = false
	_current_line = null

func _on_color_rect_mouse_entered() -> void:
	var mouse_pos = get_global_mouse_position()
	var local_pos = document_nodes[current_document_index]["line_container"].get_global_transform().affine_inverse() * mouse_pos
	_within_bounds = document_nodes[current_document_index]["bounds"].has_point(local_pos)

func _on_color_rect_mouse_exited() -> void:
	_current_line = null
	_within_bounds = false
