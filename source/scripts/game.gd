extends Node
var on_2d = true
var on_dialog = true
var on_2d_last = false
var on_dialog_last = false
var dayStart = false
var dayTimeLimit = 1200 # Tempo limite do dia ( 1200 = 20:00 )
var dayTimeStart = 480 # Tempo de inicio do dia ( 480 = 08:00 )
var dayTimeSpeed = 12 # Velocidade de incremento do tempo ( 12 minutos no jogo passão em 1 segundo)
var dayTimeTick = dayTimeStart
var lastScene = "Start" 
var gameStart = false
var dayCount = 1
var dayPass = false

func change_scene(path:String):
	get_tree().change_scene_to_file(path)
	
func _process(delta: float) -> void:
	#print("game2d:",on_2d)
	if on_2d != on_2d_last:
		on_2d_last = on_2d
		print("Mudou on_2d = ",on_2d)
	if on_dialog != on_dialog_last:
		on_dialog_last = on_dialog
		print("Mudou on_dialog = ",on_dialog)
	if dayStart and not on_dialog:
		if dayTimeTick < dayTimeLimit:
			if dayTimeTick >= 840:
				Dialogic.VAR.clockState = "late"
			dayTimeTick += dayTimeSpeed * delta
			Dialogic.VAR.clockTime = clockFormat(dayTimeTick)
		else:
			print("Cabou o tempo, Chapa! :/")
			dayStart = false
	

func clockFormat(timeInSeconds: int): #Formata o tempo paara exibir no dialogo do relógio
	var minutes = timeInSeconds / 60
	var seconds = timeInSeconds % 60
	return "%02d:%02d" % [minutes, seconds]
	
