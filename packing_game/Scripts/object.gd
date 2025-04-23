extends Node2D

@export var draggable = false
var is_inside_dropable = false
var body_ref: StaticBody2D
var offset: Vector2
var initialPos: Vector2
var is_dragging = false

# Initialize position
func _ready() -> void:
	initialPos = global_position  # Store the starting position

# Input function to handle both mouse and touch events
func _input(event: InputEvent) -> void:
	if draggable:
		# Detect touch or mouse press to start dragging
		if event is InputEventScreenTouch and event.pressed and not is_dragging:
			offset = event.position - global_position
			Global.is_dragging = true
			is_dragging = true
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not is_dragging:
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
			is_dragging = true

		# Detect release of touch or mouse to end dragging
		elif is_dragging and ((event is InputEventScreenTouch and not event.pressed) or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed)):
			Global.is_dragging = false
			is_dragging = false
			var tween = create_tween()

			if is_inside_dropable:
				# Move to drop area with easing
				tween.tween_property(self, "position", body_ref.position, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
			else:
				# Snap back to initial position with easing
				tween.tween_property(self, "global_position", initialPos, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

# Processing function to handle dragging behavior
func _process(delta: float) -> void:
	if draggable and is_dragging:
		# Update position while dragging, for both touch and mouse drag
		global_position = get_global_mouse_position() - offset

# Area2D collision signals to detect "dropable" areas
func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body_ref = body as StaticBody2D
		body_ref.modulate = Color("RebeccaPurple")
		
func _on_area_2d_body_exited(body: Node) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		body.modulate = Color("MediumPurple", 0.7)

# Mouse hover functions to enlarge or reset the draggable item
func _on_area_2d_mouse_entered() -> void:
	if not Global.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited() -> void:
	if not Global.is_dragging:
		draggable = false
		scale = Vector2(1, 1)
