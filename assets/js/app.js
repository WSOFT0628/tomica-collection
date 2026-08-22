const cars=[
 {id:'fairlady',number:'Event Model No.08',chassis:'No.58',name:'Nissan Fairlady 240ZG Patrol Car',series:'Tomica Event Model',origin:'中國製',condition:'良好',package:'有盒・待確認原配',status:'待查證',accent:'red',icon:'🚓'},
 {id:'cosmo',number:'Event Model ★★ No.21',chassis:'明確無編號',name:'Mazda Cosmo Sport',series:'Tomica Event Model',origin:'越南製',condition:'近新品',package:'有盒・確認原配',status:'已確認',accent:'blue',icon:'🏎️'},
 {id:'freed',number:'No.84',chassis:'No.84',name:'Honda Freed',series:'Tomica Standard',origin:'越南製',condition:'良好',package:'散車',status:'待補照片',accent:'silver',icon:'🚙'}
];
const $=s=>document.querySelector(s),$$=s=>[...document.querySelectorAll(s)];
function go(view){$$('.view').forEach(v=>v.classList.toggle('active',v.id===view));$$('.sidebar nav button[data-view]').forEach(b=>b.classList.toggle('active',b.dataset.view===view));scrollTo({top:0,behavior:'smooth'});}
function tag(c){return `<em class="tag ${c.status==='已確認'?'ok':'warn'}">${c.status}</em>`}
function row(c){return `<button class="car-row" data-view="detail"><span class="visual ${c.accent}"><span>${c.icon}</span></span><span class="car-info"><b>${c.number}</b><strong>${c.name}</strong><small>底盤刻印 ${c.chassis} · ${c.package}</small></span>${tag(c)}<time>今天</time><b>›</b></button>`}
function card(c){return `<article class="card" data-view="detail"><div class="card-photo ${c.accent}"><span>${c.icon}</span><em>${c.status}</em></div><div class="card-body"><b>${c.number}</b><h2>${c.name}</h2><p>${c.series}</p><dl><div><dt>底盤刻印</dt><dd>${c.chassis}</dd></div><div><dt>包裝</dt><dd>${c.package}</dd></div></dl><footer><span>${c.condition}</span><time>更新於今天</time></footer></div></article>`}
function model(c){return `<tr><td><b>${c.name}</b><small>${c.origin}</small></td><td>${c.series}</td><td><strong>${c.number}</strong></td><td>${c.chassis}</td><td>1 件</td><td>${tag(c)}</td></tr>`}
function render(list=cars){$('#recent-list').innerHTML=cars.slice(0,2).map(row).join('');$('#collection-grid').innerHTML=list.map(card).join('');$('#model-rows').innerHTML=cars.map(model).join('');$('#empty').classList.toggle('show',!list.length);bindViews();}
function bindViews(){$$('[data-view]').forEach(b=>{b.onclick=()=>go(b.dataset.view)})}
function toast(text){const el=$('#toast');el.textContent=text;el.classList.add('show');setTimeout(()=>el.classList.remove('show'),1800)}
$('#search').addEventListener('input',e=>{const q=e.target.value.trim().toLowerCase(),list=cars.filter(c=>`${c.number} ${c.chassis} ${c.name} ${c.series}`.toLowerCase().includes(q));$('#collection-copy').textContent=q?`符合「${e.target.value}」的搜尋結果`:'瀏覽、搜尋與整理每一件實際收藏品。';render(list);if(q)go('collection')});
$('#theme').onclick=()=>{const dark=$('#app').classList.toggle('dark');$('#theme').textContent=dark?'☀':'☾';localStorage.setItem('tomica-theme',dark?'dark':'light')};
if(localStorage.getItem('tomica-theme')==='dark'){$('#app').classList.add('dark');$('#theme').textContent='☀'}
$('#save-draft').onclick=()=>{$('#save-status').textContent='✓ 已暫存於本機';localStorage.setItem('tomica-draft',JSON.stringify(Object.fromEntries(new FormData($('#item-form')))));toast('草稿已儲存')};
$('#item-form').onsubmit=e=>{e.preventDefault();$('#save-status').textContent='✓ 已暫存於本機';toast('第一步資料已儲存')};
$('#export-json').onclick=()=>{const blob=new Blob([JSON.stringify({schema_version:1,exported_at:new Date().toISOString(),cars},null,2)],{type:'application/json'}),a=document.createElement('a');a.href=URL.createObjectURL(blob);a.download='tomica-backup-v1.json';a.click();URL.revokeObjectURL(a.href);toast('備份檔已匯出')};
document.addEventListener('keydown',e=>{if((e.ctrlKey||e.metaKey)&&e.key.toLowerCase()==='k'){e.preventDefault();$('#search').focus()}});
render();
