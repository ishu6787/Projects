[ORG 0x100]
jmp start
             length: dw 8
             head_of_snake: dw 0
			 row: dw 0
			 col: dw 0
			 w: db 'PRESS w: UPWARD MOVEMENT',0
			 s: db 'PRESS s: DOWNWARD MOVEMENT',0
			 a: db 'PRESS a: LEFT MOVEMENT',0
			 d: db 'PRESS d: RIGHT MOVEMENT',0
			 msg1: db 'WELCOME TO THE SNAKE GAME                                             ',0
			 scr: db "SCORE: ",0
			 msg2: db "SNAKE GAME",0
			 over: db "GAME OVER",0
			 score: dw 0
			 student1: db '21F-9180',0
			 student2: db '21F-9629',0
			 food_possition: dw 0
             cute_snake: db 'oooooooo'


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;clearing screen;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clrscr:                                         
    push ax
    push di
    push es

    mov ax,0xb800
    mov es,ax
    mov di,0

  nextloc:
      mov word[es:di],0x0720
      add di,2
      cmp di,4000
     jne nextloc
  
   pop es
   pop di
   pop ax
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;calculating length;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

strlen:
       push bp
       mov bp,sp
       push es
       push cx
       push di

       les di,[bp+4]
       mov cx,0xffff
       xor al,al

       repne scasb
       mov ax,0xffff
       sub ax,cx
       sub ax,1

       pop di
       pop cx
       pop es
       pop bp
	ret 4

   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;print string;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printstr:
      push bp
      mov bp,sp
      push es
      push ax
      push cx
      push si
      push di

      push ds
      mov ax,[bp+4]
      push ax
      call strlen

      cmp ax,0
      jz exitch
      mov cx,ax

      mov ax,0xb800
      mov es,ax
      mov ax,80
      mul byte[bp+8]
      add ax,[bp+10]
      shl ax,1
      mov di,ax
      mov si,[bp+4]
      mov ah,[bp+6]

      cld
    nextchar:
           lodsb
           stosw
           loop nextchar

    exitch:  
          pop di
          pop si
          pop cx
          pop ax
          pop es
          pop bp
   ret 8


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;score printing;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

score_num:
       push bp 
       mov bp,sp
       push ax
       push bx
       push cx
       push dx
       push es
       push di
          
          mov ax,[score]
          mov bx,10
          mov cx,0
          loop1:
              mov dx,0
              div bx
              add dl,0x30
              push dx
              inc cx
              cmp ax,0
              jnz loop1
         
         mov ax,0xb800
         mov es,ax
         mov ax,80
         mul byte[bp+6]
         add ax,[bp+4]
         shl ax,1
         mov di,ax

         nextnum:
              pop dx
              mov dh,0x0f
              mov [es:di],dx
              add di,2
              loop nextnum
        
        pop di
        pop es
        pop dx
        pop cx
        pop bx
        pop dx
        pop bp

     ret 4


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;printing snake;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
snake_print:
    push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	mov si,[bp+6]   ;snake
	mov cx,[bp+8]   ;length_of_snake
	sub cx,2
	 mov ax,80
	 mov dx,9
	mul dx
	 add ax,22
	 shl ax,1
	 mov di,ax         ;location in di
	mov ax,0xb800
	mov es,ax
	mov bx,[bp+4]
	mov ah,0x0f

snake_next_char:
    mov al,[si]
	mov [es:di],ax
	mov [bx],di    ;changing location
	inc si
	add bx,2
	add di,2
	dec cx
	jnz snake_next_char
	
pop es
pop di
pop si
pop dx
pop cx
pop bx
pop ax 
pop bp
ret 6


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;boarder;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

