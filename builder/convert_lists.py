#!/usr/bin/env python

import json
import re
import requests
import mako
import os
from mako.template import Template
from mako.lookup import TemplateLookup
from mako.exceptions import RichTraceback


use_local_sources = False

if use_local_sources:
    r_pack_file = open("r-packages.json")
    p_pack_file = open("python-packages.json")
    m_pack_file = open("module-packages.json")

    r_pack = json.loads(r_pack_file.read())
    p_pack = json.loads(p_pack_file.read())
    m_pack = json.loads(m_pack_file.read())
else:
    url_stem = "https://www.rc.ucl.ac.uk/lists/"
    r_pack = requests.get(url_stem + "r-packages.json").json()
    p_pack = requests.get(url_stem + "python-packages.json").json()
    m_pack = requests.get(url_stem + "module-packages.json").json()


# I *would* manage to pick a templating library that treats ## as a comment C_C
# Fortunately you can pass a pre-processing function to handle it
def preprocs(s):
    s = guard_comments(s)
    return s

def postproc(s):
    # Had a use for this but it turned out to be an intractable problem
    # So now it's for future use
    return s

def guard_comments(s):
    s = re.sub("^([ \\t]*)(##+) ", "\\1${'\\2'} ", s, flags=re.MULTILINE)
    return s

template_dirs = TemplateLookup(directories=[os.environ['MAKO_TEMPLATE_DIR'],"./",'./templates'], preprocessor=preprocs)

r_t = template_dirs.get_template(uri="/r_description.md.mako")
p_t = template_dirs.get_template(uri="/python_description.md.mako")
m_t = template_dirs.get_template(uri="/modules_template.md.mako")

# Exception code from: https://docs.makotemplates.org/en/latest/usage.html#handling-exceptions
try:
    with open("r-packages.md", "w") as f:
        f.write(postproc(r_t.render(p=r_pack)))
    with open("python-packages.md", "w") as f:
        f.write(postproc(p_t.render(p=p_pack)))
    with open("module-packages.md", "w") as f:
        f.write(postproc(m_t.render(m=m_pack)))
except:
    traceback = RichTraceback()
    for (filename, lineno, function, line) in traceback.traceback:
        print("File %s, line %s, in %s" % (filename, lineno, function))
        print(line, "\n")
    print("%s: %s" % (str(traceback.error.__class__.__name__), traceback.error))
