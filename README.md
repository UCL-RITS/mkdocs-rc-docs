# Research Computing Documentation Repo

This repository houses the source and build method for the [Research Computing documentation](https://www.rc.ucl.ac.uk) with [MkDocs](https://www.mkdocs.org/).

## How It Works

Documentation, in markdown format, goes in `./mkdocs-project-dir` in the
particular arrangement that MkDocs likes, with the `mkdocs.yml` config file and
so on.

When someone pushes to the repository:

- GitHub Actions runs the `./builder/deploy.sh` script, which:
  - checks out the `gh-pages` branch to a directory called `out`
  - deletes the contents of that directory
    - then runs the `./builder/build.sh` script
      - which uses `mkdocs` to build the documentation in the `out` directory.
  - The contents of `out` are then committed as an update to the `gh-pages`
    branch of this repo
  - and pushed back to Github using the deploy keys

On the webserver, `cron` for `ccspwww` checks every ten minutes (+2, so
2,12,22,etc past the hour) using the `remote/cron_updates.sh` script whether
there has been a new update to the `gh-pages` branch and if so, it pulls the
updates down. The updates would have been handled by a CGI bash script,
`remote/update_docs.cgi`, but this seemed a little rickety even for us.

Docs on how to add pages and structure can be found at the MkDocs pages, at
<http://www.mkdocs.org/user-guide/writing-your-docs/>.

### Best linking practice

Links to our other pages should be to the `.md` file when possible: this allows
the build process to warn about broken links. Eg. a link like
`[Access services from outside UCL](../howto.md#logging-in-from-outside-the-ucl-firewall)`
will be checkable.

### Hiding pages from the sidebar

Directories can be made non-indexable so don't automatically show in the sidebar
if you create a `.pages` file inside them that contains `hide: true`. Files
inside them can be linked from elsewhere as usual.

Documentation at <https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin>

## Package List Updates

In addition to the normal pages, the webserver has `cron` for `ccspwww` set up
to run the `remote/pkg_list_updates.sh` script, which connects to our Myriad
cluster. The ssh keys there are configured to automatically run scripts that
dump the package lists as JSON (instead of starting a normal shell session),
which the script writes to temporary files, before moving to the correct places
if successful.

## Support Scripts

Note that neither of the update scripts in the `remote` directory are deployed
or updated automatically. If you need to make changes to the live version, you
will need to handle these yourself.

## Markdown Extensions

The installation of MkDocs uses the Material theme and several Markdown extensions:

- [Admonition](https://squidfunk.github.io/mkdocs-material/extensions/admonition/)
  -- allowing call-out blocks
- [CodeHiLite](https://squidfunk.github.io/mkdocs-material/extensions/codehilite/)
  -- uses Pygments for syntax-highlighting instead of JavaScript
- [Permalinks](https://squidfunk.github.io/mkdocs-material/extensions/permalinks/)
  -- inserts anchors for all headings

## MkDocs Extensions

The installation of MkDocs also has the following plugins installed:

- [awesome-pages](https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin) --
  Adds selective customisation of page index creation. Mostly for customising
  page order in the index

## Running the MkDocs Server Locally

You can run a local MkDocs server on your own machine if you want to see how
things look while you're working on them, rather than relying on them being
pushed to the server and waiting for them to be rendered by the automatic
pipeline.

To do this, create a `virtualenv` with MkDocs and the skin we use:

``` shell
$ python -m venv env
$ source env/bin/activate
$ pip install -r requirements.txt
[...]
Successfully installed Jinja2-2.10.1 Markdown-3.1.1 MarkupSafe-1.1.1 PyYAML-5.1.2 Pygments-2.4.2 click-7.0 htmlmin-0.1.12 jsmin-2.2.2 livereload-2.6.1 mkdocs-1.0.4 mkdocs-material-4.4.0 mkdocs-minify-plugin-0.2.1 pymdown-extensions-6.0 six-1.12.0 tornado-6.0.3

# Then change into the directory with the mkdocs.yml file in.
$ cd mkdocs-project-dir
$ mkdocs serve
INFO    -  Building documentation...
INFO    -  Cleaning site directory
[...a bunch of linking warnings, probably...]
[I 190802 16:48:43 server:296] Serving on http://127.0.0.1:8000
```

## Initial Conversion Notes

The conversion process from MediaWiki markup to Markdown did not go very well.
There were two main classes of problem:

- pandoc appears to hate code blocks, and has done some very weird things.
- MediaWiki appears to have refused to render the giant Application template, so
  a lot of the application pages converted to no content.

Unfortunately this means that a lot of manual editing is necessary:

- Code blocks need to have their extra single-line backticks removed and be
  correctedly marked-up with backtick fences (\`\`\`). Language will be inferred
  from shebang lines, but otherwise you might want to add the language if it's a
  Python or bash script block. In many cases it's quicker to copy/paste the code
  from the corresponding original mediawiki page source.
- Application pages that haven't rendered need to be manually converted.
  Thankfully, it's not *that* much work, but there are a lot of them and some of
  them are functional duplicates of other pages.

Some pages need non-trivial changes, in most cases because they're extremely
out-of-date. I've put these in `needs_work` directories.

Remember to use `git rm` to remove pages that you're deleting from the
repository, not just normal `rm`.
