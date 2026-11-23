// Screen-space backdrop behind the world, one per style (style_paint.dart BackdropComponent).
import { pal, Palette, withAlpha } from './palette';

export function paintBackdrop(g: CanvasRenderingContext2D, w: number, h: number): void {
  g.setTransform(1, 0, 0, 1, 0, 0);
  g.fillStyle = pal().night;
  g.fillRect(0, 0, w, h);
  switch (Palette.style) {
    case 'neon': {
      // Faint perspective floor grid.
      g.strokeStyle = withAlpha(pal().rampEdge, 0.07);
      g.lineWidth = 1;
      g.beginPath();
      for (let i = 1; i < 12; i++) {
        const y = h * (0.55 + 0.45 * Math.pow(i / 12, 1.8));
        g.moveTo(0, y);
        g.lineTo(w, y);
      }
      for (let i = -10; i <= 10; i++) {
        g.moveTo(w / 2 + i * w * 0.02, h * 0.55);
        g.lineTo(w / 2 + i * w * 0.12, h);
      }
      g.stroke();
      break;
    }
    case 'comic': {
      // Sunburst rays + halftone dots, the classic panel background.
      const cx = w / 2, cy = h * 0.45, n = 18, r = w + h;
      g.fillStyle = '#FFE08A';
      for (let i = 0; i < n; i += 2) {
        const a0 = (2 * Math.PI * i) / n, a1 = (2 * Math.PI * (i + 1)) / n;
        g.beginPath();
        g.moveTo(cx, cy);
        g.lineTo(cx + r * Math.cos(a0), cy + r * Math.sin(a0));
        g.lineTo(cx + r * Math.cos(a1), cy + r * Math.sin(a1));
        g.closePath();
        g.fill();
      }
      g.fillStyle = 'rgba(232,50,43,0.133)'; // 0x22E8322B
      const step = 22;
      for (let y = 0; y < h; y += step) {
        const row = Math.round(y / step);
        for (let x = row % 2 === 1 ? step / 2 : 0; x < w; x += step) {
          const k = Math.abs(x / w - 0.5) * 2;
          g.beginPath();
          g.arc(x, y, 2 + 4 * k, 0, Math.PI * 2);
          g.fill();
        }
      }
      break;
    }
    case 'pixel': {
      // Banded sunset sky and a few stars; pixelation does the rest.
      const bands = ['#1D2B53', '#2B2F6B', '#7E2553', '#AB3B61'];
      bands.forEach((c, i) => {
        g.fillStyle = c;
        g.fillRect(0, h * 0.12 * i, w, h);
      });
      g.fillStyle = '#FFF1E8';
      let s = 7; // fixed seed, so the sky doesn't flicker between redraws
      const rnd = (): number => ((s = (s * 1103515245 + 12345) & 0x7fffffff) / 0x80000000);
      for (let i = 0; i < 40; i++) g.fillRect(rnd() * w, rnd() * h * 0.3, 4, 4);
      break;
    }
  }
}
