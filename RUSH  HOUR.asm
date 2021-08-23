; multi-segment executable file template.

data segment
    ; add your data here!    
    Array db ?,?,?,?,?,?  
          db ?,?,?,?,?,?
          db ?,?,?,?,?,?
          db ?,?,?,?,?,?
          db ?,?,?,?,?,?
          db ?,?,?,?,?,? 
    arr   db ?,?,?,?,?,?,?,?,?,?,?,?,?      
    tav1  db 10,10,10,13,'Input level <1-3>: $'   
    
    pkey db "press any key...$"    
                                           
    StartPage   db 13,13,10,9,"RRRRRRR               h         HH   HH                        ",10,13          
                db 9,         "RR    RR              h         HH   HH                        ",10,13
                db 9,         "RR    RR              h         HH   HH                        ",10,13 
                db 9,         "RRRRRRR  u   u   sss  h hh      HHHHHHH  ooo   u   u  r rrr    ",10,13
                db 9,         "RR RR    u   u  s     hh  h     HHHHHHH o   o  u   u  rr       ",10,13 
                db 9,         "RR  RR   u   u  ssss  h   h     HH   HH o   o  u   u  r        ",10,13
                db 9,         "RR   RR  u   u     s  h   h     HH   HH o   o  u   u  r        ",10,13
                db 9,         "RR    RR  uuu   sss   h   h     HH   HH  ooo    uuu   r       $" 
         
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax 
    
    mov al, 12h
	mov ah, 0h
	int 10h     ; set graphics video mode.   
	  
    mov ax, 1   ; show mouse pointer 
    int 33h 
    
    lea dx, Startpage
    mov ah, 9
    int 21h        ; Output Rush Hour StartPage
   
    
    push OFFSET Array
    push OFFSET tav1
    call Levels
    
    push OFFSET Array
    push OFFSET arr 
    call PrintTable 
    
    mov cx, 1
    
 agturn:   
    push OFFSET Array  
    call ChangeArray
    
    push OFFSET Array
    push OFFSET arr 
    call PrintTable
    
    ;read pixel 
    mov al, 12;===
    inc cx
    cmp al, 12;color red
    jne agturn
    
    dec cx
    ;print 
    
            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 7
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends     



Levels PROC 
    
    mov bp, sp
    
    push ax
    push bx
    push cx
    push dx
    
    mov cx, 35
    mov bx, [bp+4]
    mov BYTE PTR[bx], 0 ;index 0     
    
    a:
    mov bx, [bp+4]
    add bx, cx 
    mov BYTE PTR[bx], 0
    loop a 
    
    mov dx, [bp+2]
    mov ah, 9
    int 21h
    
il: mov ah, 7   
    int 21h
    
    cmp al, 31h
    jl  il
    cmp al, 33h
    jg  il
    
    mov dl, al
    mov ah, 2
    int 21h   
       
    mov bx, [bp+4]
    
    cmp al, 31h
    je l1
    cmp al, 32h
    je l2
    cmp al, 33h
    je l3    
    
    
l1:      
    mov BYTE PTR[bx+13], 12
    mov BYTE PTR[bx+14], 12
    ;mov BYTE PTR[bx+15], 3
    ;mov BYTE PTR[bx+21], 3
    ;mov BYTE PTR[bx+27], 3
    mov BYTE PTR[bx+19], 10
    mov BYTE PTR[bx+20], 10
    mov BYTE PTR[bx+23], 2
    mov BYTE PTR[bx+29], 2
    mov BYTE PTR[bx+35], 2
    ;mov BYTE PTR[bx+25], 13
    ;mov BYTE PTR[bx+31], 13
    ;mov BYTE PTR[bx+32], 11
    ;mov BYTE PTR[bx+33], 11
     
    jmp fpl  
    
    
l2: 
    
    jmp fpl   
    
    
l3: 
    
    
fpl:pop dx
    pop cx
    pop bx
    pop ax
    
    ret 4
