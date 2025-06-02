extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bean_col_f():
	set("modulate", Color("#ff0000"))


func _on_bean_col_t():
	set("modulate", Color("#00c226"))