boarder:
         push ax
         push bx
         push cx
         push dx
         push es
         push di

              mov ax,0xb800
              mov es,ax
              mov di,320
              mov ax,0x0f23

              left:
                 mov word[es:di],ax
                 add di,160
                 cmp di,4000
                 jb left

             mov di,478
             right:
                 mov word[es:di],ax
                 add di,160
                 cmp di,4000
                 jb right

            mov al,0x3d
            mov di,3840
            down:
                  mov word[es:di],ax
                  add di,2
                  cmp di,4000
                  jb down

            mov di,320
            up:
                 mov word[es:di],ax
                 add di,2
                 cmp di,480
                 jb up
 
           mov di,0
		   mov ax,0xb800
		   mov es,ax
		   mov ax,0x0720
		   next_space:
		       mov [es:di],ax
			   add di,2
			   cmp di,318
			   jnz next_space

           mov ax,33
           push ax
           mov ax,2
           push ax
           mov ax,0x0A
           push ax
           mov ax,msg2
           push ax
           call printstr
           
           mov ax,1
           push ax
           mov ax,1
           push ax
           mov ax,0x09
           push ax
           mov ax,scr
           push ax
           call printstr


           mov ax,1
           push ax
           mov ax,8
           push ax
           call score_num

        pop di
        pop es
        pop dx
        pop cx
        pop bx
        pop ax
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end at snake bite;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end_game:
    call clrscr
	
	mov ax,34
    push ax
    mov ax,11
    push ax
    mov ax,0x0f
    push ax
    mov ax,over
    push ax
    call printstr

    mov ax,34
    push ax
    mov ax,12
    push ax
    mov ax,0x0f
    push ax
    mov ax,scr
    push ax
    call printstr

    mov ax,12
    push ax
    mov ax,42
    push ax
    call score_num

 mov ax,0x4c00
 int 0x21


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;snake upward movement;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

upward_movement:
      push bp
	  mov bp,sp
	  push ax
	  push bx
	  push cx
	  push dx
	  push es
	  push si
	  push di
	  
	      mov bx,[bp+4]  
	      mov dx,[bx]
	      mov cx,[bp+8]  
	      sub dx,160   
		  
	 up_hit:
	        cmp dx,[bx]
	        jne exit_up1
			call end_game
          exit_up1:
	        add bx,2
			dec cx
	        jnz up_hit

	 up_move:
	        mov si,[bp+6]      
	        mov bx,[bp+4]      
	        mov dx,[bx]
	        sub dx,160
	        mov di,dx
	 
	    mov ax,0xb800
	    mov es,ax

	    mov ah,0x0f
	    mov al,[si]
	    mov [es:di],ax
	    mov cx,[bp+8]
	    mov di,[bx]
	    inc si
		
	    mov ah,0x0f
	    mov al,[si]
	    mov [es:di],ax
	 
	 up_printing:
	      mov ax,[bx]
	      mov [bx],dx
	      mov dx,ax
	      add bx,2
		  dec cx
	      jnz up_printing

	      mov di,dx
	      mov ax,0x0720
	      mov [es:di],ax

	   push di
	   	   sub di,160
		   cmp word[es:di],0x4f01
		   je a1
		   mov [es:di],ax

          a1:
		   sub di,160
		   cmp word[es:di],0x4f01
		   je b1
		   mov [es:di],ax

         b1:
      pop di
	  push di
		   add di,160
		   cmp word[es:di],0x4f01
		   je c1
		   mov [es:di],ax

		   c1:
		   add di,160
		   cmp word[es:di],0x4f01
		   je d1
		   mov [es:di],ax

		   d1:
     pop di
	 push di
		   add di,2
		   cmp word[es:di],0x4f01
		   je e1
		   mov [es:di],ax

		   e1:
		   add di,2
		   cmp word[es:di],0x4f01
		   je f1
		   mov [es:di],ax

		   f1:
    pop di
	push di
		   sub di,2
		   cmp word[es:di],0x4f01
		   je g1
		   mov [es:di],ax

		   g1:
		   sub di,2
		   cmp word[es:di],0x4f01
		   je h1
		   mov [es:di],ax

		   h1:
    pop di
		   call boarder
		  jmp up_exit

