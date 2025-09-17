extends Panel

@onready var minutes_label: Label = $Minute
@onready var seconds_label: Label = $Seconds
@onready var msec_label: Label = $Miliseconds

func _process(delta: float) -> void:
	var time = TimerManager.time
	var msec = int(fmod(time, 1) * 100)
	var seconds = int(fmod(time, 60))
	var minutes = int(fmod(time, 3600) / 60)

	minutes_label.text = "%02d:" % minutes
	seconds_label.text = "%02d." % seconds
	msec_label.text = "%03d" % msec
