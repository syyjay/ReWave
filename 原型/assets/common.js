/* ============================================================
   ReWave 原型 · 公共脚本
   波形渲染：为每个 .wave 容器按 data-seed 生成确定性随机波形
   data-seed  种子（相同种子渲染相同波形）
   data-bars  柱条数量（默认按容器宽度自适应）
   ============================================================ */
function mulberry32(a) {
  return function () {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function renderWaves(root) {
  (root || document).querySelectorAll('.wave').forEach(function (w) {
    if (w.dataset.rendered) return;
    const seed = parseInt(w.dataset.seed || '7', 10);
    const n = parseInt(w.dataset.bars || '0', 10) || Math.max(16, Math.floor(w.clientWidth / 5));
    const rnd = mulberry32(seed);
    const arr = [];
    for (let i = 0; i < n; i++) arr.push(rnd());
    // 邻近平滑，让波形更自然
    for (let pass = 0; pass < 2; pass++) {
      for (let i = 1; i < n - 1; i++) {
        arr[i] = (arr[i - 1] + arr[i] * 2 + arr[i + 1]) / 4;
      }
    }
    const frag = document.createDocumentFragment();
    arr.forEach(function (v) {
      const h = Math.max(8, Math.round(v * 100));
      const s = document.createElement('span');
      s.style.height = h + '%';
      frag.appendChild(s);
    });
    w.innerHTML = '';
    w.appendChild(frag);
    w.dataset.rendered = '1';
  });
}

document.addEventListener('DOMContentLoaded', function () {
  renderWaves();
  // 容器尺寸变化后重绘一次（如 iframe 内首次布局）
  setTimeout(renderWaves, 60);
});
