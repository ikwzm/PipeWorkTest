#
# create_project.tcl  Tcl script for creating project
#

set project_directory       [file dirname [info script]]
set project_name            "axi_traffic_checker"
set device_parts            "xc7z010clg400-1"
set test_bench              "AXI_TRAFFIC_CHECKER_TEST_BENCH_64_64"
set scenario_path           [file join ".." ".." ".." "src" "test" "scenarios" "axi_traffic_checker"]
set scenario_file           [file join $scenario_path "test_64_64.snr" ]
#
# Create project
#
cd $project_directory
create_project -force $project_name $project_directory
#
# Set project properties
#
set_property "part"               $device_parts    [get_projects $project_name]
set_property "default_lib"        "xil_defaultlib" [get_projects $project_name]
set_property "simulator_language" "Mixed"          [get_projects $project_name]
set_property "target_language"    "VHDL"           [get_projects $project_name]
#
# Create fileset "sources_1"
#
if {[string equal [get_filesets -quiet sources_1] ""]} {
    create_fileset -srcset sources_1
}
#
# Create fileset "constrs_1"
#
if {[string equal [get_filesets -quiet constrs_1] ""]} {
    create_fileset -constrset constrs_1
}
#
# Create fileset "sim_1"
#
if {[string equal [get_filesets -quiet sim_1] ""]} {
    create_fileset -simset sim_1
}
#
# Create run "synth_1" and set property
#
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part $device_parts -flow "Vivado Synthesis 2015" -strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
  # set_property flow     "Vivado Synthesis 2014"     [get_runs synth_1]
    set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
    set_property strategy "Flow_PerfOptimized_High"   [get_runs synth_1]
}
current_run -synthesis [get_runs synth_1]
#
# Create run "impl_1" and set property
#
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part $device_parts -flow "Vivado Implementation 2015" -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
} else {
  # set_property flow     "Vivado Implementation 2014"     [get_runs impl_1]
    set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
    set_property strategy "Performance_Explore"            [get_runs impl_1]
}
current_run -implementation [get_runs impl_1]
#
# Set 'sources_1' and 'sim_1' fileset object
#

proc add_vhdl_file {fileset library_name file_name} {
    set file    [file normalize $file_name]
    set fileset [get_filesets   $fileset  ] 
    add_files -norecurse -fileset $fileset $file
    set file_obj [get_files -of_objects $fileset $file]
    set_property "file_type" "VHDL"        $file_obj
    set_property "library"   $library_name $file_obj
}
source "add_sources.tcl"
source "add_sim.tcl"
#
# Set 'constrs_1'  fileset object
#
add_files -fileset constrs_1 -norecurse ./timing.xdc
#
# Set 'sources_1' fileset properties
#
set obj [get_filesets sources_1]
set_property "top" "AXI4_MASTER_TO_STREAM" $obj
#
# Set 'sim_1' fileset properties
#
set current_vivado_version [version -short]
if       { [string first "2019.2" $current_vivado_version ] == 0 } {
    set scenario_full_path [file join ".." ".." ".." ".." $scenario_file ]
} elseif { [string first "2018.3" $current_vivado_version ] == 0 } {
    set scenario_full_path [file join ".." ".." ".."      $scenario_file ]
} elseif { [string first "2017"   $current_vivado_version ] == 0 } {
    set scenario_full_path [file join ".." ".." ".." ".." $scenario_file ]
} else {
   puts ""
   puts "ERROR: This model can not run in Vivado <$current_vivado_version>"
   return 1
}
set obj [get_filesets sim_1]
set_property "top"     $test_bench $obj
set_property "generic" "SCENARIO_FILE=$scenario_full_path FINISH_ABORT=true" $obj

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

