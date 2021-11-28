#===============================================================================
# .Rprofile
#===============================================================================

# Set CRAN mirror:
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cloud.r-project.org/"
  options(repos = r)
})

if (interactive()) {
  # Never save on exit.
  utils::assignInNamespace(
    "q",
    function(save = "no", status = 0, runLast = TRUE) {
      .Internal(quit(save, status, runLast))
    },
    "base"
  )

  # Limit use of scientific notation for large/small numbers
  options(scipen = 10)

  # Enable tab-completion for library() and require() calls
  utils::rc.settings(ipck = T)

  # Show all loaded objects
  assign(
    "objs",
    function(size = F) {
      napply <- function(names, fn) {
        sapply(names, function(x) fn(get(x, pos = 1)))
      }
      names <- ls(pos = 1)
      obj_class <- napply(names, function(x) as.character(class(x))[1])
      obj_mode <- napply(names, mode)
      obj_type <- ifelse(is.na(obj_class), obj_mode, obj_class)
      obj_dim <- t(napply(names, function(x) as.numeric(dim(x))[1:2]))
      vec <- is.na(obj_dim)[, 1] & (obj_type != "function")
      obj_dim[vec, 1] <- napply(names, length)[vec]
      if (size) {
        obj_size <- napply(names, object.size)
        obj_size_hr <- napply(
          names, function(x) format(utils::object.size(x), units = "MB")
        )
        out <- data.frame(obj_type, obj_size, obj_size_hr, obj_dim)
        names(out) <- c("Type", "Size", "Size MB", "Rows", "Columns")
      }
      else {
        out <- data.frame(obj_type, obj_dim)
        names(out) <- c("Type", "Rows", "Columns")
      }
      # Ignore .Rprofile funcs
      out <- out[
        !rownames(out) %in% c(
          "cd",
          "pwd",
          "h",
          "libs",
          "objs",
          "ll"
        ),
      ]
      out
    },
    envir = globalenv()
  )

  # Show all loaded packages
  assign("libs", function() (.packages()), envir = globalenv())

  # useful aliases
  assign("cd", function() base::setwd(), envir = globalenv())
  assign("pwd", function() base::getwd(), envir = globalenv())
  assign("h", function() base::getwd(), envir = globalenv())
  assign("ll", function(size = F) objs(size), envir = globalenv())

  # Helper packages
  require(jsonlite)  # Dependency for rvisidata
  require(rvisidata)
}
