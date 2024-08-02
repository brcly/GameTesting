class_name enemy extends CharacterBody2D

var speed := 100

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_health_death() -> void:
	queue_free()


func _on_health_damaged(amount: float, knockback: Vector2) -> void:
	velocity = knockback
