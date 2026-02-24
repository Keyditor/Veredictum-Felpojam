extends CharacterBody3D
@onready var cam = $Head/Camera3D
@onready var render2d = $CanvasLayer/CanvasLayer
@onready var head = $Head
@onready var useRange = $Head/Camera3D/RayCast3D
@onready var actionText = $CanvasLayer/RichTextLabel
@onready var debug = $CanvasLayer/Debug
@onready var fade_anim = $CanvasLayer/AnimationPlayer
@onready var fade_rect = $CanvasLayer/ColorRect
var lastActionText = ""

var overlays := {}  # dicionário para guardar instâncias

@export var bob_freq = 2.0  # Frequência bobbing(velocidade do balanço)
@export var bob_amp = 0.08  # Amplitude bobbing(força/altura do balanço)
var t_bob = 0.0             # Acumulador de tempo contínuo

const SPEED = 5.0
const RUN = 1.6
const JUMP_VELOCITY = 4.5
var look_dir: Vector2
var camSense = 0.002

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#set_process_unhandled_input(true)
	fade_anim.play("fade_out")
	Dialogic.signal_event.connect(_on_dialogic_signal)
	self.visible = true
	if !GAME.on_2d:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	actionText.visible_ratio = 0

func _physics_process(delta: float) -> void:
	debug.text = Dialogic.VAR.clockTime
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if overlays.has("work_table") and GAME.dayStart == false:
		Dialogic.start("expedintEnd")
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not GAME.on_2d:
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("pause") and not GAME.on_2d:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("pause") and not GAME.on_2d:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("down") and GAME.on_2d and not GAME.on_dialog:
		for i in overlays:
			print(i)
			close_overlay(i)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		GAME.on_2d = false
	
	var target = useRange.get_collider()
	if target and !GAME.on_2d:
		if target.has_method("use"):
			var result = target.use(false)
			actionText.text = result[3]
			lastActionText = actionText.text
			var i = 0
			while i < str(actionText).length():
				actionText.visible_ratio += 0.001
				i += 1
		else :
			var i = 0
			while i < str(lastActionText).length():
				if actionText.visible_ratio > 0 :
					actionText.visible_ratio -= 0.001 
				i += 1
			actionText.text = ""
	
	if !target and lastActionText != "":
		var i = 0
		while i < str(lastActionText).length():
			if actionText.visible_ratio > 0 :
				actionText.visible_ratio -= 0.001 
			i += 1
		actionText.text = ""
	
	if Input.is_action_just_pressed("action") and not GAME.on_2d: #Tecla de Uso
		actionText.text = ""
		if target:
			print(target.name)
		if target and target.has_method("use"):
			print("has use")
			var resultA = target.use(true)
			var overlay_id = resultA[0]
			var cena_2d:PackedScene = resultA[1]
			var action_type = resultA[2]
			print("Action: ",action_type)
			if action_type == "cena":
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				open_overlay(overlay_id,cena_2d)
			if action_type == "dialogo":
				Dialogic.start("clock3dStart")
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				#open_overlay(overlay_id,cena_2d,action_type)
			if action_type == "trazicao":
				pass
		else: 
			print("no use")
			
		
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and not GAME.on_2d:
		if Input.is_action_pressed("run"):
			var rSPEED = SPEED * RUN
			velocity.x = direction.x * rSPEED
			velocity.z = direction.z * rSPEED
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	
	# Define se a câmera deve balançar (andando) ou voltar ao centro (parado)
	var target_cam_pos = Vector3.ZERO
	if is_on_floor() and velocity.length() > 0.1:
		target_cam_pos = _headbob(t_bob)
	else:
		# Reseta o tempo para que o próximo passo comece do zero
		t_bob = 0.0 
	cam.transform.origin = cam.transform.origin.lerp(target_cam_pos, delta * 10.0)

func open_overlay(id:String,packed_scene: PackedScene,action_type = "cena"): #Instancia e torna a cena 2d visível
	if not overlays.has(id):
		#if id == "work_table":
			
		var instancia = packed_scene.instantiate()
		overlays[id] = instancia
		render2d.add_child(overlays[id])
	else: overlays[id].show()
	render2d.visible = true # Torna o SubViewportContainer visível
	GAME.on_2d = true

func close_overlay(id: String): #Torna a cena 2d invisivel
	print("entrou fechar cena")
	if overlays.has(id):
		print("encontrou cena")
		overlays[id].hide()
		GAME.on_2d = false
		render2d.visible = false # Torna o SubViewportContainer invisível
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else: print("Sinal nao era cena!")
	if id == "clock" :Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_dialogic_signal(arg):
	if arg == "mouseGet":
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		GAME.on_2d = false
		GAME.on_dialog = false
	if arg == "fadeIN":
		#fade_rect.visible = true
		fade_anim.play("fade_in")
		await fade_anim.animation_finished
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#fade_rect.visible = false
	elif arg == "fadeOUT":
		#fade_rect.visible = true
		fade_anim.play("fade_out")
		await fade_anim.animation_finished
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#fade_rect.visible = false
	if arg == "expedientEnd":
		close_overlay("work_table")
	else:
		print("overs : ",str(overlays))
		close_overlay(arg)
		print("overs : ",str(overlays))
		pass

func _unhandled_input(event):
	#print("PORRA")
	# Verifica se a entrada é um movimento do mouse
	if event is InputEventMouseMotion and not GAME.on_2d:
		#print("PQP")
		# Rotação horizontal: rotaciona o corpo inteiro no eixo Y
		rotate_y(-event.relative.x * camSense)
		
		# Rotação vertical: rotaciona apenas a cabeça no eixo X
		head.rotate_x(-event.relative.y * camSense)
		
		# Limita a visão para cima/baixo para o jogador não virar contorsionista (entre -89 e 89 graus)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	# Balanço vertical usando Seno
	pos.y = sin(time * bob_freq) * bob_amp
	# Balanço horizontal usando Cosseno (dividido por 2 para dar o formato de "infinito" ou "8")
	pos.x = cos(time * bob_freq / 2.0) * bob_amp 
	return pos
