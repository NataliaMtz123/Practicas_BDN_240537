import { memo } from 'react';
import { Handle, Position, type NodeProps, type Node } from '@xyflow/react';
import { Database, KeyRound, Link2, ChevronDown, ChevronUp, Check, Layers } from 'lucide-react';
import { type Table,fmt } from '../model';
export type TableData={table:Table;expanded:boolean;dim:boolean;active:boolean;degree:number;fkColumns:string[];toggle:(id:string)=>void};
export type TableFlowNode=Node<TableData,'table'>;
export const TableNode=memo(function TableNode({id,data}:NodeProps<TableFlowNode>){const t=data.table;const shown=data.expanded?t.columns:t.columns.filter(c=>c.pk||data.fkColumns.includes(c.name)).slice(0,5);return <article className={`table-node ${data.active?'active':''} ${data.dim?'dim':''}`} data-category={t.category}>
  <Handle type="target" position={Position.Left}/><Handle type="source" position={Position.Right}/>
  <div className="node-top"><span className="node-icon">{t.category==='Asociativa'?<Layers size={16}/>:<Database size={16}/>}</span><div className="node-title"><strong>{t.name}</strong><span>{t.category} <span title={t.categoryEvidence}>· inferida</span></span></div><button aria-label={`${data.expanded?'Contraer':'Expandir'} ${t.name}`} className="nodrag icon-button" onClick={()=>data.toggle(id)}>{data.expanded?<ChevronUp size={15}/>:<ChevronDown size={15}/>}</button></div>
  <div className="node-count"><strong>{fmt(t.count)}</strong> registros <span title="Conteo exacto de tuplas del respaldo"><Check size={11}/> Respaldo · exacto</span></div>
  <div className="node-columns">{shown.map(c=><div key={c.name} className="node-column"><span className={`column-key ${c.pk?'pk':data.fkColumns.includes(c.name)?'fk':''}`}>{c.pk?<KeyRound size={12}/>:data.fkColumns.includes(c.name)?<Link2 size={12}/>:<span>·</span>}</span><span className="column-name">{c.name}</span><code>{c.type}</code></div>)}</div>
  <div className="node-footer"><span>{t.columns.length} atributos</span><span><Link2 size={11}/>{data.degree} relaciones</span></div>
 </article>});