up_exit:
    pop di
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;snake downward movement;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

downward_movement:
      push bp
	  mov bp,sp
	  push ax
	  push bx
	  push cx
	  push dx
	  push es
	  push si
	  push di
	  
	     mov bx,[bp+4] 
	     mov dx,[bx]
	     mov cx,[bp+8]  
	     add dx,160    
	down_hit:
	        cmp dx,[bx]
	        jne exit_down1
			call end_game
          exit_down1:
	        add bx,2
			dec cx
            jnz down_hit

	down_mov:
	        mov si,[bp+6]      
	        mov bx,[bp+4]     
	        mov dx,[bx]
	        add dx,160
	        mov di,dx
	 
	        mov ax,0xb800
	        mov es,ax
	        mov ah,0x0f

	        mov al,[si]
	        mov [es:di],ax
	        mov cx,[bp+8]
	        mov di,[bx]
	        inc si 
			
	        mov ah,0x0f
	        mov al,[si]
	        mov [es:di],ax
	 
	 down_printing:
	        mov ax,[bx]
	        mov [bx],dx
	        mov dx,ax
	        add bx,2
			dec cx
	        jnz down_printing

	   mov di,dx
	   mov ax,0x0720
	   mov [es:di],ax
	   push di
	   	   sub di,160
		   cmp word[es:di],0x4f01
		   je a2
		   mov [es:di],ax

          a2:
		   sub di,160
		   cmp word[es:di],0x4f01
		   je b2
		   mov [es:di],ax

         b2:
      pop di
	  push di
		   add di,160
		   cmp word[es:di],0x4f01
		   je c2
		   mov [es:di],ax

		   c2:
		   add di,160
		   cmp word[es:di],0x4f01
		   je d2
		   mov [es:di],ax

		   d2:
     pop di
	 push di
		   add di,2
		   cmp word[es:di],0x4f01
		   je e2
		   mov [es:di],ax

		   e2:
		   add di,2
		   cmp word[es:di],0x4f01
		   je f2
		   mov [es:di],ax

		   f2:
    pop di
	push di
		   sub di,2
		   cmp word[es:di],0x4f01
		   je g2
		   mov [es:di],ax

		   g2:
		   sub di,2
		   cmp word[es:di],0x4f01
		   je h2
		   mov [es:di],ax

		   h2:
    pop di
		   call boarder
	   jmp down_exit

down_exit:
    pop di
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
	 
	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;snake leftward movement;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

leftward_movement:
      push bp
	  mov bp,sp
	  push ax
	  push bx
	  push cx
	  push dx
	  push es
	  push si
	  push di
	  
	     mov bx,[bp+4]  
	     mov dx,[bx]
	     mov cx,[bp+8]  
	     sub dx,2    
	left_hit:
	      cmp dx,[bx]
	      jne exit_left1
		  call end_game
       exit_left1:
	      add bx,2
	      dec cx
	      jnz left_hit

	left_mov:
	      mov si,[bp+6]      
	      mov bx,[bp+4]       
	      mov dx,[bx]
	      sub dx,2
	      mov di,dx
	 
	    mov ax,0xb800
	    mov es,ax
	    mov ah,0x0f
	    mov al,[si]
	    mov [es:di],ax
	    mov cx,[bp+8]
	    mov di,[bx]
	    inc si
		
	    mov ah,0x0f
	    mov al,[si]
	    mov [es:di],ax
	 
	left_printing:
	        mov ax,[bx]
	        mov [bx],dx
	        mov dx,ax
	        add bx,2
	        dec cx
	        jnz left_printing

	    mov di,dx
	    mov ax,0x0720
	    mov [es:di],ax
	   push di
	   	   sub di,160
		   cmp word[es:di],0x4f01
		   je a3
		   mov [es:di],ax

          a3:
		   sub di,160
		   cmp word[es:di],0x4f01
		   je b3
		   mov [es:di],ax

         b3:
      pop di
	  push di
		   add di,160
		   cmp word[es:di],0x4f01
		   je c3
		   mov [es:di],ax

		   c3:
		   add di,160
		   cmp word[es:di],0x4f01
		   je d3
		   mov [es:di],ax

		   d3:
     pop di
	 push di
		   add di,2
		   cmp word[es:di],0x4f01
		   je e3
		   mov [es:di],ax

		   e3:
		   add di,2
		   cmp word[es:di],0x4f01
		   je f3
		   mov [es:di],ax

		   f3:
    pop di
	push di
		   sub di,2
		   cmp word[es:di],0x4f01
		   je g3
		   mov [es:di],ax

		   g3:
		   sub di,2
		   cmp word[es:di],0x4f01
		   je h3
		   mov [es:di],ax

		   h3:
    pop di
		   call boarder
		jmp left_exit
 left_exit:
    pop di
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;rightward movement;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


