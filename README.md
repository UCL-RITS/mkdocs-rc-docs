# Research Computing Documentation Repo

This is a test to try generating our Research Computing documentation with [MkDocs](https://www.mkdocs.org/).

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

## Markdown Extensions

The installation of MkDocs uses the Material theme and several Markdown extensions:

 - [Admonition](https://squidfunk.github.io/mkdocs-material/extensions/admonition/) -- allowing call-out blocks
 - [CodeHiLite](https://squidfunk.github.io/mkdocs-material/extensions/codehilite/) -- uses Pygments for syntax-highlighting instead of JavaScript
 - [Permalinks](https://squidfunk.github.io/mkdocs-material/extensions/permalinks/) -- inserts anchors for all headings

## Initial Conversion Notes

The conversion process from MediaWiki markup to Markdown did not go very well. There were two main classes of problem:

 - pandoc appears to hate code blocks, and has done some very weird things.
 - MediaWiki appears to have refused to render the giant Application template, so a lot of the application pages converted to no content.

Unfortunately this means that a lot of manual editing is necessary:

 - Code blocks need to have their extra single-line backticks removed and be correctedly marked-up with backtick fences (\`\`\`). Language will be inferred from shebang lines, but otherwise you might want to add the language if it's a Python or bash script block. In many cases it's quicker to copy/paste the code from the corresponding original mediawiki page source.
 - Application pages that haven't rendered need to be manually converted. Thankfully, it's not *that* much work, but there are a lot of them and some of them are functional duplicates of other pages.

Some pages need non-trivial changes, in most cases because they're extremely out-of-date. I've put these in `needs_work` directories.
