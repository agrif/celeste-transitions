import os.path
import sys
import re

import jinja2

def convert(src, tmpl):
    src = re.sub(r'vec(\d)', r'float\1', src)
    src = re.sub(r'uniform\s+\S+\s+(\S+)\s*;\s*//\s*=\s*(.+?)\s*;?\s*?$', r'#define \1 \2', src, flags=re.MULTILINE)
    src = re.sub(r'const\s+\S+\s+(\S+)\s*=\s*(.+?)\s*;\s*?$', r'#define \1 \2', src, flags=re.MULTILINE)
    return tmpl.render(body=src)

if __name__ == '__main__':
    base = os.path.split(sys.argv[0])[0]
    loader = jinja2.FileSystemLoader(base)
    env = jinja2.Environment(loader=loader)
    tmpl = env.get_template('obs-template.shader')

    indir = os.path.join(base, 'transitions')
    outdir = os.path.join(base, 'obs')
    for p in os.listdir(indir):
        n, ext = os.path.splitext(p)
        i = os.path.join(indir, p)
        o = os.path.join(outdir, n + '.shader')
        print(o)
        with open(i) as ifile:
            with open(o, 'w') as ofile:
                ofile.write(convert(ifile.read(), tmpl))
