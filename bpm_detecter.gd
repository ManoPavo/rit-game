extends Node2D

@onready var audio_player = $AudioStreamPlayer
@onready var file_dialog = $FileDialog

func _ready():
	# Configura o FileDialog
	file_dialog.filters = ["*.mp3 ; Arquivos MP3"]
	file_dialog.file_selected.connect(_on_file_selected)
	
	# Cria um botão
	
	$Button.pressed.connect(_on_select_button_pressed)
	

func _on_select_button_pressed():
	file_dialog.popup_centered()

func _on_file_selected(path):
	print("Carregando: " + path)
	
	# Método 1: Usando ResourceLoader (recomendado)
	var audio_stream = ResourceLoader.load(path)
	
	# Método 2: Alternativa direta
	# var audio_stream_mp3 = AudioStreamMP3.new()
	# audio_stream_mp3.data = FileAccess.get_file_as_bytes(path)
	
	if audio_stream is AudioStream:
		audio_player.stream = audio_stream
		audio_player.start_quick_detection()
		
