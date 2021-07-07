extends Node2D

const BALL_SPEED = 150
const PLAYER_SPEED = 200

var screen_size
var player_size

var ball_position
var ball_direction
var ball_speed = BALL_SPEED

var player_right_goal = 0
var player_left_goal = 0

func _ready():
	print('Hello Pong')
	screen_size = get_viewport_rect().size
	$BallSprite.position = screen_size * 0.5
	ball_position = $BallSprite.position
	ball_direction = Vector2(1,0)
	randomize()
	player_size = $PlayerLeftSprite.get_texture().get_size()
	$HUDNode/PlayerLeftGoalLabel.text = '0'
	$HUDNode/PlayerRightGoalLabel.text = '0'

func _process(delta):
	# Ball recebe valores ou atualizasos 
	ball_position += ball_direction * ball_speed * delta
	
	if ball_position.x < 0:
		player_right_goal = player_right_goal + 1
		$HUDNode/PlayerRightGoalLabel.text = str(player_right_goal)
	
	if ball_position.x > screen_size.x:
		player_left_goal = player_left_goal + 1
	$HUDNode/PlayerLeftGoalLabel.text = str(player_left_goal)
		
	# Ball toca em cima e em baixo	
	if (ball_position.y < 0 or ball_position.y > screen_size.y):
		ball_direction.y = -1 * ball_direction.y
	
	#ball toca as laterais esq e dir e reinicia a a partida. (e marca gol)
	if (ball_position.x < 0 or ball_position.x > screen_size.x):
		ball_position = screen_size * 0.5
		ball_direction = Vector2(randf()*2.0-1.0,0).normalized()
		ball_speed = BALL_SPEED
	
	#movimento PlayerRight
	var player_right_position = $PlayerRightSprite.position
	if (Input.is_action_pressed("ui_up") and player_right_position.y >0):
		player_right_position.y = player_right_position.y - PLAYER_SPEED * delta
	if (Input.is_action_pressed("ui_down")and player_right_position.y < screen_size.y):
		player_right_position.y = player_right_position.y + PLAYER_SPEED * delta
	$PlayerRightSprite.position = player_right_position
	
	#Movimentar PlayerLeft
	var player_left_position = $PlayerLeftSprite.position
	if (Input.is_action_pressed("ui_key_w") and player_left_position.y > 0):
		player_left_position.y = player_left_position.y - PLAYER_SPEED * delta
	if (Input.is_action_pressed("ui_key_s") and player_left_position.y < screen_size.y):
		player_left_position.y = player_left_position.y + PLAYER_SPEED * delta
	$PlayerLeftSprite.position = player_left_position
	
	# cria rect2 envolta dos players para o controle de bordas 
	var player_left_rect2 = Rect2($PlayerLeftSprite.position-player_size/2,player_size)
	var player_right_rect2 = Rect2($PlayerRightSprite.position-player_size/2,player_size)
	
	# bola bate no player da esquerda 
	if(player_left_rect2.has_point(ball_position)):
		ball_direction.x = ball_direction.x * -1
		ball_direction.y = randf()*2.0-1.0
		ball_direction = ball_direction.normalized()
		ball_speed = ball_speed * 1.10
		
	# bola bate no player da direita
	if(player_right_rect2.has_point(ball_position)):
		ball_direction.x = ball_direction.x * -1
		ball_direction.y = randf()*2.0-1.0
		ball_direction = ball_direction.normalized()
		ball_speed = ball_speed * 1.10
		
	#ball recebe valores atualizados
	$BallSprite.position = ball_position
	

