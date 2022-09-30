/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
IKI_DLLESPEC extern void execute_2894(char*, char *);
IKI_DLLESPEC extern void execute_2895(char*, char *);
IKI_DLLESPEC extern void execute_4897(char*, char *);
IKI_DLLESPEC extern void execute_4898(char*, char *);
IKI_DLLESPEC extern void execute_4899(char*, char *);
IKI_DLLESPEC extern void execute_3230(char*, char *);
IKI_DLLESPEC extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
IKI_DLLESPEC extern void execute_2901(char*, char *);
IKI_DLLESPEC extern void execute_2897(char*, char *);
IKI_DLLESPEC extern void execute_2898(char*, char *);
IKI_DLLESPEC extern void execute_2899(char*, char *);
IKI_DLLESPEC extern void execute_2900(char*, char *);
IKI_DLLESPEC extern void execute_4900(char*, char *);
IKI_DLLESPEC extern void execute_4901(char*, char *);
IKI_DLLESPEC extern void execute_4902(char*, char *);
IKI_DLLESPEC extern void execute_4903(char*, char *);
IKI_DLLESPEC extern void execute_4904(char*, char *);
IKI_DLLESPEC extern void execute_4905(char*, char *);
IKI_DLLESPEC extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[19] = {(funcp)execute_2894, (funcp)execute_2895, (funcp)execute_4897, (funcp)execute_4898, (funcp)execute_4899, (funcp)execute_3230, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_2901, (funcp)execute_2897, (funcp)execute_2898, (funcp)execute_2899, (funcp)execute_2900, (funcp)execute_4900, (funcp)execute_4901, (funcp)execute_4902, (funcp)execute_4903, (funcp)execute_4904, (funcp)execute_4905, (funcp)vlog_transfunc_eventcallback};
const int NumRelocateId= 19;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/Decode_And_Execute_t_behav/xsim.reloc",  (void **)funcTab, 19);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/Decode_And_Execute_t_behav/xsim.reloc");
}

	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

void wrapper_func_0(char *dp)

{

}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/Decode_And_Execute_t_behav/xsim.reloc");
	wrapper_func_0(dp);

	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/Decode_And_Execute_t_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/Decode_And_Execute_t_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/Decode_And_Execute_t_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, (void*)0, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
