extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Could change this to affect difficulty?
var cell_size=50

# Find and mark the start/end cells
func find_cell(maze, type):
    var cell = Utils.get_random_outer_cell(maze)
    # Match parameters for location of start or end cell criteria
    if type == "start":
        while cell.column > 2 or (cell.column > 0 and cell.row != (maze.number_rows - 1)):
            cell = Utils.get_random_outer_cell(maze)
    elif type == "end":
        while cell.column < (maze.number_columns - 3) or (cell.column < (maze.number_columns-1) and cell.row != 0):
            cell = Utils.get_random_outer_cell(maze)
    else:
        push_error("find_cell: Unsupported type '%s'" % type)
    print("%s cell %d,%d" % [type,cell.row,cell.column])

    # Now find the outside wall of this cell
    var outer_wall
    if cell.column == 0:
        outer_wall = cell.walls.W
    elif cell.column == (maze.number_columns - 1):
        outer_wall = cell.walls.E
    elif cell.row == (maze.number_rows - 1):
        outer_wall = cell.walls.N
    elif cell.row == 0: 
        outer_wall = cell.walls.S

    print("Outer wall of %s is " % type, outer_wall)
    if type == "start":
        outer_wall.mark_start()
        maze.start_cell = cell
    else:
        outer_wall.mark_end()
        maze.end_cell = cell
    
func gen_maze(frame):
    var x1 = frame.rect_position.x
    var y1 = frame.rect_position.y
    var x2 = x1 + frame.rect_size.x
    var y2 = y1 + frame.rect_size.y

    $MazeGenerator.number_of_rows = frame.rect_size.y / cell_size
    $MazeGenerator.number_of_columns = frame.rect_size.x / cell_size

    print("Generating a %dx%d maze" % [$MazeGenerator.number_of_rows,$MazeGenerator.number_of_columns])
    var maze = $MazeGenerator.generate_maze()
    # Figure these out later

    var offset = 0.0
    var cell
    for row in maze.number_rows:
        for column in maze.number_columns:
            cell = maze.cell_at(row, column)
            
            var row2 = maze.number_rows - row - 1
            var top_left = Vector2(column * cell_size + offset, row2 * cell_size)
            var top_right = Vector2((column + 1) * cell_size + offset, row2 * cell_size)
            var bottom_left = Vector2(column * cell_size + offset, (row2 + 1) * cell_size + offset)
            var bottom_right = Vector2((column + 1) * cell_size + offset,(row2 + 1) * cell_size + offset)
            
            if cell.walls.E or column == (maze.number_columns - 1):
#                print("Cell (%d,%d): East wall from %s to %s; cell_size %f" % [row,column,String(top_right),String(bottom_right),cell_size])
                cell.walls.E = gen_wall(top_right, bottom_right, cell_size)
                frame.add_child(cell.walls.E)
                
            if cell.walls.W or column == 0:
#                print("Cell (%d,%d): West wall from %s to %s; cell_size %f" % [row,column,String(top_left),String(bottom_left),cell_size])
                cell.walls.W = gen_wall(top_left, bottom_left, cell_size)
                frame.add_child(cell.walls.W)
                
            if cell.walls.N or row == (maze.number_rows - 1):
#                print("Cell (%d,%d): North wall from %s to %s; cell_size %f" % [row,column,String(top_left),String(top_right),cell_size])
                cell.walls.N = gen_wall(top_left, top_right, cell_size)
                frame.add_child(cell.walls.N)
                
            if cell.walls.S or row == 0:
#                print("Cell (%d,%d): South wall from %s to %s; cell_size %f" % [row,column,String(bottom_left),String(bottom_right),cell_size])
                cell.walls.S = gen_wall(bottom_left,  bottom_right, cell_size)
                frame.add_child(cell.walls.S)

    # Get a start cell
    find_cell(maze, "start")

    # Get a exit cell
    find_cell(maze, "end")

    return maze

func gen_wall(start:Vector2,end:Vector2,cell_size:float) -> Line2D:
    var wall = $WallBody.duplicate()
    wall.set_position(start)
    # Move the wall, then set the line points relative to that
    var l = wall.get_node("Line2D")
    l.clear_points()
    l.add_point(Vector2.ZERO)
    l.add_point(end - start)

#    print("gen_wall: pos is ", wall.get_position())
    return wall
    
# Called when the node enters the scene tree for the first time.
func _ready():
    # call code to generate the maze
    var maze = gen_maze($OuterFrame)
    # Move the sprite to the start cell
    var start = maze.start_cell
    if start.column != 0:
        push_error("Oops, don't know how to place sprite on top/bottom")
    var player = $KinematicBody2D
#    player.position = Vector2(start.walls.W.position.x,start.walls.W.position.y)
    print("start.walls.W position is ", start.walls.W.position)
    print("Player position is ", player.position)
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
