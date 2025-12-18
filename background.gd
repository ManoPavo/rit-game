extends Control

@export var cor_fundo = Color(0.8, 0.6, 1.0) 
@export var cor_grade = Color(0.9, 0.7, 1.0, 0.3)
@export var cor_ondas = Color(1, 1, 1, 0.5)  
@export var cor_estrelas = Color(1, 0.9, 1, 0.7)
var tempo := 0.0
var num_wave = [100, 70, 40, 90, 80]
var wave_death = [1, 2, 3]
var num_barras := 100  # Número de barras da onda
var largura_barra := 8  # Largura de cada barra da onda
var amplitude_maxima := 120  # Amplitude máxima da onda
var altura_y := 3
var rng = RandomNumberGenerator.new()  #Gerador de números aleatórios
var decida := 3
var altura_target := altura_y  # Definindo o alvo para a altura da onda
var smooth_time := 5.0  # Tempo de suavização

func _ready():
	set_process(true)
	randomize()

func _process(delta):
	tempo += delta * 3.0
	queue_redraw()
	
	
	if Input.is_action_just_pressed("Esquerda") or Input.is_action_just_pressed("Direita") or Input.is_action_just_pressed("Baixo") or Input.is_action_just_pressed("Cima"): 
		
		altura_target = num_wave[rng.randi_range(0, num_wave.size() - 1)]
		await get_tree().create_timer(0.1).timeout
		altura_target = 3
		
	
	
	
	altura_y = lerp(altura_y, altura_target, smooth_time * delta)

func _draw():
	var viewport_size = get_viewport_rect().size

	# Fundo
	draw_rect(Rect2(Vector2.ZERO, viewport_size), cor_fundo)

	# Estrelas (pixels fixos)
	rng.seed = 42
	for i in range(80):
		var pos = Vector2(rng.randf_range(0, viewport_size.x), rng.randf_range(0, viewport_size.y * 0.7))
		draw_rect(Rect2(pos, Vector2(2, 2)), cor_estrelas)

	# Grade no chão
	var grid_spacing = 40
	var grid_y_start = viewport_size.y * 0.7
	for x in range(0, int(viewport_size.x), grid_spacing):
		draw_line(Vector2(x, grid_y_start), Vector2(x - viewport_size.x * 0.5, viewport_size.y), cor_grade, 1)
	for y in range(0, 6):
		var line_y = grid_y_start + y * 40
		draw_line(Vector2(0, line_y), Vector2(viewport_size.x, line_y), cor_grade, 1)

	
	var center_y = grid_y_start - 100
	var center_index = float(num_barras) / 2.0
	
	for i in range(num_barras):
		
		var x = (viewport_size.x / 2.0) - (float(num_barras) * float(largura_barra) / 2.0) + float(i) * float(largura_barra)
		var dist = abs(float(i) - center_index) / center_index
		
		var modificador_distancia
		if i<=50:
			modificador_distancia = (i%50)+25
		else:
			modificador_distancia = 51-(i%50)+25
		#var curva = 2.0 - dist
		var altura = sin(i * 0.1 + tempo) * decida + altura_y + modificador_distancia #* curva
		altura += rng.randf_range(-10, 10)
		
		
		draw_rect(Rect2(Vector2(x, center_y - altura / 2), Vector2(largura_barra - 2, altura)), cor_ondas)
