#!/usr/bin/tclsh8.5
###############################################################################
## Project    : ELE8304 : Circuits intégrés à très grande échelle 
## Description: Lab2 - Conception d'un microprocesseur
###############################################################################
## File       : compile.tcl
## Author     : Mickaël FIORENTINO  <mickael.fiorentino@polymtl.ca>
## Lab        : grm@polymtl 
## Created    : 2017-08-01
## Last update: 2018-08-27
###############################################################################
## Description: Compile du code assembleur mini-riscv en format hex.
##                - Associé au jeu d'instruction mini-riscv
##                - Suivre l'exemple de fibo.asm pour la syntaxe.
## Usage      : Utiliser un interpréteur tcl pour exécuter le script
##                - Dans un terminal, changer pour répertoire asm;		
##                - % tclsh ../scripts/compile.tcl fibo.asm   
###############################################################################

#=============================================================================#
#   CONFIGURATION
#=============================================================================#
# Make sure we have the right number of parameters
set appname [lindex [split $argv0 /] end]
if { $argc != 1 } {
    puts stderr "USAGE: $appname asm_program.asm "
    exit 1
}

# Make sure input file exists
set filename [lindex $argv 0]
if { ! [file exists $filename] } {
    puts stderr "$filename: file not found"
    exit 1
}

# Read Input file
set prog_file [open $filename r]
set prog_data [read $prog_file]
close $prog_file		
set prog_record [split $prog_data "\n"]

# Open .hex memory file
set HexFileName "init.hex"
set hex_file    [open $HexFileName w]

# Open .txt debug file
set DebugFileName "debug.txt"
set debug_file    [open $DebugFileName w]

#=============================================================================#
#   GENERAL SETTINGS
#=============================================================================#
# Define opcodes
dict set opcode  add   51
dict set opcode  sub   51
dict set opcode  sll   51
dict set opcode  srl   51
dict set opcode  sra   51
dict set opcode  slt   51
dict set opcode  sltu  51
dict set opcode  xor   51
dict set opcode  or    51
dict set opcode  and   51
dict set opcode  addi  19
dict set opcode  slli  19
dict set opcode  srli  19
dict set opcode  srai  19
dict set opcode  slti  19
dict set opcode  sltiu 19
dict set opcode  xori  19
dict set opcode  ori   19
dict set opcode  andi  19
dict set opcode  beq   99
dict set opcode  lw    3
dict set opcode  sw    35
dict set opcode  jal   111
dict set opcode  jalr  103
dict set opcode  lui   55

dict set funct3   jalr  0
dict set funct3   add   0
dict set funct3   sub   0
dict set funct3   sll   1
dict set funct3   srl   5
dict set funct3   sra   5
dict set funct3   slt   2
dict set funct3   sltu  3
dict set funct3   xor   4
dict set funct3   or    6
dict set funct3   and   7
dict set funct3   addi  0
dict set funct3   slli  1
dict set funct3   srli  5
dict set funct3   srai  5
dict set funct3   slti  2
dict set funct3   sltiu 3
dict set funct3   xori  4
dict set funct3   ori   6
dict set funct3   andi  7
dict set funct3   beq   0
dict set funct3   lw    2
dict set funct3   sw    2

dict set funct7   add   0
dict set funct7   sub   32
dict set funct7   sll   0
dict set funct7   srl   0
dict set funct7   sra   32
dict set funct7   slt   0
dict set funct7   sltu  0
dict set funct7   xor   0
dict set funct7   or    0
dict set funct7   and   0
dict set funct7   slli  0
dict set funct7   srli  0
dict set funct7   srai  32

set Rtype  [list "add" "sub" "sll" "srl" "sra" "or" "and" "xor" "slt" "sltu"]
set Itype  [list "addi" "slli" "srli" "srai" "ori" "andi" "xori" "slti" "sltiu" "lw" "jalr"] 
set Stype  [list "sw"]
set Btype  [list "beq"]
set Utype  [list "lui"]
set Jtype  [list "jal"]
set ArithType [list "slli" "srli" "srai"] 

# Define some constants
set commentChar ";;"
set labelChar   ":"
set PC           0

# Procedure to convert 'value' (decimal) into a binary string of 'nbBits' length
proc binformat { nbBits value } {
    binary scan [binary format I* $value] B* rawbits
    set formatbits [string range $rawbits [expr 32 - $nbBits] 31]
    return $formatbits
}

proc istype { opcode type } {
	foreach op $type {
		if { [string compare $op $opcode] == 0 } {
			return 1
		}
	}
	return 0
}