Levels ENDP     



PrintTable PROC 
    
    mov bp, sp
    
    push ax
    push bx
    push cx
    push dx
    
    mov al, 12h
	mov ah, 0h
	int 10h     ; set graphics video mode.   
	  
    mov ax, 1    ;show mouse pointer
    int 33h                
                  
    mov al, 1111b
    mov ah, 0ch 
    
    xor si, si  ;cmp
    mov dx, 50
    
    xor di, di
    
p2: mov cx, 50
p1: int 10h
    inc cx
    cmp cx, 230
    jle p1
    
    add dx, 30
    inc di
    cmp di, 6
    jle p2 
    
    
    mov cx, 50
    
    xor di, di
p3: mov dx, 50
p4: int 10h
    inc dx
    cmp dx, 230
    jle p4
    
    add cx, 30
    inc di
    cmp di, 6
    jle p3   
    
    
    mov cx, 13
    mov bx, [bp+2]
aa: mov BYTE PTR[bx], 0
    inc bx
    loop aa 
    
    xor ax, ax
    mov bx, [bp+4] 
    
SearchAgain:
    cmp BYTE PTR[bx], 0
    je FinSearch
    
    mov di, [bp+2]
    mov al, BYTE PTR[bx]
    add di, ax
    cmp BYTE PTR[di], 1
    je FinSearch
    
    mov BYTE PTR[di], 1
    xor ax, ax
    mov al, BYTE PTR[bx];\?
    push ax             ;/
    
    mov ax, bx
    mov cx, 6
    div cl
    push ax
    mov al, ah
    xor ah, ah
    mov cx, 30
    mul cx
    add ax, 50
    pop dx
    push ax;X
    
    mov ax, dx
    xor ah, ah
    mul cx;30
    add ax, 50
    push ax;Y
    
    mov cl, BYTE PTR[bx]
    mov ch, BYTE PTR[bx+6]
    cmp cl, ch 
    je vertical
    mov ax, '1'
    push ax;Mode
    jmp print
vertical:
    mov ax, '2'
    push ax;Mode
    
print:    
    cmp BYTE PTR[bx], 4
    jl prtr;Print truck
    mov si, bp
    call PrintCar
    mov bp, si
    jmp FinSearch
prtr:       
    mov si, bp
    call PrintTruck
    mov bp, si             
     
FinSearch:
    inc bx
    cmp bx, 34
    jle SearchAgain     
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret 4
PrintTable ENDP



PrintCar PROC                            
     
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push si   
    
    add [bp+4],4  
    add [bp+6],3
    
    cmp [bp+2], '2'
    je  CA2
         
	xor di, di  ;mone X   
	xor si, si  ;mone Y           
	
    mov cx, [bp+6]
    mov dx, [bp+4]    
car:   
	    mov al, [bp+8]									
	    mov ah, 0ch
	    int 10h 
	    inc cx
	    inc di            ; set pixel.				; main Car to the right
        cmp di,53
        jne car
        mov cx, [bp+6]    
        xor di, di
        inc dx
        inc si 
        cmp si,24
        jne car 
		  
 	xor di, di  ;mone X   
	xor si, si  ;mone Y 
	xor bh,bh  	          
    mov cx, [bp+6]
    add cx, 5     
    mov dx, [bp+4]
    sub dx, 2   
backOneC:   
	    mov al, 1111b	    
	    mov ah, 0ch
	    int 10h
	    inc cx            ; set pixel.
		inc di
        cmp di,5       
        jne backOnec
        mov cx,[bp+6]
        add cx, 5
		xor di, di								  ; Backwheels by the Car to the right
        inc dx 
		inc si
        cmp si,2
        jne backOneC  
        inc bh
        mov cx, [bp+6]
        add cx, 5            
        mov dx, [bp+4]
        add dx, 24
        xor si, si  
        cmp bh,2      ;number of wheels    
        jne backOneC   
		
	xor di, di  ;mone X   
	xor si, si  ;mone Y    
	xor bh, bh    
    mov cx, [bp+6]
    add cx, 45
    mov dx, [bp+4]
    sub dx, 2  
