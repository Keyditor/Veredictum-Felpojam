extends Node

const Dialogs = {
	Enum.Characters.Player: ["Que dia difícil", "Nossa, tá tudo desorganizado", "Caramba, tudo eu, tudo eu nessa fábrica"],
	Enum.Characters.Boss: ["você é muito importante para essa empresa", "Decida quais correspondências devem ser aprovadas, essa é sua função"]
}

var MailItens = {
	Enum.MailKinds.Package: {
		Enum.ObjectsInScene.Package1: {
			"Receiver": "Cleitinho",
			"Sender": "Roberto",
			"is_stamped": Enum.StampMarks.Neuter
		},
		Enum.ObjectsInScene.Package2: {
			"Receiver": "Robervânia",
			"Sender": "Ronaldo Fenômeno",
			"is_stamped": Enum.StampMarks.Neuter
		},
		Enum.ObjectsInScene.Package3: {
			"Receiver": "Jorginho",
			"Sender": "Flavinho do pneu",
			"is_stamped": Enum.StampMarks.Neuter
		}
	}
}

const StampsMarks = {
	Enum.StampMarks.Good: "res://scenes/objects/stamp_marks/good_stamp_mark.tscn",
	Enum.StampMarks.Bad: "res://scenes/objects/stamp_marks/bad_stamp_mark.tscn"
}

# Tem que ser salvo o objeto Node com a informação
