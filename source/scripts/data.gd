extends Node

const StampsMarks = {
	Enum.StampMarks.Good: "res://scenes/objects/stamp_marks/good_stamp_mark.tscn",
	Enum.StampMarks.Bad: "res://scenes/objects/stamp_marks/bad_stamp_mark.tscn"
}

# Em cada posição desse array ficam as noites, dentro fica as correspondências e cada correspondência aponta para um resource específico. 
const nights = [
	{
		"Mail": [
			"res://resources/packages/colar_joias.tres",
			"res://resources/packages/cavalo_madeira.tres",
			"res://resources/packages/caixa_pregos.tres",
			"res://resources/packages/formao.tres",
			"res://resources/Letters/letter_dulce.tres",
			"res://scenes/objects/envelope.tscn",
			"res://scenes/objects/package.tscn"
		],
		"person_info": ""
	},
	{
		"Mail": [
			"res://resources/packages/package1.tres",
			"res://resources/packages/package2.tres",
			"res://resources/packages/package3.tres"
		]
	}
]

var sent_mail = [
	{
		"name": "Dulce Martins",
		"state": Enum.StampMarks.Good
	},
	{
		"name": "Vicente Fonseca",
		"state": Enum.StampMarks.Bad
	},
	{
		"name": "Odete Oliveira",
		"state": Enum.StampMarks.Neuter
	},
	{
		"name": "João Brasil",
		"state": Enum.StampMarks.Invalid
	}
]

# Função que spawna as correspondências na esteira
func spawn_mail(night_index: int, spawn_point: Vector2, spawn_gap_time: float):
	var first = true
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
				create_package(mail, spawn_point)
			else:
				print(mail)
				# criação em si da correspondência
				create_mail_object(mail, spawn_point, spawn_gap_time)
		
func create_mail_object(resource: String, spawn_point: Vector2, spawn_gap_time: float):
	# lógica para spawnar as correspondências
	
	# feature para reaproveitar objetos já descartados em cena. Otimização!
	var mail_resource = load(resource)
	var mail_scene = load("res://scenes/objects/mail.tscn")
	var new_mail = mail_scene.instantiate()
	new_mail.mail_info = mail_resource
	new_mail.global_position = spawn_point
	get_tree().get_first_node_in_group("work_table").add_child(new_mail)

func create_package(package: String, spawn_point: Vector2):
	var package_scene = load(package)
	var new_package = package_scene.instantiate()
	new_package.global_position = spawn_point
	get_tree().get_first_node_in_group("work_table").add_child(new_package)

func add_to_in_scene_mail(mail_item):
	sent_mail.append(mail_item)
func remove_from_in_scene_mail(mail_item):
	sent_mail.erase(mail_item)
