extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var line
var collision_node
var collision_shape
var special = null

# Called when the node enters the scene tree for the first time.
func _ready():
    line = get_node("Line2D")
    collision_node = get_node("CollisionShape2D")
    # The CollisionShape2D is duplicated, but the shape property is common
    collision_node.shape = RectangleShape2D.new()
    collision_shape = collision_node.shape

# Positon and size based on our line, which was configured elsewhere
func _draw():
    # Skip the base unused WallBody
    if line.points.empty():
        return

    # line is always related to us, so start is always 0,0
    var end = line.points[1]
    collision_node.position = end / 2
    if end.x == 0:
        end.x = line.width
    else: # y == 0
        end.y = line.width
    collision_shape.extents = end / 2
    
func color(new_color=null):
    if not new_color:
        return line.default_color
    line.default_color = new_color

func mark_start():
    # TODO:  Set our collision shape to react to a collision
    self.special = "start"
    self.color(Color(0.9,0.6,0,1))

func mark_end():
    # TODO:  Set our collision shape to react to a collision
    self.special = "end"
    self.color(Color(0.2,0.8,0,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