rightward_movement:
      push bp
	  mov bp,sp
	  push ax
	  push bx
	  push cx
	  push dx
	  push es
	  push si
	  push di
	  
	         mov bx,[bp+4] 
	         mov dx,[bx]
	         mov cx,[bp+8]  
	         add dx,2    
	   right_hit:
	           cmp dx,[bx]
	           jne exit_right1
			   call end_game
		exit_right1:
	           add bx,2
	           dec cx
	           jnz right_hit
			   
	   right_mov:
	           mov si,[bp+6]      
	           mov bx,[bp+4]       
	           mov dx,[bx]
	           add dx,2
	           mov di,dx
	 
	           mov ax,0xb800
	           mov es,ax
	           mov ah,0x0f
	           mov al,[si]
	           mov [es:di],ax
	           mov cx,[bp+8]
	           mov di,[bx]
	           inc si
			   
	           mov ah,0x0f
	           mov al,[si]
	           mov [es:di],ax
	 
	 right_printing:
	       mov ax,[bx]
	       mov [bx],dx
	       mov dx,ax
	       add bx,2
	       dec cx
	       jnz right_printing

	       mov di,dx
	       mov ax,0x0720
	       mov [es:di],ax
	   push di
	   	   sub di,160
		   cmp word[es:di],0x4f01
		   je a4
		   mov [es:di],ax

          a4:
		   sub di,160
		   cmp word[es:di],0x4f01
		   je b4
		   mov [es:di],ax

         b4:
      pop di
	  push di
		   add di,160
		   cmp word[es:di],0x4f01
		   je c4
		   mov [es:di],ax

		   c4:
		   add di,160
		   cmp word[es:di],0x4f01
		   je d4
		   mov [es:di],ax

		   d4:
     pop di
	 push di
		   add di,2
		   cmp word[es:di],0x4f01
		   je e4
		   mov [es:di],ax

		   e4:
		   add di,2
		   cmp word[es:di],0x4f01
		   je f4
		   mov [es:di],ax

		   f4:
    pop di
	push di
		   sub di,2
		   cmp word[es:di],0x4f01
		   je g4
		   mov [es:di],ax

		   g4:
		   sub di,2
		   cmp word[es:di],0x4f01
		   je h4
		   mov [es:di],ax

		   h4:
    pop di
		   call boarder
		   jmp right_exit
right_exit:
    pop di
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6  	
	  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;cpp;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;void Input()
;{
;	if (_kbhit())                                        
;	{
;		switch (_getch())
;		{
;		case'->':
;			direction = LEFT;
;			break;
;		case'<-':
;			direction = RIGHT;
;			break;
;		case'|':
;            V
;			direction = DOWN;
;			break;
;		case'^':
;            |
;			direction = UP;
;			break;
;		case'x':
;			gameover = true;
;			break;
;		}
;	}
;}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;keyboard;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


