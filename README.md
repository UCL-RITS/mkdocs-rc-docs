# Research Computing Documentation Repo

This is a test to try generating our Research Computing documentation with [MkDocs.

## How It Works

Documentation, in markdown format, goes in `./mkdocs-project-dir` in the particular arrangement that MkDocs likes, with the `mkdocs.yml` config file and so on.

When someone pushes to the repository:
 - Travis runs the `./builder/deploy.sh` script, which:
   - checks out the `gh-pages` branch to a directory called `out`
   - deletes the contents of that directory
     - then runs the `./builder/build.sh` script
       - which uses `mkdocs` to build the documentation in the `out` directory. 
   - The contents of `out` are then committed as an update to the `gh-pages` branch of this repo
   - and pushed back to Github using the deploy keys
   - before using curl to trigger the bash CGI script `./remote/update_docs.cgi` to `git pull` on the web server (included here for completeness, it's only ever run on the webserver).

Currently the last step doesn't happen because the production webserver is not setup to host or update the content. In the meanwhile, the built docs can be viewed at the Github pages address for this repo, <http://rits.github-pages.ucl.ac.uk/mkdocs-rc-docs/>.

Docs on how to add pages and structure can be found at the MkDocs pages, at <http://www.mkdocs.org/user-guide/writing-your-docs/>.
