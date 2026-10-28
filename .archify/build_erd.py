import json, re, pathlib

ROOT = pathlib.Path.cwd()
SQL = ROOT / 'Practica03/backups/respaldo_1410.sql'
OUT = ROOT / '.archify/erd-respaldo-1410-20261014-180908/candidate.json'
MODEL_OUT = OUT.parent / 'model.json'
text = SQL.read_text(encoding='utf-8', errors='replace')

def split_top(s):
    out=[]; start=0; depth=0; quote=None; i=0
    while i<len(s):
        c=s[i]
        if quote:
            if c=='\\': i+=2; continue
            if c==quote:
                if i+1<len(s) and s[i+1]==quote: i+=2; continue
                quote=None
        elif c in "'\"`": quote=c
        elif c=='(': depth+=1
        elif c==')': depth-=1
        elif c==',' and depth==0: out.append(s[start:i].strip()); start=i+1
        i+=1
    out.append(s[start:].strip())
    return out

def closing_paren(s, start):
    depth=0; quote=None; i=start
    while i<len(s):
        c=s[i]
        if quote:
            if c=='\\': i+=2; continue
            if c==quote:
                if i+1<len(s) and s[i+1]==quote: i+=2; continue
                quote=None
        elif c in "'\"`": quote=c
        elif c=='(': depth+=1
        elif c==')':
            depth-=1
            if depth==0:return i
        i+=1
    raise ValueError('Unclosed SQL parenthesis')

tables={}; order=[]
pat=re.compile(r'CREATE TABLE\s+`([^`]+)`\s*\(', re.I)
for m in pat.finditer(text):
    name=m.group(1); end=closing_paren(text,m.end()-1); body=text[m.end():end]
    t={'name':name,'columns':[],'indexes':[],'fks':[],'checks':[],'engine':'InnoDB'}
    for part in split_top(body):
        if not part:continue
        cm=re.match(r'`([^`]+)`\s+(.+)',part,re.S)
        if cm:
            col,decl=cm.groups(); t['columns'].append({'name':col,'decl':decl.strip()}); continue
        pk=re.match(r'PRIMARY KEY\s*\((.*?)\)',part,re.I|re.S)
        if pk: t['pk']=[x.strip().strip('`') for x in split_top(pk.group(1))]; continue
        fk=re.match(r'(?:CONSTRAINT\s+`([^`]+)`\s+)?FOREIGN KEY\s*\((.*?)\)\s+REFERENCES\s+`([^`]+)`\s*\((.*?)\)(.*)',part,re.I|re.S)
        if fk:
            cn,src,dst,dcols,tail=fk.groups()
            t['fks'].append({'name':cn or '','columns':[x.strip().strip('`') for x in split_top(src)],'table':dst,'references':[x.strip().strip('`') for x in split_top(dcols)],'delete':(re.search(r'ON DELETE\s+(CASCADE|SET NULL|RESTRICT|NO ACTION|SET DEFAULT)',tail,re.I) or [None,''])[1].upper(),'update':(re.search(r'ON UPDATE\s+(CASCADE|SET NULL|RESTRICT|NO ACTION|SET DEFAULT)',tail,re.I) or [None,''])[1].upper()}); continue
        idx=re.match(r'(?:CONSTRAINT\s+`([^`]+)`\s+)?(UNIQUE KEY|UNIQUE INDEX|KEY|INDEX)\s*`?([^` (]+)?`?\s*\((.*?)\)',part,re.I|re.S)
        if idx:
            cn,kind,ixname,cols=idx.groups(); t['indexes'].append({'name':ixname or cn or kind,'unique':kind.upper().startswith('UNIQUE'),'columns':[x.strip().strip('`').split(' ')[0] for x in split_top(cols)]}); continue
        ck=re.match(r'(?:CONSTRAINT\s+`([^`]+)`\s+)?CHECK\s*\((.*)\)',part,re.I|re.S)
        if ck:t['checks'].append(part);continue
    trailer=text[end+1:end+500]
    eng=re.search(r'\bENGINE\s*=\s*(\w+)',trailer,re.I)
    if eng:t['engine']=eng.group(1)
    tables[name]=t; order.append(name)
for t in tables.values():
    for ix in t['indexes']:
        if ix['unique'] and len(ix['columns'])==1:
            for col in ix['columns']:
                for c in t['columns']:
                    if c['name']==col:c.setdefault('keys',[]).append('uk')
    for c in t['columns']:
        if c['name'] in t.get('pk',[]):c.setdefault('keys',[]).append('pk')
    for fk in t['fks']:
        for col in fk['columns']:
            for c in t['columns']:
                if c['name']==col:c.setdefault('keys',[]).append('fk')

