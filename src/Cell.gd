class_name Cell
"""
Representation of a maze cell.
"""

var row: int
var column: int
var walls = {}

var is_visited: bool

func _init(_row: int, _column: int, have_walls: bool):
    self.row = _row
    self.column = _column
    self.walls = { "N": have_walls, "W": have_walls, "S": have_walls, "E": have_walls } 
    self.is_visited = false
