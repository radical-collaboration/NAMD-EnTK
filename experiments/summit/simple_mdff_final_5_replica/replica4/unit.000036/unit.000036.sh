#!/bin/sh


# Environment variables
export RP_SESSION_ID="re.session.login4.hrlee.018390.0000"
export RP_PILOT_ID="pilot.0000"
export RP_AGENT_ID="agent.0"
export RP_SPAWNER_ID="agent_executing.0000"
export RP_UNIT_ID="unit.000036"
export RP_UNIT_NAME="task.0036,,stage.0036,NAMD simulation,pipeline.0000,simple-mdff"
export RP_GTOD="/gpfs/alpine/csc393/scratch/hrlee/radical.pilot.sandbox/re.session.login4.hrlee.018390.0000/pilot.0000/gtod"
export RP_TMP="None"
export RP_PILOT_STAGING="/gpfs/alpine/csc393/scratch/hrlee/radical.pilot.sandbox/re.session.login4.hrlee.018390.0000/pilot.0000/staging_area"
export RP_PROF="/gpfs/alpine/scratch/hrlee/csc393/radical.pilot.sandbox/re.session.login4.hrlee.018390.0000/pilot.0000/unit.000036//unit.000036.prof"

prof(){
    if test -z "$RP_PROF"
    then
        return
    fi
    event=$1
    msg=$2
    now=$($RP_GTOD)
    echo "$now,$event,unit_script,MainThread,$RP_UNIT_ID,AGENT_EXECUTING,$msg" >> $RP_PROF
}
export OMP_NUM_THREADS="4"
export "CUDA_VISIBLE_DEVICES="

prof cu_start

# Change to unit sandbox
cd /gpfs/alpine/scratch/hrlee/csc393/radical.pilot.sandbox/re.session.login4.hrlee.018390.0000/pilot.0000/unit.000036/
prof cu_cd_done

# Pre-exec commands
prof cu_pre_start
module unload prrte ||  (echo "pre_exec failed"; false) || exit
module load spectrum-mpi ||  (echo "pre_exec failed"; false) || exit
module load fftw/3.3.8 ||  (echo "pre_exec failed"; false) || exit
prof cu_pre_stop

# The command to run
prof cu_exec_start
/opt/ibm/spectrum_mpi/jsm_pmix/bin/jsrun --erf_input /gpfs/alpine/scratch/hrlee/csc393/radical.pilot.sandbox/re.session.login4.hrlee.018390.0000/pilot.0000/unit.000036//unit.000036.rs   /gpfs/alpine/world-shared/bip115/NAMD_binaries/summit/NAMD_build.latest/Linux-POWER-MPI-smp-Summit/namd2 "+ppn" "4" "adk-step1.namd" 
RETVAL=$?
prof cu_exec_stop

# Exit the script with the return code from the command
prof cu_stop
exit $RETVAL