forOneC:   
	    mov al, 1111b	    
	    mov ah, 0ch
	    int 10h
	    inc cx            ; set pixel. 
		inc di
        cmp di,5
        jne forOneC
        mov cx,[bp+6]
        add cx, 45
		xor di, di        
        inc dx 
		inc si
        cmp si,2									; forwheels by the Car to the right
        jne forOnec
        inc bh
		mov dx,[bp+4]
		add dx, 24
        mov cx, [bp+6]
        add cx, 45
        xor si, si
        cmp bh, 2     ;number of wheels        
        jne forOneC
        
        jmp finpC
    
    
CA2: 
    xor di, di  ;mone X   
	xor si, si  ;mone Y       
                                                       
    mov cx, [bp+6]
    mov dx, [bp+4]    
car2:   
	    mov al, [bp+8]	    
	    mov ah, 0ch
	    int 10h
	    inc cx
	    inc di            ; set pixel. 
        cmp di,24										
        jne car2									; main Car to the down
        mov cx,[bp+6]
        xor di, di
        inc dx
        inc si 
        cmp si,55
        jne car2
           
    xor di, di  ;mone X   
	xor si, si  ;mone Y
	xor bh, bh 
	mov cx, [bp+6]
	sub cx, 2 
	mov dx, [bp+4]
	add dx, 5 
 
backOneC2:   
	    mov al, 1111b	    
	    mov ah, 0ch
	    int 10h
	    inc dx
	    inc di            ; set pixel. 
        cmp di, 5
        jne backOneC2
        mov dx, [bp+4]
	    add dx, 5 
        inc cx											; Backwheels by the Car to the down
        xor di, di
        inc si
        cmp si,2
        jne backOneC2
        inc bh
	    mov cx, [bp+6]
        add cx, 24
        mov dx, [bp+4]
	    add dx, 5         
        xor si, si 
        cmp bh,2      ;number of wheels    
        jne backOneC2      
                   
    xor di, di  ;mone X   
	xor si, si  ;mone Y    
	xor bh, bh
    mov cx, [bp+6]
    sub cx, 2
    mov dx, [bp+4]
    add dx, 45 	    
   
forOneC2:   
	    mov al, 1111b	    
	    mov ah, 0ch
	    int 10h
	    inc dx            ; set pixel.
	    inc di 
        cmp di, 5
        jne forOneC2
        mov dx, [bp+4]
        add dx, 45 
        xor di, di
        inc cx
        inc si 
        cmp si, 2										; forwheels by the Car to the down
        jne forOneC2
        inc bh
        mov cx, [bp+6]
        add cx, 24
        mov dx, [bp+4]
        add dx, 45 
        xor si, si
        cmp bh,2      ;number of wheels  
        jne forOneC2 
        
        
finpC:  pop si
        pop dx
        pop cx
        pop bx
        pop ax
          
        ret 8
PrintCar ENDP  



PrintTruck PROC                            
     
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push si      
    
    add [bp+4],3  
    add [bp+6],4
    
    cmp [bp+2], '2'
    je  Truck2
         
	xor di, di  ;mone X   
	xor si, si  ;mone Y           
	
    mov cx, [bp+6]
    mov dx, [bp+4]    
trail:   
	    mov al, [bp+8]									
	    mov ah, 0ch
	    int 10h 
	    inc cx
	    inc di            ; set pixel.				; main Trail to the right
        cmp di,70
        jne trail
        mov cx, [bp+6]    
        xor di, di
        inc dx
        inc si 
        cmp si,24
        jne trail 

	
	xor di, di  ;mone X   
	xor si, si  ;mone Y           
	
    mov cx, [bp+6]
    add cx, 70
    mov dx, [bp+4] 
    add dx, 2	   
