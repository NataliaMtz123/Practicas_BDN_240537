import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';
export default defineConfig({
 plugins:[react(),tailwindcss()],
 base:'/Practicas_BDN_240537/modelo-eer-2710/',
 build:{rollupOptions:{output:{manualChunks:{
   core:['react','react-dom/client','react/jsx-runtime'],flow:['@xyflow/react'],motion:['motion/react'],layout:['@dagrejs/dagre'],export:['html-to-image'],
 }}}},
});