keyboard:
    push ax
	push bx
	push cx
	push dx
	
       kb_hit:

         mov ah,0
	     int 0x16

	        cmp ah,0x11
	        je up_ko_move

	        cmp ah,0x1e
	        je left_ko_move

	        cmp ah,0x20
	        je right_ko_move

	        cmp ah,0x1f
	        je down_ko_move

	        cmp ah,1
	        jne kb_hit

	      mov ax,0x4c00
	      je exit

    up_ko_move:
		   push word[length]
		   mov bx,cute_snake
		   push bx
		   mov bx,head_of_snake
		   push bx
		   call upward_movement
		   jmp checking

	down_ko_move:
		   push word[length]
		   mov bx,cute_snake
		   push bx
		   mov bx,head_of_snake
		   push bx
		   call downward_movement
		   jmp checking

	left_ko_move:
		 push word[length]
		 mov bx,cute_snake
	     push bx
		 mov bx,head_of_snake
		 push bx
		 call leftward_movement
		 jmp checking

	right_ko_move:
		 push word[length]
		 mov bx,cute_snake
		 push bx
		 mov bx,head_of_snake
		 push bx
		 call rightward_movement
		 jmp checking

    checking:
		 call check_dead_element
	     push word[food_possition]
		 push word[length]
		 mov ax,cute_snake
		 push ax
		 mov ax,head_of_snake
		 push ax

		 call check_food
		 jmp kb_hit
	    

  exit:
	pop bx
	pop ax
	ret
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;deadline;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_dead_element:
       push ax
	   push bx
	   push cx
	   push dx
	   push di
	   push si
	   push es



    right1:
       mov dx,158
       right_collision:
          add dx,160
          cmp dx,4000
          jae left1
           cmp [head_of_snake],dx
           je finish
           ja right_collision

   left1:
      mov dx,0      
      left_collision:
          add dx,160
          cmp dx,4000
          jae down1
          cmp [head_of_snake],dx
          je finish
          ja left_collision

   up1:     
     mov dx,320
     up_collision:
          add dx,2
          cmp dx,480
          jae down1
          cmp [head_of_snake],dx
          je finish
          ja up_collision

	down1:
     mov dx,3840
     down_collision:
          add dx,2
          cmp dx,4000
          jae end
          cmp [head_of_snake],dx
          je finish
          jb down_collision

finish:
    call clrscr
    mov ax,34
    push ax
    mov ax,11
    push ax
    mov ax,0x0f
    push ax
    mov ax,over
    push ax
    call printstr

    mov ax,34
    push ax
    mov ax,12
    push ax
    mov ax,0x0f
    push ax
    mov ax,scr
    push ax
    call printstr

    mov ax,12
    push ax
    mov ax,42
    push ax
    call score_num

	   pop es
	   pop si
	   pop di
	   pop dx
	   pop cx
	   pop bx
	   pop ax

  mov ax,0x4c00
  int 0x21

end:
	   pop es
	   pop si
	   pop di
	   pop dx
	   pop cx
	   pop bx
	   pop ax
ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;random number generation;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

random:
     push ax
     push bx
     push cx
     push dx
	 push si
	 push di
	 push es



    inloop:
        mov ah,00h                   ;random number
        int 1ah

        mov ax,dx
        mov dx,0                     ;or xor dx,dx
        mov cx,25                    ;for row number
        div cx

        mov [row],dx

        mov ah,00h
        int 1ah

        mov ax,dx
        mov dx,0
        mov cx,80                     ;for column number
        div cx

        mov [col],dx

     mov ax,80
     mov bx,[row]
     mul bx
     mov bx,[col]
     add ax,bx
     shl ax,1
   not_at_up:
     mov di,0
	 loop_up:
	    cmp di,ax
		je inloop
		add di,2
		cmp di,480
		jb loop_up

    not_at_down:
	   mov di,3840
	   loop_down:
	       cmp di,ax
		   je inloop
		   add di,2
		   cmp di,4000
		   jb loop_down

    not_at_left:
	    mov di,0
		loop_left:
		    cmp di,ax
			je inloop
			add di,160
			cmp di,4000
			jb loop_left

     not_at_right:
	     mov di,158
		 loop_right:
		    cmp di,ax
			je inloop
			add di,160
			cmp di,4000
			jb loop_right

     cmp ax,4000
   jg inloop

   mov word[food_possition],ax
   cmp word[food_possition],0x0f6f
   je inloop

   pop es
   pop di
   pop si
   pop dx
   pop cx
   pop bx
   pop ax
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;food printing;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


