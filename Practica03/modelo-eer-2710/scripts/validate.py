"""Structural and privacy gates for the generated public metadata."""
from pathlib import Path
import json, re,hashlib,collections
APP=Path(__file__).resolve().parents[1]
d=json.loads((APP/'src/data/model.json').read_text(encoding='utf-8'))
tables={t['name']:t for t in d['tables']}
assert len(tables)==25 and sum(len(t['columns']) for t in tables.values())==226
assert sum(t['count'] for t in tables.values())==128459
assert len([r for r in d['relationships'] if r['confirmed']])==32
assert collections.Counter(o['type'] for o in d['objects'])=={'TRIGGER':72,'VIEW':28,'PROCEDURE':3,'FUNCTION':4}
for t in tables.values():
    cols={c['name']:c for c in t['columns']}
    assert len(cols)==len(t['columns'])
    assert [c['ordinal'] for c in t['columns']]==list(range(1,len(cols)+1))
    assert set(t['pk'])<=(cols.keys())
    assert all(c['description'] and c['domain'] and c['nature'] and c['conceptual'] for c in cols.values())
    assert t['countStatus']=='exact'
    for ix in t['indexes']: assert set(ix[2])<=cols.keys()
for r in d['relationships']:
    source=tables[r['source']]; target=tables[r['target']]
    assert set(r['cols'])<={c['name'] for c in source['columns']}
    assert set(r['refs'])<={c['name'] for c in target['columns']}
    if r['confirmed']:
        assert any(ix[1] in ('PK','UNIQUE') and ix[2]==r['refs'] for ix in target['indexes'])
        assert r['unique']==any(ix[1] in ('PK','UNIQUE') and set(ix[2])<=set(r['cols']) for ix in source['indexes'])
public=(APP/'src/data/model.json').read_text(encoding='utf-8')
assert not re.search(r'[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}',public), 'Potential email in metadata'
assert not re.search(r'\$2[aby]\$\d{2}\$|DEFINER\s*=|INSERT INTO.*VALUES',public,re.I), 'Potential data or account export'
source=APP.parent/'Practica03/backups/Respaldo_2710.sql'
assert hashlib.sha256(source.read_bytes()).hexdigest()==d['sha256']
print('PASS: all tables, columns, keys, cardinalities, counts, objects, classification, privacy and source hash.')
