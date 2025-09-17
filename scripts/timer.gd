extends Panel

@onready var minutes_label: Label = $Minute
@onready var seconds_label: Label = $Seconds
@onready var msec_label: Label = $Miliseconds


var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(5.0).timeout
	
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	minutes_label.text = "%02d:" % minutes
	seconds_label.text = "%02d." % seconds
	msec_label.text = "%03d" % msec
	
func stop() -> void:
	set_process(false)
	
func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
