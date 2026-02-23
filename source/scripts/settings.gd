extends VBoxContainer


const path = "user://config.txt"
const MUSIC_VOL = 50
const SOUND_VOL = 50
const FULLSCREEN = false
const RESOLUTIONS = [Vector2i(1280,720),Vector2i(1366,768),Vector2i(1600,900),Vector2i(1920,1080)]

@export var music:Slider
@export var sounds:Slider
@export var fullscreen:CheckBox
@export var resolution:OptionButton

func _ready() -> void:
	apply_settings()
	var conf = load_settings()
	resolution.selected=conf.get_value("settings","resolution",0)
	fullscreen.button_pressed=conf.get_value("settings","fullscreen",FULLSCREEN)
	music.value = conf.get_value("settings","music_volume",MUSIC_VOL)
	sounds.value = conf.get_value("settings","sounds_volume",SOUND_VOL)
	
func apply_settings():
	var conf = load_settings()
	fullscreen_toggled(conf.get_value("settings","fullscreen",FULLSCREEN))
	change_resolution(conf.get_value("settings","resolution",0))
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

func change_resolution(index: int) -> void:
	var conf = load_settings()
	conf.set_value("settings","resolution",index)
	save_settings(conf)
	var res = RESOLUTIONS[index]
	#DisplayServer.window_set_size(res)
	get_window().size=res
	pass # Replace with function body.
