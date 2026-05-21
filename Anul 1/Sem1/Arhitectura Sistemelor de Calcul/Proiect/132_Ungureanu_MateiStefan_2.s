.data

matrix: .space 1600
M: .space 1600
m: .space 4
n: .space 4
p: .space 4
k: .space 4
x: .space 4
y: .space 4
i: .space 4
j: .space 4
sum: .space 4
line: .space 4
column: .space 4
formatString: .asciz "%d"
formatNewLine: .asciz "\n"
if: .space 4
of: .space 4
w: .asciz "w"
r: .asciz "r"
input: .asciz "in.txt"
output: .asciz "out.txt"

.text

.global main

main:

pushl $r
pushl $input
call fopen
addl $8, %esp
movl %eax, if

pushl $w
pushl $output
call fopen
addl $8, %esp
movl %eax, of

# citesc m
pushl $m
pushl $formatString
pushl if
call fscanf
addl $12, %esp

# citesc n
pushl $n
pushl $formatString
pushl if
call fscanf
addl $12, %esp

# citesc p
pushl $p
pushl $formatString
pushl if
call fscanf
addl $12, %esp

# creez matricea initiala, extinsa

lea matrix, %edi

mov $0, %ecx

incl m
incl m
incl n
incl n

loop:

	cmp p, %ecx
	je end_loop

	push %ecx

	# citesc primul indice
	pushl $x
	pushl $formatString
	pushl if
	call fscanf
	addl $12, %esp

	# citesc al doilea indice
	pushl $y
	pushl $formatString
	pushl if
	call fscanf
	addl $12, %esp

	pop %ecx

	incl x
	incl y

	# pun 1 pe pozitia (x,y) in matrice
	movl x, %eax
	mull n
	add y, %eax
	movl $1, (%edi, %eax, 4)

	inc %ecx
	jmp loop

end_loop:

# citesc k
pushl $k
pushl $formatString
pushl if
call fscanf
addl $12, %esp

incl k

# creez matricea copie, extinsa

lea M, %esi
decl m

# modific matricea copiata, iteratie impara
iteratie_impara:

	incl m
	# verific daca mai am iteratii de facut
	decl k
	movl k, %eax
	cmp $0, %eax
	je afisare_para

	movl $1, i

	# parcurg matricea cu 2 foruri
	for_i_impara:
		 
		# verific daca s-a terminat primul for
		movl i, %ecx
		decl m
		cmp m, %ecx
		je iteratie_para
		incl m

		movl $1, j

		for_j_impara:

			# verific daca s-a terminat al doilea for
			movl j, %ecx
			decl n
			cmp n, %ecx
			je endfor1_impara
			incl n
			
			# pun in eax elementul (i,j)
			movl $0, %eax
			movl i, %eax
			mull n
			addl j, %eax
			
			movl %eax, %ecx
			movl $0, %edx

			# fac suma tuturor celor 8 vecini
			addl 4(%edi, %ecx, 4), %edx
			addl -4(%edi, %ecx, 4), %edx
			
			
			subl n, %ecx
			addl (%edi, %ecx, 4), %edx
			addl 4(%edi, %ecx, 4), %edx
			addl -4(%edi, %ecx, 4), %edx
			
			addl n, %ecx
			
			addl n, %ecx
			addl (%edi, %ecx, 4), %edx
			addl 4(%edi, %ecx, 4), %edx
			addl -4(%edi, %ecx, 4), %edx
			subl n, %ecx

			# verific daca celula este vie
			movl (%edi, %ecx, 4), %ebx
			cmp $1, %ebx
			jne creare_impara

			# verific daca e subpopulare
			cmp $2, %edx
			jl et0_impara

			# verific daca e ultrapopulare
			cmp $3, %edx
			jg et0_impara
 
			jmp et1_impara

			# verific daca e creare
			creare_impara:
			cmp $3, %edx
			je et1_impara

			jmp et0_impara

			et0_impara:
			movl $0, (%esi, %ecx, 4)

			jmp end_impara

			et1_impara:
			movl $1, (%esi, %ecx, 4)

			end_impara:

			incl j
			jmp for_j_impara

	endfor1_impara:

	incl n
	incl i
	jmp for_i_impara

