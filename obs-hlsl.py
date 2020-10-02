import os.path
import sys
import re

import jinja2

# for streamfx
# https://github.com/Xaymar/obs-StreamFX/

def convert(src, tmpl):
    uniformre = re.compile(r'uniform\s+(\S+)\s+(\S+)\s*;\s*//\s*=\s*(.+?)\s*;?\s*?$', flags=re.MULTILINE)
    constre = re.compile(r'const\s+\S+\s+(\S+)\s*=\s*(.+?)\s*;\s*?$', flags=re.MULTILINE)
    uniforms = ''

    src = re.sub(r'vec(\d)', r'float\1', src)
    for m in uniformre.findall(src):
        if m[0] == 'float' and m[1] == 'seed':
            # this is handled special
            continue

        init = m[2]
        if init:
            if init.startswith('float'):
                init = init.split('(', 1)[1]
                init = init.rstrip(')')
                init = '{' + init + '}'
            uniforms += 'uniform {0} {1} = {2};\n'.format(m[0], m[1], init)
        else:
            uniforms += 'uniform {0} {1};\n'.format(*m)
    for m in constre.findall(src):
        uniforms += '#define {0} {1}\n'.format(*m)
    src = uniformre.sub('', src)
    src = constre.sub('', src)
    return tmpl.render(body=src, uniforms=uniforms)

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
        o = os.path.join(outdir, n + '.effect')
        print(o)
        with open(i) as ifile:
            with open(o, 'w') as ofile:
                ofile.write(convert(ifile.read(), tmpl))
