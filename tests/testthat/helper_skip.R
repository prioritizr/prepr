skip_on_win32 <- function() {
  if (.Platform$OS.type == "windows" && .Machine$sizeof.pointer != 8) {
    skip("On Windows i386")
  }
}