#=============================================================================#
#   FIRST PASS : EVALUATE NUMBER OF INSTRUCTION & GET LABEL ADDRESSES
#=============================================================================#
foreach prog_line $prog_record {
    set line [join $prog_line]
    # Skip empty lines
    if { [string length $line] > 0 } {
	# Skip comments
		if { [string first $commentChar $line] == -1 } {
			set inst [regexp -all -inline {\S+} $line]
			# Labels must be one word followed by ":" (no space)
			if { [llength $inst] == 1 } {
				if { [string first $labelChar $inst] > -1 } {
					lassign [split $inst $labelChar] label_name
					dict set labels $label_name $PC
					# puts "$label_name $PC" 
					# noop instruction is also one word... 
				} elseif { [string compare $inst "nop"] == 0 } {
					set PC [expr $PC + 4]
				}
			} else {
				set PC [expr $PC + 4]
			}
		}	
    }
}; # END OF FIRST PASS

set PC 0

#=============================================================================#
#   SECOND PASS: CONVERT EACH INSTRUCTION IN HEX & WRITE FILE
#=============================================================================#
foreach prog_line $prog_record {
    set line [join $prog_line]
    # Skip empty line
    if { [string length $line] > 0 } {
		#  Skip comments
		if { [string first $commentChar $line] == -1 } {
			set inst [regexp -all -inline {\S+} $line]

			##################################
			#                                #
			# R-type, I-type, S-type, B-type #
			#                                #			
			##################################
			if { [llength $inst] == 4 } {
				# opcode is always first. x, y & z are operands
				lassign $inst op x y z;

				##
				## R-type
				##
				if { [istype $op $Rtype] } {
					# Test if expression is formed correctly
					set sentence [expr   [regexp {^x[0-9]}  $x]\
								       & [regexp {^x[0-9]}  $y]\
								       & [regexp {^x[0-9]}  $z]]
					if { !$sentence } {
						puts stderr "Malformed expression: $prog_line";	    
						exit 1;							
					}					
					#funct7
				    set itmp [binformat 7 [dict get $funct7 $op]]
					# rs2
					append itmp [binformat 5 [lindex [split $z x] end]]
					# rs1
					append itmp [binformat 5 [lindex [split $y x] end]]
					# funct3
					append itmp [binformat 3 [dict get $funct3 $op]]					
					# rd
					append itmp [binformat 5 [lindex [split $x x] end]]					
					# opcode
					append itmp [binformat 7 [dict get $opcode $op]]

				##
				## I-type
				##
				} elseif { [istype $op $Itype] } {
					# Test if expression is formed correctly
					set sentence [expr   [regexp {^x[0-9]}       $x]\
								       & [regexp {^x[0-9]}       $y]\
								       & [expr [regexp {^[0-9]}  $z]\
										     | [regexp {^-[0-9]} $z]]]					
					if { !$sentence } {
						puts stderr "Malformed expression: $prog_line";	    
						exit 1;							
					}
					# Special case for shift operations
					if { [istype $op $ArithType] } {
						# funct 7
					    set itmp [binformat 7 [dict get $funct7 $op]]
						# shamt
						append itmp [binformat 5 $z]
					} else {
						# imm12
						set itmp [binformat 12 $z]
					}
					# rs1
					append itmp [binformat 5 [lindex [split $y x] end]]					
					# funct3
					append itmp [binformat 3 [dict get $funct3 $op]]					
					# rd
					append itmp [binformat 5 [lindex [split $x x] end]]					
					# opcode
					append itmp [binformat 7 [dict get $opcode $op]]											

				##
				## S-Type
				##
				} elseif { [istype $op $Stype] } {
					# Test if expression is formed correctly
					set sentence [expr   [regexp {^x[0-9]}       $x]\
								       & [regexp {^x[0-9]}       $y]\
								       & [expr [regexp {^[0-9]}  $z]\
									         | [regexp {^-[0-9]} $z]]]
					if { !$sentence } {
						puts stderr "Malformed expression: $prog_line";	    
						exit 1;							
					}
					set Simm [binformat 12 $z]
					# Imm [11:5]
				    set itmp [string range $Simm 0 6]
					# rs2
					append itmp [binformat 5 [lindex [split $x x] end]]
					# rs1
					append itmp [binformat 5 [lindex [split $y x] end]]
					# funct3
					append itmp [binformat 3 [dict get $funct3 $op]]					
					# Imm [4:0]
					append itmp [string range $Simm 7 11]				
					# opcode
					append itmp [binformat 7 [dict get $opcode $op]]					

				##
				## B-Type
				##	
				} elseif { [istype $op $Btype] } {
					# Test if expression is formed correctly
					set sentence [expr  [regexp {^x[0-9]}      $x]\
									  & [regexp {^x[0-9]}      $y]\
									  & [regexp {^[a-z][a-z]+} $z]\
									  & ![regexp {^x[0-9]}     $z]]					
					if { !$sentence } {
						puts stderr "Malformed expression: $prog_line";	    
						exit 1;							
					}
					# Target address
					if { [catch {dict get $labels $z} err] } {
						puts stderr "Unknown label: $z";	    
						exit 1;	
					}
					set abs_target [dict get $labels $z]
					set rel_target [expr $abs_target - $PC]					
					# imm[12:1]
					set Bimm [binformat 12 $rel_target]
					# puts "$prog_line : $abs_target $rel_target $Bimm"					
					# Imm [12]
				    set itmp [string index $Bimm 0]
					# Imm [10:5]
				    append itmp [string range $Bimm 1 6]
					# rs2
					append itmp [binformat 5 [lindex [split $y x] end]]
					# rs1
					append itmp [binformat 5 [lindex [split $x x] end]]
					# funct3
					append itmp [binformat 3 [dict get $funct3 $op]]					
					# Imm [4:1]
					append itmp [string range $Bimm 7 10]
					# Imm [11]
					append itmp [string index $Bimm 0]				
					# opcode
					append itmp [binformat 7 [dict get $opcode $op]]
				} else {
					puts stderr "Malformed expression: $prog_line";	    
					exit 1;	
				}

				##
				## Format instruction, Increment PC
				##
				set itmp [format %08X [expr 0b$itmp]]
				set PC [expr $PC + 4]
				
			###################
			#                 #
			#  U-type, J-type #
			#                 #				
			###################
			} elseif { [llength $inst] == 3 } {
				# opcode is always first. x, y are operands
				lassign $inst op x y;

				##
				## U-Type
				##
				if { [istype $op $Utype] } {
					# Test if expression is formed correctly
					set sentence [expr   [regexp {^x[0-9]}       $x]\
								       & [expr [regexp {^[0-9]}  $y]\
										     | [regexp {^-[0-9]} $y]]]
					if { !$sentence } {
						puts stderr "Malformed expression: $prog_line";	    
						exit 1;							
					}
					# imm20
					set itmp [binformat 20 $y]
					# rd
					append itmp [binformat 5 [lindex [split $x x] end]]
					# opcode
					append itmp [binformat 7 [dict get $opcode $op]]
					
				##
				## J-Type
				##	
				} elseif { [istype $op $Jtype] } {
					# Test if expression is formed correctly
					set sentence [expr   [regexp {^x[0-9]}      $x]\
								       & [regexp {^[a-z][a-z]+} $y]\
									   & ![regexp {^x[0-9]}     $y]]	
					if { !$sentence } {
						puts stderr "Malformed expression: $prog_line";	    
						exit 1;							
					}
					# Target address
					if { [catch {dict get $labels $y} err] } {
						puts stderr "Unknown label: $y";	    
						exit 1;	
					}					
					set abs_target [dict get $labels $y]
					set rel_target [expr $abs_target - $PC]
					set Jimm [binformat 20 $rel_target]
					# puts "$prog_line : $abs_target $rel_target $Jimm"
					# Imm [20]
					set itmp [string index $Jimm 0]
					# Imm [10:1]
					append itmp [string range $Jimm 9 18]
					# Imm [11]
					append itmp [string index $Jimm 8]
					# Imm [19:12]
					append itmp [string range $Jimm 0 7]
					# rd
					append itmp [binformat 5 [lindex [split $x x] end]]
					# opcode
					append itmp [binformat 7 [dict get $opcode $op]]					
				} else {
					puts stderr "Malformed expression: $prog_line";	    
					exit 1;	
				}					

				##
				## Format instruction, Increment PC
				##
				set itmp [format %08X [expr 0b$itmp]]
				set PC [expr $PC + 4]
				
			################
			#              #
			# labels & nop #
			#              #
			################
			} elseif { [llength $inst] == 1 } {

				##
				## label
				##
				if { [string first $labelChar $inst] > -1 } {
					## write the associated address from dict
					# lassign [split $inst $labelChar] label_name
					# set label_addr [format %08X [dict get $labels $label_name]]
					# set itmp "@$label_addr"
					puts $debug_file "\n$inst"
					continue

				##
				## nop
				##
				} elseif { [string compare $inst "nop"] == 0 } {
					## replace by a no-op instruction (addi x0 x0 r0)
					set itmp [binformat 25 0]				    				
					# opcode
					append itmp [binformat 7 [dict get $opcode "addi"]]

					##
					## Format instruction, Increment PC
					##
					set itmp [format %08X [expr 0b$itmp]]
					set PC [expr $PC + 4]
						    
				} else {											    
					puts stderr "Malformed expression: $prog_line";	    
					exit 1;											    
				}				
			} else {												    
				puts stderr "Malformed expression: $prog_line";		    
				exit 1;												    
			}														    
			# Write instruction to destination files 
			puts $hex_file $itmp
			puts $debug_file "\t[expr $PC - 4]\t: $itmp\t\t# $inst"
		}
    }
};	# END OF SECOND PASS

## Add some zeros...
puts $hex_file [binformat 8 0]
puts $hex_file [binformat 8 0]