# Count actual top-level value tuples in INSERT/REPLACE statements, lexing quotes,
# comments and parentheses so commas and parentheses inside values are ignored.
counts={n:0 for n in tables}; uncertain=[]
insert_re=re.compile(r'\b(INSERT\s+(?:IGNORE\s+)?INTO|REPLACE\s+INTO)\s+`([^`]+)`(?:\s*\([^;]*?\))?\s+VALUES\s*',re.I)
for m in insert_re.finditer(text):
    table=m.group(2)
    if table not in counts:continue
    i=m.end(); depth=0; quote=None; line_comment=False; block=False; tuples=0
    while i<len(text):
        c=text[i]; nxt=text[i+1] if i+1<len(text) else ''
        if line_comment:
            if c=='\n':line_comment=False
        elif block:
            if c=='*' and nxt=='/':block=False;i+=2;continue
        elif quote:
            if c=='\\':i+=2;continue
            if c==quote:
                if nxt==quote:i+=2;continue
                quote=None
        elif c in "'\"`":quote=c
        elif c=='-' and nxt=='-' and (i+2==len(text) or text[i+2].isspace()):line_comment=True;i+=2;continue
        elif c=='#':line_comment=True
        elif c=='/' and nxt=='*':block=True;i+=2;continue
        elif c=='(':
            if depth==0:tuples+=1
            depth+=1
        elif c==')':depth-=1
        elif c==';' and depth==0:break
        i+=1
    counts[table]+=tuples

domains={
 'Carritos':['tb_carts','tbd_cart_items'],
 'Catálogo':['tb_products','tbc_categories','tbd_products_categories','tbd_products_users_providers','tbd_users_wishlist_products'],
 'Pedidos y pagos':['tbb_orders','tb_seller_orders','tbd_order_items','tb_payments','tb_payment_transactions'],
 'Usuarios y auditoría':['tb_users','tb_logs']}
domain_by_table={n:d for d,ns in domains.items() for n in ns}
pos={}; col=0
for d,ns in domains.items():
    for row,n in enumerate(ns):pos[n]=(row,col)
    col+=1
entities=[]; rels=[]
for name in order:
    t=tables[name]; line=text.count('\n',0,text.find('CREATE TABLE `'+name+'`'))+1
    fkc=sum(len(f['columns']) for f in t['fks'])
    ent={'id':name,'label':name,'tag':domain_by_table[name], 'row':pos[name][0],'col':pos[name][1],
         'sublabel':f"{len(t['columns'])} columnas · {1 if t.get('pk') else 0} PK · {len(t['fks'])} FK · snapshot SQL: {counts[name]:,} filas",
         'sources':[{'path':'Practica03/backups/respaldo_1410.sql','line':line,'label':'CREATE TABLE'}],
         'attributes':[]}
    for ix,c in enumerate(t['columns'],1):
        a={'name':c['name'],'type':c['decl']}
        if c.get('keys'):
            a['key']=c['keys'] if len(c['keys'])>1 else c['keys'][0]
        for fk in t['fks']:
            if c['name'] in fk['columns']:
                j=fk['columns'].index(c['name']); a['references']=fk['table']+'.'+fk['references'][j]; break
        ent['attributes'].append(a)
    entities.append(ent)
    for fi,fk in enumerate(t['fks']):
        parent=tables[fk['table']]
        unique=any(ix['unique'] and ix['columns']==fk['columns'] for ix in t['indexes'])
        optional=any(re.search(r'\bNULL\b',next(c['decl'] for c in t['columns'] if c['name']==cn),re.I) and not re.search(r'\bNOT NULL\b',next(c['decl'] for c in t['columns'] if c['name']==cn),re.I) for cn in fk['columns'])
        label=(fk['name']+': ' if fk['name'] else '')+', '.join(fk['columns'])+' → '+', '.join(fk['references'])
        actions=[]
        if fk['delete']:actions.append('ON DELETE '+fk['delete'])
        if fk['update']:actions.append('ON UPDATE '+fk['update'])
        if actions:label+=' · '+' / '.join(actions)
        rels.append({'id':'rel_'+name+'_'+str(fi+1),'from':name,'to':fk['table'],'label':label,
                     'constraint':fk['name'],'columns':fk['columns'],'references':fk['references'],
                     'onDelete':fk['delete'],'onUpdate':fk['update'],'optional':optional,
                     'fromCardinality':'one' if unique else 'many','toCardinality':'one',
                     'fromOptional':optional,'identifying':all(cn in t.get('pk',[]) for cn in fk['columns']),
                     **({'variant':'dashed'} if not all(cn in t.get('pk',[]) for cn in fk['columns']) else {})})

