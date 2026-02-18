extends VBoxContainer


const path = "user://config.txt"
const MUSIC_VOL = 50
const SOUND_VOL = 50
const FULLSCREEN = false

@export var music:Slider
@export var sounds:Slider
@export var fullscreen:CheckBox
	
func _ready() -> void:
	var conf = load_settings()
	music.value = conf.get_value("settings","music_volume",MUSIC_VOL)
	sounds.value = conf.get_value("settings","sounds_volume",SOUND_VOL)
	fullscreen.button_pressed=conf.get_value("settings","fullscreen",FULLSCREEN)
	
func apply_settings():
	var conf = load_settings()
	fullscreen_toggled(conf.get_value("settings","fullscreen",FULLSCREEN))
	music_volume(conf.get_value("settings","music_volume",MUSIC_VOL))
	sounds_volume(conf.get_value("settings","sounds_volume",SOUND_VOL))

func load_settings()->ConfigFile:
	var conf = ConfigFile.new()
	conf.load(path)
	return conf
	
func save_settings(conf:ConfigFile):
	conf.save(path)
	
func music_volume(val):
	var conf = load_settings()
	conf.set_value("settings","music_volume",val)
	save_settings(conf)
	var index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(index,val)
	
func sounds_volume(val):
	var conf = load_settings()
	conf.set_value("settings","sounds_volume",val)
	save_settings(conf)
	var index = AudioServer.get_bus_index("Sounds")
	AudioServer.set_bus_volume_linear(index,val)
	
func fullscreen_toggled(toggled_on: bool) -> void:
	var conf = load_settings()
	conf.set_value("settings","fullscreen",toggled_on)
	save_settings(conf)
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	pass # Replace with function body.
