import { test,expect } from '@playwright/test';
test('explores real metadata, filters, attributes, dependencies and exports',async({page})=>{
 const errors:string[]=[];page.on('pageerror',e=>errors.push(e.message));await page.goto('');
 await expect(page.locator('.react-flow__node')).toHaveCount(25);
 await expect(page.locator('.react-flow__edge')).toHaveCount(32);
 await expect(page.locator('.metric').last()).toContainText('128,459');
 await page.getByLabel('Buscar tablas, columnas, tipos o claves').fill('latitude');
 await expect(page.locator('.table-list-item')).toHaveCount(1);
 await page.getByLabel('Limpiar búsqueda').click();
 await page.getByLabel('Filtrar entidades').selectOption('Auditoría');
 await expect(page.locator('.table-list-item')).toHaveCount(1);
 await page.getByLabel('Filtrar entidades').selectOption('Todas');
 await page.locator('.table-list-item').filter({hasText:'tb_users'}).click();
 await page.locator('.attribute').filter({hasText:'ID'}).first().locator('summary').click();
 await expect(page.locator('.attribute[open]')).toContainText('AUTO_INCREMENT');
 await page.getByLabel('Destino de ruta').selectOption('tb_products');
 await expect(page.locator('.route-result')).toContainText('tbd_products_users_providers');
 await page.getByLabel('Limpiar ruta').click();
 await page.getByLabel('Modo enfoque').click();
 await expect(page.locator('.react-flow__node')).not.toHaveCount(25);
 await page.getByLabel('Modo enfoque').click();
 await page.getByLabel('Cerrar inspector').click();
 await page.getByLabel('Hipótesis de relaciones').check();
 await expect(page.locator('.react-flow__edge')).toHaveCount(37);
 await page.getByLabel('Centrar diagrama').click();
 await page.locator('.edge-label').first().click();
 await expect(page.locator('.relation-detail')).toContainText('ON DELETE');
 await page.getByLabel('Cerrar inspector').click();
 await page.getByLabel('Expandir tb_users',{exact:true}).click({force:true});
 await expect(page.locator('[data-id="tb_users"] .node-column')).toHaveCount(8);
 const before=await page.locator('html').getAttribute('data-theme');await page.getByLabel('Cambiar tema').click();await expect(page.locator('html')).not.toHaveAttribute('data-theme',before!);
 await page.getByRole('button',{name:'Exportar',exact:true}).click();
 const download=page.waitForEvent('download');await page.getByRole('button',{name:'Metadatos JSON'}).click();await expect((await download).suggestedFilename()).toBe('modelo-eer-2710.json');
 await page.getByRole('button',{name:'Resumen del esquema'}).click();await expect(page.getByRole('dialog')).toContainText('25 conteos exactos');await page.keyboard.press('Escape');
 await page.locator('.table-list-item').filter({hasText:'tb_users'}).click();
 await page.screenshot({path:'test-results/desktop.png',fullPage:true});expect(errors).toEqual([]);
});
test('mobile inspector and persisted positions, drag, zoom and image exports',async({page})=>{
 await page.goto('');await page.getByLabel('Cerrar inspector').click();
 await page.getByLabel('Centrar diagrama').click();
 const node=page.locator('[data-id="tb_users"]');const box=await node.boundingBox();expect(box).toBeTruthy();
 if(box){await page.mouse.move(box.x+box.width/2,box.y+12);await page.mouse.down();await page.mouse.move(box.x+box.width/2+70,box.y+42,{steps:12});await page.mouse.up();}
 await expect.poll(()=>page.evaluate(()=>localStorage.getItem('eer2710:positions'))).not.toBeNull();
 const transform=await page.locator('.react-flow__viewport').getAttribute('style');await page.locator('.react-flow__controls-zoomin').click();await expect(page.locator('.react-flow__viewport')).not.toHaveAttribute('style',transform!);
 for(const kind of ['SVG','PNG']){await page.getByRole('button',{name:'Exportar',exact:true}).click();const downloading=page.waitForEvent('download');await page.getByRole('button',{name:'Diagrama '+kind}).click();const file=await downloading;expect(file.suggestedFilename()).toBe('modelo-eer-2710.'+kind.toLowerCase());await file.saveAs('test-results/export.'+kind.toLowerCase());}
 await page.setViewportSize({width:390,height:844});await page.getByLabel('Abrir tablas').click();await page.locator('.table-list-item').filter({hasText:'tb_products'}).first().click();await expect(page.locator('.detail-header')).toContainText('15,010');await page.getByLabel('Cerrar inspector').click();
 await expect(page.locator('.details-panel')).toHaveCount(0);
 await expect.poll(()=>page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth)).toBe(true);await page.screenshot({path:'test-results/mobile.png',fullPage:true});
});