assert len(entities)==len(tables)
assert all(fk['table'] in tables for t in tables.values() for fk in t['fks'])
inserted=sum(counts.values())
procedure_names=re.findall(r'CREATE\s+DEFINER\s*=.*?\s+PROCEDURE\s+`([^`]+)`',text,re.I|re.S)
index_total=sum(len(t['indexes']) for t in tables.values())
cards=[
 {'dot':'cyan','title':'Alcance del respaldo','items':['Archivo: Practica03/backups/respaldo_1410.sql','Esquema: db_test · MySQL 8.0.36 · motor de las tablas: '+', '.join(sorted(set(t['engine'] for t in tables.values()))),f'{len(tables)} tablas · {sum(len(t["columns"]) for t in tables.values())} columnas · {sum(len(t.get("pk",[]))>0 for t in tables.values())} claves primarias · {sum(len(t["fks"]) for t in tables.values())} claves foráneas',f'{index_total} índices definidos · {len(rels)} relaciones explícitas · 0 relaciones inferidas',f'{inserted:,} filas cargadas en el snapshot sumando las tablas; no son conteos de una base viva']},
 {'dot':'emerald','title':'Conteo del snapshot SQL','items':[f'{n}: {v:,} filas insertadas' for n,v in counts.items() if v>0]+[f'{n}: 0 filas insertadas en el respaldo' for n,v in counts.items() if v==0]},
 {'dot':'violet','title':'Objetos y límites','items':['La fuente contiene CREATE TABLE, INSERT INTO y un procedimiento almacenado: '+(', '.join(procedure_names) if procedure_names else 'ninguno detectado')+'.','No se ejecutó SQL. Los conteos se calcularon contando tuplas de INSERT INTO del dump completo.','Los detalles de cada columna conservan la declaración SQL original (tipo, NULL, DEFAULT, charset/collation, AUTO_INCREMENT, ON UPDATE y atributos).','Las relaciones mostradas proceden únicamente de FOREIGN KEY explícitas; ninguna relación fue inferida.']}
]
candidate_rels=[{k:r[k] for k in ('id','from','to','label','fromCardinality','toCardinality','fromOptional','identifying','variant') if k in r} for r in rels]
candidate={'schema_version':1,'diagram_type':'erd','meta':{'title':'Modelo EER · db_test','locale':'es','output':'.archify/erd-respaldo-1410-20261014-180908/erd-respaldo-1410.html','quality_profile':'standard','views':[{'id':'carritos','label':'Carritos','focus':domains['Carritos']},{'id':'catalogo','label':'Catálogo','focus':domains['Catálogo']},{'id':'pedidos','label':'Pedidos y pagos','focus':domains['Pedidos y pagos']},{'id':'usuarios','label':'Usuarios','focus':domains['Usuarios y auditoría']}]},'layout':{'mode':'grid','gapX':90,'gapY':60},'entities':entities,'relationships':candidate_rels,'cards':cards}
OUT.parent.mkdir(parents=True,exist_ok=True)
OUT.write_text(json.dumps(candidate,ensure_ascii=False,indent=2),encoding='utf-8')
model={'file':'respaldo_1410.sql','schema':'db_test','engine':'MySQL 8.0.36','processedAt':'2026-10-14','tables':[tables[n] for n in order],'counts':counts,'relationships':rels,'inferredRelationships':[],'totals':{'tables':len(tables),'columns':sum(len(t['columns']) for t in tables.values()),'foreignKeys':sum(len(t['fks']) for t in tables.values()),'primaryKeys':sum(bool(t.get('pk')) for t in tables.values()),'indexes':index_total,'rows':inserted,'availableCounts':len(counts),'unavailableCounts':0},'objects':{'procedures':procedure_names,'views':[],'triggers':[],'functions':[],'events':[],'checks':[]},'warnings':['Los conteos representan las filas presentes en las sentencias INSERT del respaldo, no el estado actual de un servidor MySQL.','El archivo se analizó como texto; no se ejecutaron sentencias SQL.']}
MODEL_OUT.write_text(json.dumps(model,ensure_ascii=False,indent=2),encoding='utf-8')
template=OUT.parent/'app-template.html'
app=OUT.parent/'erd-respaldo-1410.html'
safe_model=json.dumps(model,ensure_ascii=False,separators=(',',':')).replace('<','\\u003c').replace('>','\\u003e').replace('&','\\u0026')
app_source=template.read_text(encoding='utf-8')
app_source=app_source.replace('${t.pk?.length||0} PK · ${t.fks.reduce((n,f)=>n+f.columns.length,0)} FK','${t.pk?.length?1:0} PK · ${t.fks.length} FK')
app_source=app_source.replace('${t.pk?.length||0} columnas PK · ${t.fks.reduce((n,f)=>n+f.columns.length,0)} columnas FK','${t.pk?.length?1:0} PK · ${t.fks.length} FK')
app_source=app_source.replace('ix.some(x=>x.unique)||false','ix.some(x=>x.unique&&x.columns.length===1)||false')
app_source=app_source.replace('initLayout();M.tables.forEach(t=>{const domain=','M.tables.forEach(t=>{const domain=')
app_source=app_source.replace('t._col=dIndex;t._row=list.indexOf(t)});\nconst domainSelect=','t._col=dIndex;t._row=list.indexOf(t)});initLayout();\nconst domainSelect=')
app.write_text(app_source.replace('__MODEL__',safe_model),encoding='utf-8')
print(json.dumps({'tables':len(tables),'columns':sum(len(t['columns']) for t in tables.values()),'fks':sum(len(t['fks']) for t in tables.values()),'indexes':index_total,'rows':inserted,'counts':counts,'procedures':procedure_names,'candidate':str(OUT),'model':str(MODEL_OUT),'html':str(app)},ensure_ascii=False,indent=2))
