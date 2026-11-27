.data
food_x: .word 5 	#store food's X position
food_y: .word 3 	#store food's y position

score: .word 0  	#score starts @ 0 

level: .word 1  	#game starts at level 1
grow_pending: .word 0	#signal for caterpillar to grow

GRID_WIDTH: .word 20	#temp  width
GRID_HEIGHT:.word 15	#temp  height


.text 
.global main
main: 
	li a0, 5 #caterpillar head X=5
	li a1, 3 #caterpillar head y=3
	li a2, 5 #food x=5 
	li a3, 3 #food y=3
	
	jal ra, check_food_collision    #call collision
	
	mv t0,a0 			#save returned result in t0
	
	li a7,1 			#select print integer system call
	mv a0,t0			#move result into a0 for printing
	ecall				#print result 
	
	li a7,10			#exit
	ecall
	
#checks caterpillar head touches food
check_food_collision:
	bne a0,a2,no_collision      	  #if head x != x, jump to no_collision 
	bne a1,a3,no_collision     	  #if heay y !=y, jump to no_collision
	
	li a0,1                     	  #both match , return 1 
	ret                         	  #return to function call
	
no_collision:
	li a0, 0                   	  #return 0 (no collision) 
	ret                       	  #return
	
update_score:
	la t0, score 			  # load address of score
	lw t1, 0(t0) 			  # load current score
	addi t1,t1,1 			  #increase score by 1
	sw t1,0(t0)			  #save updated score 
	
	li a0, 0 
	ret
	
check_progression:
	la t0,score 			  #get address of score 
	lw t1, 0(t0)			  #load current score 
	
	la t3, level 			  #get address of level
	lw t4,0(t3) 			  #load current level
	
	li t2,5 			  #each level requires 5 pts
	mul t2,t4,t2 			  #find next level limit
	
	blt t1,t2,progression_done        #if score less 5, skip 
	
    	addi t4, t4, 1           	  # Increase level
    	sw t4, 0(t3)             	  # Save new level
    	
progression_done:
	ret 				  # return to caller
	
	
place_new_food:
    	li a7, 42              # Select random integer 

    	li a0, 0               # Random number generator ID
    	li a1, 20              # Upper bound for X (temporary)
    	ecall                  # Generate random X
    	mv t0, a0              # Save random X

    	li a7, 42              # Select random integer  again
    	li a0, 0               # Random number generator ID
    	li a1, 15              # Upper bound for Y (temporary)
    	ecall                  # Generate random Y
    	mv t1, a0              # Save random Y

    	la t2, food_x          # Get address of food X
    	sw t0, 0(t2)           # Store new X coordinate

    	la t2, food_y          # Get address of food Y
    	sw t1, 0(t2)           # Store new Y coordinate

    	ret                    

handle_food_eaten:
	addi sp, sp, -4 	   # make room on the stack
	sw ra, 0(sp) 		   # save return address  

    	jal ra, update_score       # Increase score
    	jal ra, check_progression  # Check for level changes
    	jal ra, place_new_food     # Generate another food item
    	
    	la t0, grow_pending 	   # get address of growth signal
    	li t1, 1		   # set growth signal to 1
    	sw t1, 0(t0)		   # tell movement code to grow
    	
    	lw ra, 0(sp) 		   # restore return address
    	addi sp, sp, 4 		   # restore stack 
    	ret    	
	
	
