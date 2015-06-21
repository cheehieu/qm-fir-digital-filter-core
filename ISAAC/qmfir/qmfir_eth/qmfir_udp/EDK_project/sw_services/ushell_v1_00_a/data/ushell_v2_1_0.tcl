###############################################################################
#
# uShell - A minimalist shell for the Xilinx Virtex PPC-class 
# uProcessors
#
# ORIGINAL AUTHOR: Thomas Werne
# COMPANY: Jet Propulsion Laboratory
# VERSION: 1.00
#
# File: ushell_v2_1_0.tcl
# $Author: werne $
# $Date: 2009-11-15 00:46:05 -0800 (Sun, 15 Nov 2009) $
# $Rev: 44 $
#
# Used by Xilinx libgen to build config files for uShell project
#
# Copyright 2009, 2010, by the California Institute of Technology.  ALL
# RIGHTS RESERVED.  United States Government Sponsorship acknowledged.
# Any commercial use must be negotiated with the Office of Technology
# Transfer at the California Institute of Technology.
#
# This software may be subject to U.S. export control laws and
# regulations.  by accepting this document, the user agrees to comply
# with all U.S. export laws and regulations.  User has the
# responsibility to obtain export licenses, or other export authority
# as may be required before exporting such information to foreign
# countries or providing access to foreign persons.
###############################################################################

proc ushell_drc {lib_handle} {

}

proc write_file_header {fp type fname desc} {

    if [string equal -nocase $type "C"] {
       set hdr "/**************************************************************"
       set ftr " **************************************************************/"
       set cmt " *"
    } elseif {[string equal -nocase $type "Makefile"] || 
               [string equal -nocase $type "shell"]} {
        set hdr "###############################################################################"
        set ftr "###############################################################################"
        set cmt "#"
    } elseif [string equal -nocase $type "Matlab"] {
        set hdr "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
        set ftr "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
        set cmt "%"
    }

    puts $fp $hdr
    puts $fp "$cmt"
    puts $fp \
        "$cmt uShell - A minimalist shell for the Xilinx Virtex PPC-class "
    puts $fp "$cmt uProcessors"
    puts $fp "$cmt"
    puts $fp "$cmt ORIGINAL AUTHOR: Thomas Werne"
    puts $fp "$cmt COMPANY: Jet Propulsion Laboratory"
    puts $fp "$cmt VERSION: 1.00"
    puts $fp "$cmt"
    puts $fp "$cmt File: $fname" 
    puts $fp "$cmt \$Author: \$"
    puts $fp "$cmt \$Date: \$"
    puts $fp "$cmt \$Rev: -1 \$"
    puts $fp "$cmt"
    puts $fp "$cmt Target: PowerPC 440, PowerPC 405, Microblaze"
    puts $fp "$cmt"
    puts $fp "$cmt $desc"
    puts $fp "$cmt Copyright 2009, 2010, by the California Institute of Technology.  ALL"
    puts $fp "$cmt RIGHTS RESERVED.  United States Government Sponsorship acknowledged."
    puts $fp "$cmt  Any commercial use must be negotiated with the Office of Technology"
    puts $fp "$cmt Transfer at the California Institute of Technology."
    puts $fp "$cmt"
    puts $fp "$cmt This software may be subject to U.S. export control laws and"
    puts $fp "$cmt regulations.  by accepting this document, the user agrees to comply"
    puts $fp "$cmt with all U.S. export laws and regulations.  User has the"
    puts $fp "$cmt responsibility to obtain export licenses, or other export authority"
    puts $fp "$cmt as may be required before exporting such information to foreign"
    puts $fp "$cmt countries or providing access to foreign persons."
    puts $fp $ftr
    puts $fp ""
    
}

proc add_config_line {fp lib_handle param define} {

    if [ xget_value $lib_handle "PARAMETER" $param ] {
        puts $fp "#define $define"
    }

}

