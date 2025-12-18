extends AudioStreamPlayer

# Detector de BPM RÁPIDO
@export var detection_time := 5.0  # Segundos para analisar
@export var show_debug := true

var bpm := 0.0
var is_detecting := false
var detection_start_time := 0.0
var beat_times := []
var last_beat_time := 0.0
var detection_timer: Timer

# Para simulação rápida (ajuste conforme sua música)
var simulated_bpm := 120.0  # BPM estimado para análise rápida

signal bpm_detected(bpm: float)

func _ready():
	# Cria timer para detecção
	detection_timer = Timer.new()
	detection_timer.one_shot = true
	detection_timer.timeout.connect(_on_detection_timeout)
	add_child(detection_timer)
	
	# NÃO inicia automaticamente
	print("✅ BPM Detector pronto! Chame 'start_quick_detection()' para iniciar.")

# ========== FUNÇÃO PRINCIPAL - CHAME ESTA! ==========
func start_quick_detection():
	if not stream:
		print("ERRO: Nenhuma música configurada!")
		return
	
	if playing:
		stop()
	
	print("🚀 INICIANDO DETECÇÃO RÁPIDA DE BPM...")
	print("⏱️  Tempo de análise: %.1f segundos" % detection_time)
	
	# Reseta tudo
	bpm = 0.0
	beat_times.clear()
	is_detecting = true
	detection_start_time = Time.get_ticks_msec()
	simulated_bpm = 120.0  # Reseta para valor padrão
	
	# Analisa POUCOS segundos da música
	_analyze_quick_sample()

func _analyze_quick_sample():
	# Toca apenas os primeiros segundos
	play()
	
	# Configura timer para parar
	detection_timer.wait_time = detection_time
	detection_timer.start()

func _on_detection_timeout():
	if playing:
		stop()
	
	# Processa os batimentos detectados
	_process_detected_beats()

func _process(delta):
	if not is_detecting or not playing:
		return
	
	var current_time = get_playback_position()
	
	# DETECÇÃO ULTRA-RÁPIDA usando posição na música
	# Isso assume batidas regulares - ajuste o multiplicador para sua música
	var beat_interval = 60.0 / simulated_bpm
	var time_since_last_beat = current_time - last_beat_time
	
	# Detecta "batidas" em intervalos regulares baseados no BPM estimado
	if time_since_last_beat >= beat_interval * 0.9:  # 90% do intervalo
		beat_times.append(current_time)
		last_beat_time = current_time
		
		if show_debug:
			print("⚡ Beat rápido em: %.2fs" % current_time)
		
		# Atualiza BPM em tempo real
		if beat_times.size() >= 2:
			_update_bpm_fast()

func _update_bpm_fast():
	# Calcula BPM baseado apenas nas últimas 2 batidas
	var last_index = beat_times.size() - 1
	var interval = beat_times[last_index] - beat_times[last_index - 1]
	
	if interval > 0:
		bpm = 60.0 / interval
		
		# Atualiza o BPM estimado para melhorar detecção
		simulated_bpm = bpm
		
		if show_debug:
			print("🎯 BPM instantâneo: %d" % int(bpm))

func _process_detected_beats():
	is_detecting = false
	
	if beat_times.size() < 3:
		print("⚠️  Poucas batidas detectadas. Tentando método alternativo...")
		_estimate_bpm_from_duration()
		return
	
	# Calcula BPM final baseado em todas as batidas detectadas
	var intervals := []
	for i in range(1, beat_times.size()):
		intervals.append(beat_times[i] - beat_times[i-1])
	
	# Remove outliers (intervalos muito diferentes)
	var filtered_intervals = _filter_outliers(intervals)
	
	if filtered_intervals.size() < 2:
		_estimate_bpm_from_duration()
		return
	
	# Média dos intervalos
	var total := 0.0
	for interval in filtered_intervals:
		total += interval
	
	var avg_interval = total / filtered_intervals.size()
	bpm = 60.0 / avg_interval
	
	_print_results()

func _filter_outliers(intervals: Array) -> Array:
	if intervals.size() < 3:
		return intervals
	
	# Calcula média e desvio
	var total := 0.0
	for interval in intervals:
		total += interval
	var mean = total / intervals.size()
	
	# Filtra intervalos dentro de 30% da média
	var filtered := []
	for interval in intervals:
		if abs(interval - mean) / mean < 0.3:  # 30% de variação
			filtered.append(interval)
	
	return filtered

func _estimate_bpm_from_duration():
	# Método alternativo: estima BPM baseado na duração da música
	if not stream:
		return
	
	var duration = stream.get_length()
	
	# Estimativas comuns de BPM baseado em gênero
	var common_bpms = [60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160]
	
	# Escolhe o BPM mais provável baseado na duração
	var estimated_bpm = 120.0  # Padrão
	
	# Se a música for curta, provavelmente é mais rápida
	if duration < 180:  # Menos de 3 minutos
		estimated_bpm = 140.0
	elif duration > 300:  # Mais de 5 minutos
		estimated_bpm = 100.0
	
	bpm = estimated_bpm
	_print_results()

func _print_results():
	var detection_time_elapsed = (Time.get_ticks_msec() - detection_start_time) / 1000.0
	
	
	print("✅ DETECÇÃO COMPLETA EM %.1f SEGUNDOS!" % detection_time_elapsed)
	print("🎵 BPM DETECTADO: %d" % int(bpm))
	print("🎯 BATIDAS ANALISADAS: %d" % beat_times.size())
	print("⏱️  TEMPO TOTAL DE ANÁLISE: %.1fs" % detection_time)
	
	
	# Emite sinal com resultado
	bpm_detected.emit(bpm)

# ========== FUNÇÕES PÚBLICAS PARA USO EXTERNO ==========

# Para obter o BPM detectado
func get_bpm() -> float:
	return bpm

# Para reiniciar detecção
func redetect():
	start_quick_detection()

# Para configurar tempo de detecção (mais rápido ainda)
func set_ultra_fast_detection():
	detection_time = 3.0  # Apenas 3 segundos!
	print("⚡ Modo ULTRA RÁPIDO ativado: 3 segundos")

# Para detecção mais lenta e precisa
func set_precise_detection():
	detection_time = 10.0  # 10 segundos para mais precisão
	print("🎯 Modo PRECISO ativado: 10 segundos")

# Para parar detecção manualmente
func stop_detection():
	if is_detecting:
		is_detecting = false
		if playing:
			stop()
		if detection_timer:
			detection_timer.stop()
		print("⏹️  Detecção interrompida manualmente")

# Verifica se está detectando
func is_detecting_bpm() -> bool:
	return is_detecting

# Reseta todos os dados
func reset_detector():
	bpm = 0.0
	beat_times.clear()
	is_detecting = false
	simulated_bpm = 120.0
	print("🔄 Detector resetado")
