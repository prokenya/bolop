extends Resource 
class_name Data

@export var abilities_icons:Array[Texture2D]

@export var abilities_paths:Array[String]

func save() -> void:
	ResourceSaver.save(self, "res://src/core/resources/gamedata.tres")

static  func load_or_create() -> Data:
	var res: Data = load("res://src/core/resources/gamedata.tres") as Data
	if !res:
		res = Data.new()
	return res