food:                                      ;printing food
      push ax
	  push bx
      push cx
	  push dx
      push di
      push es

           call random                     ;storing random value in row and col
         
         mov ax,80
         mov cx,[row]
         mul cx
         mov cx,[col]
         add ax,cx
         shl ax,1
         mov di,ax

         mov ax,0xb800
         mov es,ax

         mov ax,0x4f01
         mov word[es:di],ax
     pop es
     pop di
	 pop dx
     pop cx
	 pop bx
     pop ax

 ret

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;check food;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


check_food:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si

	mov ax,0xb800
	 mov es,ax
	 mov ax,0x0720
	 mov di,0
	 firstline:
	     mov word[es:di],ax
		 add di,2
		 cmp di,158
		 jne firstline

    mov bx, [bp + 4]
    mov dx, [bp + 10]

    cmp [bx], dx
    jne not_change

    add word [score], 1
		   mov ax,1
           push ax
           mov ax,8
           push ax
           call score_num
    mov cx, [bp + 8]        ;snake length
	dec cx
	shl cx,1
    add bx, cx      
    mov dx, [bx]
    sub dx, [bx - 2]        ;last - second last

    mov ax, [bx]
    add ax, dx          
    mov dx, ax
   
   shr cx,1
   inc cx
    add word[length], 1

    add bx, 2
    mov [bx], dx
    mov si, [bp + 6]
    inc si

    mov ax, 0xb800
    mov es, ax
    mov di, dx
    mov ah, 0x0f
    mov al, [si]

    mov [es:di], ax


    mov ax, 0xb800 
    mov es, ax 

    call food

 not_change:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
ret 8

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;start;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:

   call clrscr

   mov ax,25
   push ax
   mov ax,9
   push ax
   mov ax,0x0f
   push ax
   mov ax,msg1
   push ax
   call printstr

   mov ax,33
   push ax
   mov ax,11
   push ax
   mov ax,0x0c
   push ax
   mov ax,student1
   push ax
   call printstr

   mov ax,33
   push ax
   mov ax,12
   push ax
   mov ax,0x0c
   push ax
   mov ax,student2
   push ax
   call printstr

   mov ah,0x1                           ;when you press any key then next instruction execute
   int 0x21

   call clrscr
   mov ax,25
   push ax
   mov ax,9
   push ax
   mov ax,0x09
   push ax
   mov ax,w
   push ax
   call printstr

   mov ax,25
   push ax
   mov ax,10
   push ax
   mov ax,0x0a
   push ax
   mov ax,s
   push ax
   call printstr

   mov ax,25
   push ax
   mov ax,11
   push ax
   mov ax,0x0c
   push ax
   mov ax,a
   push ax
   call printstr

   mov ax,25
   push ax
   mov ax,12
   push ax
   mov ax,0x07
   push ax
   mov ax,d
   push ax
   call printstr

   mov ah,0x1                           ;when you press any key then next instruction execute
   int 0x21

     call clrscr
	 call boarder

	 push word[length]
	 mov ax,cute_snake
	 push ax
	 mov ax,head_of_snake
	 push ax
	 call snake_print
	 call food
	 call keyboard

mov ax,0x4c00
int 21h


