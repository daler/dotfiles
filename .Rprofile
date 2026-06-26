# This restricts the number of CPUs that can be used by the R.nvim plugin.
# Needs R.nvim >=0.9.96
options(nvimcom.max_cpu_cores = max(2, as.numeric(Sys.getenv("SLURM_CPUS_PER_TASK")), na.rm=TRUE))
