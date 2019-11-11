## this builds the documentation, builds the html, then pushes it all to git.renre.com

Sys.setenv(RSTUDIO_PANDOC = "/Applications/RStudio.app/Contents/MacOS/pandoc")

# cred <- git2r::cred_env("GITRENRE_UID", "GITRENRE_PAT")

repo <- git2r::init(".")
# git2r::config(repo, user.name = "jal", user.email = "jal@renre.com")


git2r::pull(credentials = cred)

rmarkdown::render("intro_to_r.Rmd",
                  output_file = "docs/index.html")

git2r::commit(message = paste(
  "automatic documentation built on:",
  format(Sys.time(), '%Y-%m-%d %H:%M')
),
all = TRUE)

git2r::push(credentials = cred)
