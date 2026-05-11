#
# create_project_all.tcl  Tcl script for creating project all
#

set project_directory       [file dirname [info script]]

set test_bench_list {
   "AXI4_USPRAM_64x32_R4W4RF_TEST_BENCH"
   "AXI4_USPRAM_64x32_R8W4RF_TEST_BENCH"
   "AXI4_USPRAM_64x32_R4W8RF_TEST_BENCH"
   "AXI4_USPRAM_64x32_R1W4RF_TEST_BENCH"
   "AXI4_USPRAM_64x32_R4W1RF_TEST_BENCH"
   "AXI4_USPRAM_64x32_R4W4WF_TEST_BENCH"
   "AXI4_USPRAM_64x32_R8W4WF_TEST_BENCH"
   "AXI4_USPRAM_64x32_R4W8WF_TEST_BENCH"
   "AXI4_USPRAM_64x32_R1W4WF_TEST_BENCH"
   "AXI4_USPRAM_64x32_R4W1WF_TEST_BENCH"
   "AXI4_USPRAM_64x32_R4W4NC_TEST_BENCH"
   "AXI4_USPRAM_64x32_R8W4NC_TEST_BENCH"
   "AXI4_USPRAM_64x32_R4W8NC_TEST_BENCH"
   "AXI4_USPRAM_64x32_R1W4NC_TEST_BENCH"
   "AXI4_USPRAM_64x32_R4W1NC_TEST_BENCH"
}    

foreach test_bench $test_bench_list {
    source [file join $project_directory "create_project.tcl"]
    close_project
}
