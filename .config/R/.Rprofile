#===============================================================================
# .Rprofile
#===============================================================================

# Never save on exit.
utils::assignInNamespace(
  "q", 
  function(save = "no", status = 0, runLast = TRUE) 
  {
    .Internal(quit(save, status, runLast))
  }, 
  "base"
)

# Limit use of scientific notation for large/small numbers
options(scipen = 10)

# Enable tab-completion for library() and require() calls
utils::rc.settings(ipck = T)

# Set CRAN mirror:
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cloud.r-project.org/"
  options(repos = r)
})

#===============================================================================
# Sources:
#===============================================================================

# stackoverflow.com/questions/4996090/how-to-disable-save-workspace-image-prompt-in-r
# https://www.r-bloggers.com/fun-with-rprofile-and-customizing-r-startup/
# https://wiki.archlinux.org/index.php/R#Adding_a_graphical_frontend_to_R