cabin:   
	    mov al, [bp+8]									
	    mov ah, 0ch
	    int 10h 
	    inc cx
	    inc di            ; set pixel.				; main Cabin to the right
        cmp di,15
        jne cabin
        mov cx, [bp+6]
		add cx, 70    
        xor di, di
        inc dx
        inc si 
        cmp si,20
        jne cabin 
		  
 	xor di, di  ;mone X   
	xor si, si  ;mone Y 
	xor bh,bh  	;number of one set of wheels         
    mov cx, [bp+6]
    add cx, 5     
    mov dx, [bp+4]
    sub dx, 2   
backOneT:   
	    mov al, 1111b	    
	    mov ah, 0ch
	    int 10h
	    inc cx            ; set pixel.
		inc di
        cmp di,5       
        jne backOneT
        mov cx,[bp+6]
        add cx, 5
		xor di, di								  ; Backwheels by the Car to the right
        inc dx 
		inc si
        cmp si,2
        jne backOneT  
        inc bh
        mov cx, [bp+6]
        add cx, 5            
        mov dx, [bp+4]
        add dx, 24
        xor si, si  
        cmp bh,2      ;number of wheels    
        jne backOneT   
		
	xor di, di  ;mone X   
	xor si, si  ;mone Y    
	xor bh, bh    
    mov cx, [bp+6]
    add cx, 75
    mov dx, [bp+4]  
forOneT:   
	    mov al, 1111b	    
	    mov ah, 0ch
	    int 10h
	    inc cx            ; set pixel. 
		inc di
        cmp di,5
        jne forOneT
        mov cx,[bp+6]
        add cx, 75
		xor di, di        
        inc dx 
		inc si
        cmp si,2									; forwheels by the Car to the right
        jne forOneT
        inc bh
		mov dx,[bp+4]
		add dx, 22
        mov cx, [bp+6]
        add cx, 75
        xor si, si
        cmp bh, 2     ;number of wheels        
        jne forOneT
        
        jmp finpT
    
    
Truck2: 
    xor di, di  ;mone X   
	xor si, si  ;mone Y       
                                                       
    mov cx, [bp+6]
    mov dx, [bp+4]    
trail2:   
	    mov al, [bp+8]	    
	    mov ah, 0ch
	    int 10h
	    inc cx
	    inc di            ; set pixel. 
        cmp di,24										
        jne trail2									; main Trail to the down
        mov cx,[bp+6]
        xor di, di
        inc dx
        inc si 
        cmp si,70
        jne trail2
		    
	xor di, di  ;mone X   
	xor si, si  ;mone Y       
                                                       
    mov cx, [bp+6]
	add cx, 2
    mov dx, [bp+4]
	add dx, 70    
cabin2:   
	    mov al, [bp+8]	    
	    mov ah, 0ch
	    int 10h
	    inc cx
	    inc di            ; set pixel. 
        cmp di,20										
        jne cabin2									; main Cabin to the down
        mov cx,[bp+6]
        add cx, 2
        xor di, di
        inc dx
        inc si 
        cmp si,15
        jne cabin2
           
   
    xor di, di  ;mone X   
	xor si, si  ;mone Y
	xor bh, bh 
	mov cx, [bp+6]
	sub cx, 2 
	mov dx, [bp+4]
	add dx, 5 
 
backOneT2:   
	    mov al, 1111b	    
	    mov ah, 0ch
	    int 10h
	    inc dx
	    inc di            ; set pixel. 
        cmp di, 5
        jne backOneT2
        mov dx, [bp+4]
	    add dx, 5 
        inc cx											; Backwheels by the Car to the down
        xor di, di
        inc si
        cmp si,2
        jne backOneT2
        inc bh
	    mov cx, [bp+6]
        add cx, 24
        mov dx, [bp+4]
	    add dx, 5         
        xor si, si 
        cmp bh,2      ;number of wheels    
        jne backOneT2      
                   
    xor di, di  ;mone X   
	xor si, si  ;mone Y    
	xor bh, bh
    mov cx, [bp+6]
    mov dx, [bp+4]
    add dx, 75 	    
   
