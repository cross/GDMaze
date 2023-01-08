extends KinematicBody2D

export (int) var speed = 100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
var sprite
var direction_limit = null

# Called when the node enters the scene tree for the first time.
func _ready():
    sprite = get_node("Sprite")
    set_physics_process(true)

func get_input():
    velocity = Vector2()
    # There should be a better way to code this....
    if Input.is_action_pressed("right") and (direction_limit == null or direction_limit == "right"):
        velocity.x += 1
        sprite.flip_h = true
    if Input.is_action_pressed("left") and (direction_limit == null or direction_limit == "left"):
        velocity.x -= 1
        sprite.flip_h = false
    if Input.is_action_pressed("down") and (direction_limit == null or direction_limit == "down"):
        velocity.y += 1
    if Input.is_action_pressed("up") and (direction_limit == null or direction_limit == "up"):
        velocity.y -= 1
    velocity = velocity.normalized() * speed

func _physics_process(delta):
    get_input()
    velocity = move_and_slide(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
