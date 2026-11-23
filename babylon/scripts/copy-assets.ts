// npm run assets (runs before dev/build): copies the Flutter app's sprites unchanged
// into public/sprites/ (gitignored), so the web never keeps a second copy in git.
import { cpSync, rmSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const src = fileURLToPath(new URL('../../rattleramp/assets/sprites/', import.meta.url));
const dst = fileURLToPath(new URL('../public/sprites/', import.meta.url));
rmSync(dst, { recursive: true, force: true });
cpSync(src, dst, { recursive: true, filter: (p) => !p.endsWith('.DS_Store') });
console.log(`copied sprites → ${dst}`);
