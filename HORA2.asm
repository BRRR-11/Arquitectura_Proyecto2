;Daniel Barrientos Barrantes

DATOS SEGMENT
	
	RETC	EQU	13
	ENTR	EQU	10
	
        solicitud1 DB  ENTR , RETC ,'Digite el primer Numero de la hora a evaluar(0,1,2): $'
	solicitud2 DB  ENTR , RETC ,'Digite el segundo Numero de la hora a evaluar(0-9): $'
        FINAL   DB     ENTR , RETC ,'LA HORA SE ENCUENTRA EN LA ZONA HORARIA: $'
        
	msg1 DB   ENTR , RETC ,'ZONA VERDE','$'
	msg2 DB   ENTR , RETC ,'ZONA AMARILLA','$'
	msg3 DB   ENTR , RETC ,'ZONA ROJA','$'
	msg4 DB   ENTR , RETC ,'NINGUNA ZONA','$'
	
	aux1 DB 8
	aux3 DB 8
	aux4 DB 7
	aux2 DB 0
	aux5 DB 1
	aux6 DB 2
;SUMA	
DATOS ENDS

PILA SEGMENT STACK
       ; DB      1024 DUP(0)
PILA ENDS
;SUMA

;///////////////////////////////////////////////////////////////////////////////////////////////////////////

CODIGO SEGMENT
PROYECTO PROC FAR
ASSUME CS:CODIGO,DS:DATOS,SS:PILA,ES:DATOS ;Poner siempre
        PUSH    DS           
        MOV     AX,0
        PUSH    AX
        MOV     AX,DATOS
        MOV     DS,AX
        MOV     AX,DATOS
        MOV     ES,AX
        MOV     AX,PILA
        MOV     SS,AX
        
        LEA     DX,solicitud1     ;Solicita el primer numero de la hora
        CALL    PRINT             ;Imprime el mensaje para solicitar el primer numero de la hora 
        CALL    READ              ;INPUT de una tecla
			
        SUB     AL,48             ;Convierte el numero a Hexadecimal
        MOV     CH,AL		  ;HIGH izquierda
	
		
	LEA     DX,solicitud2     ;;Solicita el segundo numero de la hora
        CALL    PRINT             ;Imprime el mensaje para solicitar el segundo numero de la hora 
        CALL    READ              ;INPUT de una tecla
		
        SUB     AL,48             ;Convierte el numero a Hexadecima
        MOV     CL,AL		  ;LOW derecha
         
;///////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	;Orimera comparacion HIGH
	;COMPARA SI ES 0 SINO SALTA AL COM4
	;Y si es 0 salta a COM 1
	MOV AH,aux2
        CMP CH,AH
	JE COM1
	JMP COM2

;VERIFICA SI ES MENOR QUE 9 PARA SABER SI ESTA EN LA ZONA AMARILLA TODAVIA 
COM1:
        MOV AL,aux1
        CMP CL,AL
	JB ZONA_VERDE      ;if below
        JMP ZONA_AMARILLA2 ;else
        
        
;Ve la parte HIGH buscando un 1 si es asi salta a la comparacion 5 Y SINO ENTONCES VA A ZONA_LIBRE
COM2:
                
	MOV AH,aux5
        CMP CH,AH	
	JE COM5        ;Equal
	JMP ZONA_LIBRE ;else
	
;Ve la parte LOW buscando si es menor que 8 si es asi salta a la ZONA_VERDE sino salta a la ZONA_AMARILLA2		
COM3:	
        MOV AL,aux3
        CMP CL,AL
        JBE ZONA_AMARILLA ;if below or equal
        JMP COM4	  ;else 
      
	
;VERIFICA QUE SEA MENOR QUE 8 PARA SABER SI SE ENCUENTRA EN LA ZONA ROJA	
COM4:
	MOV AL,aux4
        CMP CL,AL
        JBE ZONA_ROJA  ;if below or equal
        JMP ZONA_LIBRE ;else
	

;Ve la parte LOW buscando si es menor que 2 si es asi salta a la ZONA_AMARILLA sino salta a la comparacion 2
COM5:
	MOV AL,aux6
        CMP CL,AL	
	JB ZONA_AMARILLA ;if below
	JMP COM4	 ;else	
	
		
;///////////////////////////////////////////////////////////////////////////////////////////////////////////

ZONA_VERDE:        
        MOV AH, 09H ;Linea para poder imprimir
        LEA DX,msg1
        INT 21h
	RET



ZONA_AMARILLA:      
        MOV AH, 09H;Linea para poder imprimir
        LEA DX,msg2
        INT 21h
	RET


ZONA_AMARILLA2:     
        MOV AH, 09H;Linea para poder imprimir
        JMP COM3   ;Salta a la comparacion 3
        INT 21h
	RET



ZONA_ROJA:       
        MOV AH, 09H;Linea para poder imprimir
        LEA DX,msg3
        INT 21h
	RET



ZONA_LIBRE:       
        MOV AH, 09H;Linea para poder imprimir
        LEA DX,msg4
        INT 21h
	RET

;///////////////////////////////////////////////////////////////////////////////////////////////////////////
;TERMINA 
;SUMA		
        LEA     DX,FINAL       ;LEO LA CADENA FINAL
        CALL    PRINT          ;LA SACO POR PANTALLA
        MOV     AL,BL          ;GUARDO EL FINALTADO EN AL	
        MOV     AH,0           ;MIRAR SI EL FINALTADO ES MAS GRANDE DE 10
        MOV     BL,0AH         ;MOVEMOS UN 10 A BL
        DIV     BL             ;DIVIDIMOS AX ENTRE 10
        ADD     AL,30h         ;CONVIERTO EL FINALTADO A CHAR
        ADD     AH,30H         ;CONVIERTE FINALTADO A CHAR
        MOV     DL,AL          ;MUEVO A DL PARA SACAR POR PANTALLA EL AL
        PUSH    AX             ;GUARDAMOS EL ACUMULADOR
        MOV     AH,02H         ;rutina para escribir en pantalla
        INT     21h            ;con el 02h escribe en pantalla
        POP     AX             ;RECUPERAMOS EL ACUMULADOR
        MOV     DL,AH          ;MUEVO A DL PARA SACAR POR PANTALLA EL AL
        MOV     AH,02H         ;rutina para escribir en pantalla
        INT     21h            ;con el 02h escribe en pantalla       
        RET

PROYECTO ENDP

;///////////////////////////////////////////////////////////////////////////////////////////////////////////

;SUMA
READ	PROC                   ;Lee la tecla digitadda por el usuario
        MOV     AH,01H         
        INT     21H            
        RET
READ	ENDP

PRINT PROC                     ;Ayuda a imprimir en pantalla
        MOV     AH,09H         
        INT     21H            
        RET
PRINT ENDP

CODIGO ENDS                       
END PROYECTO                     