forOneT2:   
	    mov al, 1111b	    
	    mov ah, 0ch
	    int 10h
	    inc dx            ; set pixel.
	    inc di 
        cmp di, 5
        jne forOneT2
        mov dx, [bp+4]
        add dx, 75 
        xor di, di
        inc cx
        inc si 
        cmp si, 2										; forwheels by the Car to the down
        jne forOneT2
        inc bh
        mov cx, [bp+6]
        add cx, 22
        mov dx, [bp+4]
        add dx, 75 
        xor si, si
        cmp bh,2      ;number of wheels  
        jne forOneT2 
        
        
finpT:  pop si
        pop dx
        pop cx
        pop bx
        pop ax 
         
        ret 8
PrintTruck ENDP   



ChangeArray PROC 
    
    mov bp, sp
    
    push ax
    push bx
    push cx
    push dx
    
    ;Print 1
    
ilin1:

    mov cx, 0
    push cx
    call Click
    
    mov bx, [bp+2]
    add bx, di;di=index, bx=index in array
     
    mov al, BYTE PTR[bx]
    xor ah, ah
    push ax;===line 837
     
    cmp BYTE PTR [bx], 0
    je ilin1
    
    push bx ;=======save index of first click
    
    xor al, al;mone
    xor si, si;mode
    
    mov cl, BYTE PTR[bx]
    mov bx, [bp+2]
    
ag: cmp BYTE PTR [bx], cl
    jne nl        
    
    mov BYTE PTR [bx], 0
    cmp BYTE PTR [bx+1], cl
    jne no    
    mov si, 1
    jmp nl
          
no: cmp BYTE PTR [bx+6], cl
    jne nl
    mov si, 2
    
nl: inc bx
    inc al
    cmp al, 35
    jle ag
    
         
    ;Print 2
    
    
ilin2:
    ;push bx
    
    pop cx
    push cx
    call Click
    push cx;========color
    
    add di, [bp+2]
    
    cmp BYTE PTR[di],0
    jne ilin2
    
    pop bx;=======? return index of first click
    
    sub di, [bp+2]
    sub bx, [bp+2]
    
    cmp si, 2
    je M2
    
    mov ax, bx
    mov cl, 6
    div cl
    mov dl, al
    mov ax, di
    div cl
    mov dh, al 
    
    cmp dh, dl
    jne ilin2
    
    add bx, [bp+2]
    add di, [bp+2]
    
    mov ax, bx;to save index
    inc bx
    
c1: cmp BYTE PTR[bx], 0
    je e01
    mov bx, ax
    jmp ilin2
    
e01:cmp bx, di
    jg big
    inc bx
    jmp f
big:dec bx
    
    f:cmp bx, di
    jne c1
    
    
    mov bx, ax
    pop dx;color (or xor ah, ah. mov al, BYTE PTR[bx])
    
    cmp dx, 12;red car
    je next1
    
    sub di, [bp+2]
    mov ax, di
    mov cl, 6
    div cl
    
    cmp dx, 4
    jl tr
    
    cmp ah, 5
    jne next1
    
    dec di
    jmp next1
    
tr: cmp ah, 5
    jne e4
    dec di
    jmp next1
e4: cmp ah, 4
    jne next1
    sub di, 2  
    
next1:
    add di, [bp+2]
    cmp dx, 4
    jl el4
    
    cmp BYTE PTR[di+1], 0
    je next11
    dec di
    jmp next11         
    
el4:cmp BYTE PTR[di+1], 0
    je ch2
    sub di, 2
    jmp next11
    
ch2:cmp BYTE PTR[di+2], 0
    je next11
    dec di
    
