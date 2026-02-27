extends Node

const StampsMarks = {
	Enum.StampMarks.Good: "res://scenes/objects/stamp_marks/good_stamp_mark.tscn",
	Enum.StampMarks.Bad: "res://scenes/objects/stamp_marks/bad_stamp_mark.tscn"
}

var person_count: int = 0

# Em cada posição desse array ficam as noites, dentro fica as correspondências e cada correspondência aponta para um resource específico. 
const nights = [
	{
		"Mail": [
			"res://resources/Letters/letter_dulce.tres",
			"res://scenes/objects/envelope.tscn"
		],
		"person_detail": "res://assets/work_tools/Detail_Dulce.png"
	},
	{
		"Mail": [
			"res://resources/packages/tenaz.tres", 
			"res://resources/packages/muda_de_roupas.tres",
			"res://resources/Letters/letter_vicente.tres",
			"res://scenes/objects/envelope.tscn",
			"res://scenes/objects/package.tscn"
		],
		"person_detail": "res://assets/work_tools/Detail_Vicente.png"
	},
	{
		"Mail": [
			"res://resources/packages/vinho.tres",
			"res://scenes/objects/package.tscn"
		],
		"person_detail": "res://assets/work_tools/Detail_Antonio.png"
	},
	{
		"Mail": [
			"res://resources/Letters/letter_odete.tres",
			"res://resources/packages/par_de_sapatos.tres",
			"res://scenes/objects/envelope.tscn",
			"res://scenes/objects/package.tscn"
		],
		"person_detail": "res://assets/work_tools/Detail_Odete.png"
	},
	{
		"Mail": [
			"res://resources/packages/martelo.tres",
			"res://resources/packages/caixa_pregos.tres",
			"res://resources/Letters/letter_brasil.tres",
			"res://scenes/objects/envelope.tscn",
			"res://scenes/objects/package.tscn"
		],
		"person_detail": "res://assets/work_tools/Detail_Brasil.png"
	},
	{
		"Mail": [
			"res://resources/packages/formao.tres",
			"res://resources/packages/cavalo_madeira.tres",
			"res://scenes/objects/package.tscn"
		],
		"person_detail": "res://assets/work_tools/Detail_Mario.png"
	},
	{
		"Mail": [
			"res://resources/packages/par_de_gazuas.tres",
			"res://resources/packages/colar_joias.tres",
			"res://resources/Letters/letter_benedito.tres",
			"res://scenes/objects/envelope.tscn",
			"res://scenes/objects/package.tscn"
		],
		"person_detail": "res://assets/work_tools/Detail_Benedito.png"
	},
	{
		"Mail": [
			"res://resources/packages/kit_medico.tres",
			"res://scenes/objects/package.tscn"
		],
		"person_detail": "res://assets/work_tools/Detail_Ignacio.png"
	}
]

var sent_mail = []

var has_spawning_started: bool = false

# Função que spawna as correspondências na esteira
func spawn_mail(night_index: int, spawn_point: Vector2, spawn_gap_time: float):
	var first = true
	has_spawning_started = true
	for mail in nights[night_index]["Mail"]:
		# Para que ele tenha um delay mais curto na primeira iteração
		if first:
			await get_tree().create_timer(1.5).timeout
			create_mail_object(mail, spawn_point, spawn_gap_time)
			first = false
		else:
			# Cria um gap entre o spawn de um item e outro, pra não ficar tudo na mesma posição
			await get_tree().create_timer(spawn_gap_time).timeout
			
			# Criação da caixa e envelope
			var verify_mail = load(mail)
			if verify_mail is not MailItem:
				create_package(mail, spawn_point, nights[night_index]["person_detail"])
			else:
				print(mail)
				# criação em si da correspondência
				create_mail_object(mail, spawn_point, spawn_gap_time)
	person_count += 1

func create_mail_object(resource: String, spawn_point: Vector2, spawn_gap_time: float):
	# lógica para spawnar as correspondências
	
	# feature para reaproveitar objetos já descartados em cena. Otimização!
	var mail_resource = load(resource)
	var mail_scene = load("res://scenes/objects/mail.tscn")
	var new_mail = mail_scene.instantiate()
	new_mail.mail_info = mail_resource
	new_mail.global_position = spawn_point
	get_tree().get_first_node_in_group("work_table").add_child(new_mail)

func create_package(package: String, spawn_point: Vector2, person_detail):
	var person_detail_loaded = load(person_detail)
	var package_scene = load(package)
	var new_package = package_scene.instantiate()
	new_package.global_position = spawn_point
	new_package.person_detail = person_detail_loaded
	get_tree().get_first_node_in_group("work_table").add_child(new_package)

func add_to_in_scene_mail(person_name, stamp_mark):
	sent_mail.append({
		"name": person_name,
		"state": stamp_mark
	})
	print(sent_mail)
func remove_from_in_scene_mail(mail_item):
	sent_mail.erase(mail_item)
