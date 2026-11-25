# Shared by the two R.nvim casts. Start R once interactively before recording
# to build nvimcom; first-run installation is not part of the demonstration.
R_FIXTURE=${R_FIXTURE:-$HOME/r_cast_demo.R}

# Part 2 uses built-in data so the viewer demo needs no object setup in R.
MAKE_R_VIEW_FIXTURE() {
  cat > "$R_FIXTURE" <<'R'
mtcars
head(mtcars)
summary(mtcars[,c("disp", "cyl", "mpg")])
R
}

MAKE_R_FIXTURE() {
  cat > "$R_FIXTURE" <<'R'
counts <- c(control = 20, treated = 42)
counts

total <- sum(counts)
print(total)

counts <- c(counts, repeat_run = 31)
counts

samples <- data.frame(group = c("control", "treated"), reads = c(20, 42))
samples
summary(samples)
R
}
