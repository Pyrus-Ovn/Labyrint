extends Control
const FYLDPEN = preload("res://Assets/fyldpen.png")
@onready var canvas_layer: CanvasLayer = $CanvasLayer
#@onready var parchment: Sprite2D = $CanvasLayer/Parchment
@onready var draw_rect: ColorRect = $CanvasLayer/Parchment/CanvasLayer/drawRect
#@onready var line_2d: Line2D = $CanvasLayer/Parchment/CanvasLayer/Line2D
@onready var _lines: Line2D = $CanvasLayer/Parchment/Line2D
"res://Assets/fyldpen.png"
var is_paused : bool = false
var _pressed: bool = false
var _within_bounds : bool = false
var _current_line: Line2D = null
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_pause_menu()



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("parchment")||event.is_action_pressed("ui_cancel"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
		#get_viewport().set_input_as_handled()
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_pressed = event.pressed
			
			if _pressed and _within_bounds:
				_current_line = Line2D.new()
				_current_line.default_color = Color.BLACK
				_current_line.width = 1
				#_current_line.z_index = 10000
				_lines.add_child(_current_line)
				_current_line.add_point(event.position)
	elif event is InputEventMouseMotion and _current_line and _pressed and _within_bounds:
		_current_line.add_point((event.position))
func show_pause_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	var hotspot = Vector2(4,24)
	Input.set_custom_mouse_cursor(FYLDPEN, Input.CURSOR_ARROW, hotspot)
	get_tree().paused = true
	canvas_layer.visible = true
	is_paused = true
	#button_save.grab_focus()
	
func hide_pause_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_tree().paused = false
	canvas_layer.visible = false
	is_paused = false




func _on_color_rect_mouse_entered() -> void:
	print("mouse in")
	_within_bounds = true


func _on_color_rect_mouse_exited() -> void:
	print("mouse out")
	_current_line = null
	_within_bounds = false
