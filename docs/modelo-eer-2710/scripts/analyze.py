"""Read-only, dump-specific MySQL static analysis. Never executes SQL or exports rows.

Tokenization honors escaped/doubled strings, comments, versioned comments and
DELIMITER blocks. Unsupported schema/data operations fail closed, never guess.
The previous dictionary supplies functional descriptions only after DDL equality.
"""
from pathlib import Path
import re, json, hashlib, collections

ROOT = Path(__file__).resolve().parents[2]
APP = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'Practica03/backups/Respaldo_2710.sql'
TOKEN = re.compile(r"'(?:\\.|''|[^'\\])*'|\"(?:\\.|\"\"|[^\"\\])*\"|`(?:``|[^`])*`|/\*![0-9]*\s*([\s\S]*?)\*/|/\*[\s\S]*?\*/|--[^\n]*|\#[^\n]*|\s+|[A-Za-z_][\w$]*|\d+(?:\.\d+)?|.")

def tokens(text):
    for m in TOKEN.finditer(text):
        v=m.group()
        if v.startswith('/*!'): yield from tokens(m[1])
        elif v.isspace() or v.startswith(('/*','--','#')): continue
        else: yield v

def statements(text):
    delimiter=';'; buf=[]; start=1
    # DELIMITER is a client directive, only recognized at the beginning of a line.
    for number,line in enumerate(text.splitlines(keepends=True),1):
        if line.strip().upper().startswith('DELIMITER '):
            assert not buf, 'Incomplete statement before delimiter'
            delimiter=line.split()[1]; continue
        if not buf: start=number
        buf.append(line)
        # MySQL dump statements end at a line boundary; literals are checked below.
        if line.rstrip().endswith(delimiter):
            body=''.join(buf).rstrip()[:-len(delimiter)]
            ts=list(tokens(body)); buf=[]
            if ts: yield start,body,ts
        elif not list(tokens(line)) and len(buf)==1: buf=[]
    assert not list(tokens(''.join(buf))), 'Unterminated SQL statement'

def split_top(text):
    result=[]; group=[]; depth=0
    for t in tokens(text):
        if t==',' and depth==0: result.append(' '.join(group)); group=[]; continue
        group.append(t)
        if t=='(': depth+=1
        if t==')': depth-=1
    if group: result.append(' '.join(group))
    assert depth==0
    return result