next11:
    cmp dx, 12;red car
    jne nor
    cmp di, 17
    jne nor
    
    mov BYTE PTR[di], dl
    jmp finca
    
nor:cmp dx, 4
    jl e41    
    mov BYTE PTR[di], dl
    mov BYTE PTR[di+1], dl
    jmp finca
    
e41:mov BYTE PTR[di], dl
    mov BYTE PTR[di+1], dl
    mov BYTE PTR[di+2], dl
    jmp finca         
    
    
M2: 
    mov ax, bx
    mov cl, 6
    div cl
    mov dl, ah
    mov ax, di
    div cl
    mov dh, ah 
    
    cmp dh, dl
    jne ilin2
    
    add bx, [bp+2]
    add di, [bp+2]
    
    mov ax, bx;to save index
    inc bx
    
c2: cmp BYTE PTR[bx], 0
    je e02
    mov bx, ax
    jmp ilin2
        
e02:cmp bx, di
    je f2
    
    cmp bx, di
    jg big2
    add di, 6
    jmp c2
big2:
    sub di, 6
    jmp c2
    
 
 f2:mov bx, ax
    pop dx;color (or xor ah, ah. mov al, BYTE PTR[bx])    
    
    sub di, [bp+2]
    
    cmp dx, 4
    jl tr2
    
    cmp di, 30
    jl next2 
    
    sub di, 6
    jmp next1
    
tr2:cmp di, 30
    jne e42   
    
    sub di, 12
    jmp next1 
    
e42:cmp di, 24
    jl next2
    
    sub di, 6  
    
next2:
    add di, [bp+2]
    cmp dx, 4
    jl el42
    
    cmp BYTE PTR[di+6], 0
    je next22
    sub di, 6
    jmp next22         
    
el42:
    cmp BYTE PTR[di+6], 0
    je ch22
    sub di, 12
    jmp next22
    
ch22:
    cmp BYTE PTR[di+12], 0
    je next22
    sub di, 6
    
next22:
    cmp dx, 4
    jl e422   
    mov BYTE PTR[di], dl
    mov BYTE PTR[di+6], dl
    jmp finca
    
e422:
    mov BYTE PTR[di], dl
    mov BYTE PTR[di+6], dl
    mov BYTE PTR[di+12], dl
        
                            
finca:        
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret 2;6
ChangeArray ENDP 



;
Click PROC 
    
    push bp
    mov bp, sp
    
    push ax
    push bx
    push cx
    push dx
    
ilck:
  ;  xor bx, bx;bx=0                
  ;  mov ax, 3 ;\
  ;  int 33h   ; \wait to mouse click
  ;  cmp bx, 0 ; /
  ;  je ilck   ;/
    
  ;  cmp bx, 1;left button
  ;  jne ilck
    
    ;cmp cx, 50
    ;jl ilck
    ;cmp cx, 230
    ;jg ilck
    ;
    ;cmp dx, 50
    ;jl ilck
    ;cmp dx, 230
    ;jg ilck            
    cmp cx, 0
    jne sec
    mov cx, 85
    mov dx,115 
    jmp nos
sec:mov cx,150
    mov dx, 115
 nos:       
    
    cmp [bp+4], 12;
    jne cli1;click 1
    
    cmp cx, 260
    jg ilck
    cmp cx, 230
    jl cli1
    
    sub cx, 30
          
cli1:
    sub cx, 50
    sub dx, 50
    
    mov ax, cx;div X
    mov cl, 30
    div cl
    
    xor ah, ah;al is div    
    push ax
    
    mov ax, dx;div Y
    div cl; cl=30
    
    xor ah, ah;al is div
    
    mov cl, 6
    mul cl;nul Y in al
    
    pop bx
    add bx, ax;div x+div y
    
    mov di, bx;sum index    
    
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    
    ret 2
Click ENDP 


end start ; set entry point and stop the assembler.