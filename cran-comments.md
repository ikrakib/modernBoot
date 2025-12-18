comments <- "## Resubmission

This is a resubmission. In this version I have:

* Added references to the statistical methods in the Description field of
  DESCRIPTION file, formatted as authors (year) <doi:...> or <ISBN:...> with
  no spaces after 'doi:' or 'ISBN:'.

* Replaced \\dontrun{} with \\donttest{} for examples that can be executed
  but take longer than 5 seconds.

* Removed \\dontrun{} wrapper from examples that execute in < 5 seconds.

## R CMD check results

0 errors | 0 warnings | 1 note

* Note: \"unable to verify current time\"
  This appears to be a transient local network issue on my macOS development
  environment preventing the check process from contacting time servers.
  My system time is correct, and this should not affect CRAN servers."

writeLines(comments, "cran-comments.md")