proc generate {lib_handle} {
    set confhdr  [ xopen_include_file "xparameters.h" ]

    # Build Makefile.deps
    set depsfile [ open "src/Makefile.deps" w]
    write_file_header $depsfile MAKEFILE "Makefile.deps" \
        "Defines project-specific make dependencies"
    
    # Build the file ushell_config.h
    set conffile [ open "../../include/ushell_config.h" w ]
    set config_list "interrupts jump cache usage exec history help \
        halt reboot copy load dump rwr rrd mwr mrd wr rd mems devs \
        list ls"
    set configs "ENABLE_INTERRUPT_DRIVEN ENABLE_JUMP ENABLE_CACHE \
        ENABLE_USAGE ENABLE_EXEC ENABLE_HISTORY ENABLE_HELP \
        ENABLE_HALT ENABLE_REBOOT ENABLE_COPY ENABLE_LOAD \
        ENABLE_DUMP ENABLE_RWR ENABLE_RRD ENABLE_MWR ENABLE_MRD \
        ENABLE_WR ENABLE_RD ENABLE_MEMS ENABLE_DEVS ENABLE_LIST \
        ENABLE_LS"

    write_file_header $conffile C "ushell_config.h" "Configuration\
        header for conditionally including functions in uShell"

    puts $conffile "#ifndef USHELL_CONFIG_H" 
    puts $conffile "#define USHELL_CONFIG_H"
    puts $conffile ""

    foreach config $config_list {
        set index [lsearch $config_list $config]
        add_config_line $conffile $lib_handle $config \
            [lindex $configs $index]
    }

    # Play some games to get a list of peripherals
    set sw_processor [xget_libgen_proc_handle]
    set processor [xget_handle $sw_processor "IPINST"]
    set peripheral_list [xget_proc_slave_periphs $processor]

    set processor_type [xget_hw_value $processor]
    if [string equal -nocase $processor_type ppc440_virtex5] {
        puts $depsfile "PROC_SRC := ppc440.c"
        puts $conffile "#define PPC440"
    } elseif [string equal -nocase $processor_type ppc405_virtex4] {
        puts $depsfile "PROC_SRC := ppc405.c"
        puts $conffile "#define PPC405"
    } elseif [string equal -nocase $processor_type microblaze] {
        puts $depsfile "PROC_SRC := microblaze.c"
        puts $conffile "#define MICROBLAZE"
    } else {
        error "Unknown processor type: $processor_type"
    }

    puts $conffile ""
    puts $conffile "#endif /* USHELL_CONFIG_H */"

    close $conffile
    close $depsfile
    close $confhdr

    # Initialize the device and memory map files 
    set mem_file [open "src/memory_map.c" w]
    set dev_file [open "src/device_map.c" w]

    write_file_header $mem_file C "memory_map.c" \
        "uShell memory map file"
    write_file_header $dev_file C "device_map.c" \
        "uShell device map file"

    puts $mem_file "#include <stdlib.h>"
    puts $mem_file "#include \"ushell.h\""
    puts $mem_file ""
    puts $mem_file "const address_table memory_map\[\] = {"

    puts $dev_file "#include <stdlib.h>"
    puts $dev_file "#include \"ushell.h\""
    puts $dev_file ""
    puts $dev_file "const address_table device_map\[\] = {"

    set dev_id 1
    set mem_id 1

    # Iterate through the peripherals
    foreach periph $peripheral_list {
        set is_memory 0
        set is_device 0

        # Gets the type of the hardware peripheral
        set instance_type [xget_hw_value $periph]
        set instance_name [xget_hw_name $periph]

        # Check for different types of memory separately (basename and
        # highname are different...)
        if [string equal $instance_type ppc440mc_ddr2] {
            set is_memory 1
            set basename C_MEM_BASEADDR
            set highname C_MEM_HIGHADDR
        } elseif [string equal $instance_type xps_bram_if_cntlr] {
            set is_memory 1
            set basename C_BASEADDR
            set highname C_HIGHADDR
        } elseif [string equal $instance_type mpmc] {
            set is_memory 1
            set basename C_MPMC_BASEADDR
            set highname C_MPMC_HIGHADDR
        } else {
            set is_device 1

            set base_addr [xget_hw_parameter_value $periph C_BASEADDR]
            set high_addr [xget_hw_parameter_value $periph C_HIGHADDR]
        }


        if {$is_memory == 1} {
            set base_addr [xget_hw_parameter_value $periph $basename]
            set high_addr [xget_hw_parameter_value $periph $highname]

            puts $mem_file "    { $mem_id, \"$instance_name\",\
                $base_addr, $high_addr},"

            incr mem_id
        }

        if {$is_device == 1} {
            # Make sure this REALLY is a device...
            if {![string equal $base_addr ""] && \
                    ![string equal $high_addr ""]} {

                puts $dev_file "    { $dev_id, \"$instance_name\",\
                    $base_addr, $high_addr},"
                incr dev_id
            }
        }
    }
   
    # Clean up
    puts  $dev_file "    { 0, NULL, 0, 0} \n};"
    puts  $dev_file ""
    close $dev_file

    puts  $mem_file "    { 0, NULL, 0, 0} \n};"
    puts  $mem_file ""
    close $mem_file

}

proc get_ushell_functions {include_dirs} {

    set key _USHELL

    # Go look in the include directory to find the USHELL functions
    set include_str "-Isrc -I../../include"
    set includes "src/ushell.h"

    foreach dir $include_dirs {
        lappend includes [glob -directory $dir *.h]
        lappend include_str -I$dir
    }

    # Preprocess all the .h files (and remove comments :)
    set hfile [open "| powerpc-eabi-gcc -E -DUSHELL=$key \
        $include_str [join $includes]" r]
    set header_code [read $hfile]

    # we MUST catch {} here.  If gcc throws a warning, 
    # it will cause an exit otherwise.
    catch {close $hfile}

    # Kill newlines, then break the string up at the $key
    set header_code [split $header_code]
    set idx [concat [lsearch -all $header_code $key] \
        [llength $header_code]]

    # Now parse the code for instances of $key
    for {set i 1} {$i < [llength $idx]} {incr i} {
        set loc  [join [lrange $header_code [lindex $idx \
            [expr $i - 1]] [lindex $idx $i]]]
        set code [split $loc \;]
        lappend function_sigs [lrange [lindex $code 0] 1 end]
    }
    
    # Since we apply CPP to each header separately, we might have 
    # dups.  Get rid of 'em.
    set function_sigs [lsort -unique $function_sigs]

    foreach function $function_sigs {

        set function_name [split $function "(" ]
        set function_name [lindex [lindex $function_name 0] end]

        lappend functions "$function_name $function"

    }

    return $functions
}

# Generate function table
proc post_generate {lib_handle} {

    # Create function_map.c
    set func_file [open "src/function_map.c" w]
    write_file_header $func_file C "function_map.c" \
        "uShell function map file"

    puts $func_file "#include <stdlib.h>"
    puts $func_file "#include \"ushell.h\""
    puts $func_file ""

    set dirs [split [xget_value $lib_handle "PARAMETER" \
        INCLUDE_DIRS] \;]

    set functions [get_ushell_functions $dirs]

    foreach function $functions {
        puts $func_file "extern [lrange $function 1 end];"
    }

    puts $func_file ""

    # and populate the function map
    puts $func_file "const function_table function_map\[\] = {"
    foreach function $functions {
        puts $func_file "    {\"[lindex ${function} 0]\",\
            [lindex ${function} 0]},"
    }
    
    puts  $func_file "    {NULL, NULL} \n};"
    puts  $func_file ""
    close $func_file
}