def analyze():
    original=SOURCE.read_bytes(); text=original.decode('utf-8-sig'); digest=hashlib.sha256(original).hexdigest()
    previous=json.loads((ROOT/'Practica03/docs/VALIDACION_respaldo_2710.json').read_text(encoding='utf-8'))
    tables={}; counts=collections.Counter(); operations=collections.Counter(); objects={}; schema=None; unsupported=[]; insert_statements=collections.Counter()
    for line,body,ts in statements(text):
        upper=[t.upper() for t in ts]; op=upper[0]; operations[op]+=1
        if op=='USE': schema=ts[1].strip('`')
        if upper[:2]==['CREATE','TABLE']:
            name=ts[2].strip('`'); match=re.search(r'CREATE TABLE `[^`]+`\s*\((.*)\)\s*ENGINE=',body,re.S)
            assert match, 'Unsupported CREATE TABLE'
            old=next(t for t in previous['tablas'] if t['name']==name)
            # Compare token streams including all column/constraint definitions.
            assert list(tokens(old['ddl']))[:-1]==ts, 'Dictionary DDL mismatch: '+name
            parsed=split_top(match[1]); cols=[p.split()[0].strip('`') for p in parsed if p.startswith('`')]
            assert cols==[c['name'] for c in old['cols']]
            tables[name]={**old}; counts[name]=0
        elif op in ('INSERT','REPLACE'):
            assert upper[1]=='INTO' and 'VALUES' in upper, 'Unsupported insertion'
            name=ts[2].strip('`'); assert name in tables
            values=ts[upper.index('VALUES')+1:]; depth=0; rows=0
            for t in values:
                if t=='(':
                    if depth==0: rows+=1
                    depth+=1
                elif t==')': depth-=1
                elif depth==0: assert t==',', 'Unsupported insert suffix'
            assert depth==0
            # REPLACE needs unique-key conflict reconstruction; never count blindly.
            if op=='REPLACE': unsupported.append({'line':line,'operation':op,'table':name})
            else: counts[name]+=rows; insert_statements[name]+=1
        elif op=='ALTER':
            assert re.fullmatch(r'ALTER TABLE `[^`]+` (?:DISABLE|ENABLE) KEYS', ' '.join(ts)), 'Unsupported ALTER'
        elif op in ('DELETE','UPDATE','TRUNCATE','CALL','LOAD','RENAME'):
            unsupported.append({'line':line,'operation':op})
        elif op=='CREATE':
            for kind in ['TRIGGER','PROCEDURE','FUNCTION','VIEW']:
                if kind in upper:
                    i=upper.index(kind); name=ts[i+1].strip('`')
                    # Final view definition replaces its temporary placeholder.
                    objects[(kind,name)]={'type':kind,'name':name,'line':line}
                    break
            else: assert upper[1]=='DATABASE', 'Unsupported CREATE'
        elif op=='DROP':
            assert upper[1] in ('TABLE','VIEW','PROCEDURE','FUNCTION','TRIGGER'), 'Unsupported DROP'
        else: assert op in ('SET','LOCK','UNLOCK','USE'), 'Unrecognized statement: '+op
    assert schema==previous['base'] and len(tables)==len(previous['tablas'])
    assert not unsupported, 'Unsupported data mutations: '+str(unsupported)
    assert dict(counts)==previous['filas_INSERT_por_tabla'], 'Independent row count mismatch'
    relationships=[]
    for t in tables.values():
        t['columns']=[]
        for c in t.pop('cols'):
            a=next(a for a in previous['atributos'] if a['tabla']==t['name'] and a['atributo']==c['name'])
            size=re.search(r'\((\d+)(?:,(\d+))?\)',c['type'])
            numeric=bool(re.match(r'(decimal|numeric|float|double)',c['type'],re.I))
            t['columns'].append({**c,'ordinal':a['posicion'],'description':a['descripcion'],'classification':a['clasificacion'],'nature':a['naturaleza_justificada'],'domain':a['dominio_tecnico'],'functionalDomain':a['dominio_negocio'],'pk':a['pk'],'unique':a['unique'],'length':int(size[1]) if size and not numeric else None,'precision':int(size[1]) if size and numeric else None,'scale':int(size[2]) if size and size[2] and numeric else None,'conceptual':'Simple y monovalorado en representación relacional; semántica conceptual pendiente. '+('Derivado (GENERATED declarado)' if 'GENERATED' in c['raw'] else 'Almacenado; derivación funcional no demostrada.'),'allowed':re.findall(r"'((?:\\.|[^'])*)'",c['type']) if c['type'].lower().startswith(('enum','set')) else []})
        t.pop('ddl'); t['count']=counts[t['name']]; t['countStatus']='exact'; t['countSource']='Reconstruido del respaldo'; t['insertStatements']=insert_statements[t['name']]
        t['category']='Auditoría' if 'logs' in t['name'] else 'Asociativa' if len(t['pk'])>1 else 'Catálogo' if t['name'].startswith('tbc_') else 'Entidad'
        t['categoryEvidence']='Inferida por nombre y estructura; no declaración conceptual SQL'
        for f in t['fks']:
            unique=any(ix[1] in ('PK','UNIQUE') and set(ix[2])<=set(f['cols']) for ix in t['indexes'])
            optional=any(next(c for c in t['columns'] if c['name']==n)['null'] for n in f['cols'])
            identifying=set(f['cols'])<=set(t['pk'])
            relationships.append({**f,'id':f['source']+':'+f['name'],'confirmed':True,'optional':optional,'unique':unique,'identifying':identifying,'cardinality':('0..1' if unique else '0..N')+' hijos por padre; '+('0..1' if optional else '1')+' padre por hijo'})
    # Conservative, explicitly opt-in conceptual candidates, only where no FK exists.
    for source,col,target in [('tbd_carts_items','cart_ID','tb_carts'),('tbd_carts_items','provider_ID','tb_users'),('tbd_carts_items','product_ID','tb_products'),('tbd_users_wishlist_products','user_ID','tb_users'),('tbd_users_wishlist_products','product_ID','tb_products')]:
        relationships.append({'id':'inferred:'+source+':'+col,'name':'Hipótesis por nombre y PK compuesta','source':source,'cols':[col],'target':target,'refs':['ID'],'confirmed':False,'optional':False,'unique':False,'identifying':False,'cardinality':'N:1 propuesta; pendiente de validación','DELETE':'Sin integridad declarada','UPDATE':'Sin integridad declarada','evidence':'Nombre de columna y estructura asociativa; no equivale a una FK. Comparar tipos antes de implementarla.'})
    missing=sorted({dep for o in previous['objetos'] for dep in o['dependencias'] if dep not in tables and dep.startswith(('tb','w_'))})
    result={'schema':schema,'source':SOURCE.name,'sha256':digest,'method':'Análisis estático completo; no se ejecutó SQL. Conteos de tuplas VALUES fuera de literales y rutinas. CREATE TABLE inicializa tablas vacías; no hay mutaciones de datos posteriores fuera de rutinas. Los cuerpos de triggers no se ejecutan ni cuentan como filas.','limits':previous['limite'],'tables':list(tables.values()),'relationships':relationships,'objects':list(objects.values()),'warnings':previous['pendientes'],'missingDependencies':missing,'statementInventory':dict(operations),'statistics':{'tables':len(tables),'columns':sum(len(t['columns']) for t in tables.values()),'records':sum(counts.values()),'foreignKeys':sum(len(t['fks']) for t in tables.values()),'primaryKeys':sum(bool(t['pk']) for t in tables.values()),'indexes':sum(len(t['indexes']) for t in tables.values()),'checks':sum(len(t['checks']) for t in tables.values()),'objects':len(objects),'inferred':5}}
    assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==digest
    (APP/'src/data/model.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps(result['statistics']))

if __name__=='__main__': analyze()
