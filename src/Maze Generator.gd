extends Node
class_name MazeGenerator
"""
Asset for maze generation, currently implementing 5 algorithms.
You may choose the algorithm to be used, the seed to random function calls and the number of rows and columns
in the inspector or in code and get the maze by invoking 'generate_maze()'.

You can check the description of the algorithms (and which is suited best for your project) in the below links:
    http://people.cs.ksu.edu/~ashley78/wiki.ashleycoleman.me/index.php/Perfect_Maze_Generators.html
    http://weblog.jamisbuck.org/2011/2/7/maze-generation-algorithm-recap
    
Inspired on https://assetstore.unity.com/packages/tools/modeling/maze-generator-38689.
You are welcome to contribute in https://github.com/jvcoutinho/Maze-Generator.
"""


export var number_of_rows : int = 10
export var number_of_columns : int = 10

func generate_maze() -> Maze:
    randomize()
    return RecursiveBacktracker.new().generate_maze(number_of_rows, number_of_columns)