# modific matricea copiata, iteratie para
iteratie_para:

	incl m
	# verific daca mai am iteratii de facut
	decl k
	movl k, %eax
	cmp $0, %eax
	je afisare_impara

	movl $1, i

	# parcurg matricea cu 2 foruri
	for_i_para:

		# verific daca s-a terminat primul for
		movl i, %ecx
		decl m
		cmp m, %ecx
		je iteratie_impara
		incl m

		movl $1, j

		for_j_para:

			# verific daca s-a terminat al doilea for
			movl j, %ecx
			decl n
			cmp n, %ecx
			je endfor1_para
			incl n
			
			# pun in eax elementul (i,j)
			movl $0, %eax
			movl i, %eax
			mull n
			addl j, %eax
			
			movl %eax, %ecx
			movl $0, %edx

			# fac suma tuturor celor 8 vecini
			addl 4(%esi, %ecx, 4), %edx
			addl -4(%esi, %ecx, 4), %edx
			
			
			subl n, %ecx
			addl (%esi, %ecx, 4), %edx
			addl 4(%esi, %ecx, 4), %edx
			addl -4(%esi, %ecx, 4), %edx
			
			addl n, %ecx
			
			addl n, %ecx
			addl (%esi, %ecx, 4), %edx
			addl 4(%esi, %ecx, 4), %edx
			addl -4(%esi, %ecx, 4), %edx
			subl n, %ecx

			# verific daca celula este vie
			movl (%esi, %ecx, 4), %ebx
			cmp $1, %ebx
			jne creare_para

			# verific daca e subpopulare
			cmp $2, %edx
			jl et0_para

			# verific daca e ultrapopulare
			cmp $3, %edx
			jg et0_para
 
			jmp et1_para

			# verific daca e creare
			creare_para:
			cmp $3, %edx
			je et1_para

			jmp et0_para

			et0_para:
			movl $0, (%edi, %ecx, 4)

			jmp end_para

			et1_para:
			movl $1, (%edi, %ecx, 4)

			end_para:

			incl j
			jmp for_j_para

	endfor1_para:

	incl n
	incl i
	jmp for_i_para


afisare_impara:

	movl $1, line

	for_line_impara:

		# verific daca s-a terminat primul for
		movl line, %ecx
		decl m
		cmp m, %ecx
		je et_final_afisare
		incl m

		movl $1, column
 
		for_column_impara:

			# verific daca s-a terminat al doilea for
			movl column, %ecx
			decl n
			cmp n, %ecx
			je endfor2_impara
			incl n

			# pun in eax elementul (line,column)
			movl $0, %eax
			movl line, %eax
			mull n
			add column, %eax
 
			# afisez elementul (line,column)
			movl (%esi, %eax, 4), %ebx
			pushl %ebx
			push $formatString		
			pushl of
			call fprintf
			addl $12, %esp
 
			pushl $0
			call fflush
			popl %ebx

			incl column
			jmp for_column_impara

		endfor2_impara:

		# afisez o linie noua la sfarsitul celui de-al doilea for
		incl n
		incl line
		push $formatNewLine
		pushl of
		call fprintf
		addl $8, %esp
		jmp for_line_impara

afisare_para:

	movl $1, line

	for_line_para:

		# verific daca s-a terminat primul for
		movl line, %ecx
		decl m
		cmp m, %ecx
		je et_final_afisare
		incl m

		movl $1, column
 
		for_column_para:

			# verific daca s-a terminat al doilea for
			movl column, %ecx
			decl n
			cmp n, %ecx
			je endfor2_para
			incl n

			# pun in eax elementul (line,column)
			movl $0, %eax
			movl line, %eax
			mull n
			add column, %eax
 
			# afisez elementul (line,column)
			movl (%edi, %eax, 4), %ebx
			pushl %ebx
			push $formatString
			pushl of
			call fprintf
			addl $12, %esp
 
			pushl $0
			call fflush
			popl %ebx

			incl column
			jmp for_column_para

		endfor2_para:

		# afisez o linie noua la sfarsitul celui de-al doilea for
		incl n
		incl line
		push $formatNewLine
		pushl of
		call fprintf
		addl $8, %esp
		jmp for_line_para

et_final_afisare:

incl n 
incl m

et_final:

movl $1, %eax
xorl %ebx, %ebx
int $0x80
