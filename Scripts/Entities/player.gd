class_name Player extends CharacterBody2D

var direction
var speed : int = 100
var current_state : State = State.IDLE
var previous_state : State

@onready var anim_tree : AnimationTree = $PlayerAnimTree

enum State {IDLE, MOVING, ATTACKING}

func _init() -> void:
	pass

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		previous_state = current_state
		switch_state(State.ATTACKING)
		
	direction = Input.get_vector("left", "right", "up", "down")
	
	if current_state == State.ATTACKING:
		return
	if direction == Vector2.ZERO:
		switch_state(State.IDLE)
	else:
		switch_state(State.MOVING)
	
func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
	switch_animations(current_state)

func switch_animations(state : State):
	match state:
		State.IDLE:
			anim_tree.get("parameters/playback").travel("Idle")
		State.MOVING:
			anim_tree.get("parameters/playback").travel("Moving")
			anim_tree.set("parameters/Attacking/BlendSpace2D/blend_position", direction)
			anim_tree.set("parameters/Idle/BlendSpace2D/blend_position", direction)
			anim_tree.set("parameters/Moving/BlendSpace2D/blend_position", direction)
		State.ATTACKING:
				anim_tree.get("parameters/playback").travel("Attacking")
				

func switch_state(new_state : State):
	match new_state:
		State.IDLE:
			current_state = State.IDLE
		State.MOVING:
			current_state = State.MOVING
		State.ATTACKING: 
			current_state = State.ATTACKING
		_:
			current_state = State.IDLE

func _on_player_anim_tree_animation_finished(anim_name: StringName) -> void:
	switch_state(previous_state)
	if previous_state == State.ATTACKING:
		switch_state(State.IDLE)
	


func _on_health_death() -> void:
	queue_free()
