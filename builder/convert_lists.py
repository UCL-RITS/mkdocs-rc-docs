#!/usr/bin/env python

import json
import re
import requests
import mako
import os
import sys
import datetime
from mako.template import Template
from mako.lookup import TemplateLookup
from mako.exceptions import RichTraceback
from collections import namedtuple

PackagePageFactory = namedtuple("PackagePage", ["datafile", "template", "output"])

pages_to_render = [
    PackagePageFactory(
        datafile = "r-packages.json",
        template = "r_description.md.mako",
        output =   "r-packages.md",
        ),
    PackagePageFactory(
        datafile = "python-packages.json",
        template = "python_description.md.mako",
        output =   "python-packages.md",
        ),
    PackagePageFactory(
        datafile = "module-packages.json",
        template = "modules_template.md.mako",
        output =   "module-packages.md",
        ),
    ]

url_stem = "https://www.rc.ucl.ac.uk/lists/"

def render_page(page_info, use_local_sources=False):
    try:
        if use_local_sources:
            package_file = open(page_info.datafile)
            package_dict = json.loads(package_file.read())
        else:
            package_dict = requests.get(url_stem + page_info.datafile).json()
    except:
        sys.stderr.write("Error reading package JSON info from \"%s\".\n" % page_info.datafile)
        raise

    package_dict["generated"] = make_friendlier_datetime(package_dict["generated"])

    page_template = get_mako_template(page_info.template)

    # Exception code from: https://docs.makotemplates.org/en/latest/usage.html#handling-exceptions
    try:
        with open(page_info.output, "w") as f:
            f.write(postproc(page_template.render(p=package_dict)))
    except:
        traceback = RichTraceback()
        for (filename, lineno, function, line) in traceback.traceback:
            print("File %s, line %s, in %s" % (filename, lineno, function))
            print(line, "\n")
        print("%s: %s" % (str(traceback.error.__class__.__name__), traceback.error))
        raise

def get_mako_template(name):
    template_dirs = TemplateLookup(directories=[os.environ['MAKO_TEMPLATE_DIR'],"./",'./templates'], preprocessor=preprocs)
    t = template_dirs.get_template(uri="/" + name)
    return t

def make_friendlier_datetime(s):
    dt = datetime.datetime.strptime(s, "%Y-%m-%dT%H:%M:%S%z")
    return dt.strftime("%H:%M:%S (%z) on %m %b %Y")

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

if __name__ == "__main__":
    for p in pages_to_render:
        try:
            render_page(p, use_local_sources=False)
        except:
            sys.stderr.write("Error creating page \"%s\". See traceback for details.\n" % p.output)
            raise
