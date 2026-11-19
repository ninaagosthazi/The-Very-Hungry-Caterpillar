.text
.globl main

main:
	li s0, 0xFFFF0000	# Load base MMIO address
	
game_loop:
	# Check receiver control register
	lw t0, 0(s0)
	andi t0, t0, 1
	beqz t0, update_game
	
	# Read receiver data register
	lw t1, 4(s0)
	
	# Compare against WASD ASCII codes
	li t2, 119		# 'w'
	beq t1, t2, move_up
	
	li t2, 97		# 'a'
	beq t1, t2, move_left
	
	li t2, 115		# 's'
	beq t1, t2, move_down
	
	li t2, 100		# 'd'
	beq t1, t2, move_right
	
	j update_game		# Ignore other keys
	
move_up:
	# Add W movement logic here
	j update_game
	
move_left:
	# Add A movement logic here
	j update_game
	
move_down:
	# Add S movement logic here
	j update_game
	
move_right:
	# Add D movement logic here
	j update_game
	
update_game:
	# Render graphics, update physics, etc
	j game_loop