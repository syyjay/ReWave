/* ============================================================
   ReWave 原型 · 公共脚本
   1) 波形渲染：为每个 .wave 容器按 data-seed 生成确定性随机波形
   2) 全局微交互：选段器单选 / 开关 / 滑块点击设值
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

/* ============================================================
   全局微交互（事件委托，所有页面自动生效）
   ============================================================ */
document.addEventListener('click', function (e) {
  // 1) 分组单选：选段器 / 格式块 / 方案卡 / A-B 切换 / AI 工具页签
  const choice = e.target.closest('.seg, .fmt, .fmt-chip, .ab-chip, .plan, .ai-tab');
  if (choice && !choice.hasAttribute('onclick') && !choice.hasAttribute('data-lock')) {
    const group = choice.parentElement;
    group.querySelectorAll('.seg, .fmt, .fmt-chip, .ab-chip, .plan, .ai-tab')
      .forEach(function (x) { x.classList.remove('active'); });
    choice.classList.add('active');
    return;
  }

  // 2) 开关
  const tog = e.target.closest('.toggle');
  if (tog) { tog.classList.toggle('on'); return; }

  // 3) 滑块：点击位置设值
  const slider = e.target.closest('.slider');
  if (slider) {
    const r = slider.getBoundingClientRect();
    const p = Math.min(1, Math.max(0, (e.clientX - r.left) / r.width));
    slider.querySelectorAll('.fill').forEach(function (f) { f.style.width = (p * 100) + '%'; });
    slider.querySelectorAll('.thumb').forEach(function (t) { t.style.left = (p * 100) + '%'; });
    slider.dispatchEvent(new CustomEvent('rwslide', { bubbles: true, detail: { value: p } }));
    return;
  }
});

document.addEventListener('DOMContentLoaded', function () {
  renderWaves();
  setTimeout(renderWaves, 60);
});

/* ============================================================
   参数选择器：rwPick(标题, 选项[], 所在行元素)
   选择后自动更新行内值并关闭
   ============================================================ */
window.rwPick = function (title, options, row, onPick) {
  var phone = document.querySelector('.phone');
  var valEl = row ? (row.querySelector('.mono') || row.querySelector('.t-3')) : null;
  var cur = valEl ? valEl.textContent.trim() : '';
  var ov = document.createElement('div');
  ov.className = 'rw-overlay';
  ov.innerHTML =
    '<div class="rw-sheet" role="dialog">' +
    '<div class="rw-grab"></div>' +
    '<p class="rw-title"></p>' +
    '<div class="rw-options"></div>' +
    '<button class="btn btn-secondary" style="width:100%;margin-top:10px;">取消</button>' +
    '</div>';
  ov.querySelector('.rw-title').textContent = title;
  var list = ov.querySelector('.rw-options');
  options.forEach(function (o) {
    var d = document.createElement('div');
    d.className = 'rw-opt' + (o === cur ? ' active' : '');
    d.innerHTML = '<span></span><i class="fa-solid fa-check"></i>';
    d.querySelector('span').textContent = o;
    d.addEventListener('click', function () {
      if (onPick) { onPick(o); } else if (valEl) { valEl.textContent = o; }
      phone.removeChild(ov);
    });
    list.appendChild(d);
  });
  ov.addEventListener('click', function (e) { if (e.target === ov) phone.removeChild(ov); });
  ov.querySelector('button').addEventListener('click', function () { phone.removeChild(ov); });
  phone.appendChild(ov);
};

/* 确认弹窗：rwConfirm(标题, 说明, 确认文案, onOk) */
window.rwConfirm = function (title, msg, okText, onOk) {
  var phone = document.querySelector('.phone');
  var ov = document.createElement('div');
  ov.className = 'rw-overlay';
  ov.style.alignItems = 'center';
  ov.style.justifyContent = 'center';
  ov.innerHTML =
    '<div class="rw-alert">' +
    '<p class="rw-title"></p>' +
    '<p class="rw-msg"></p>' +
    '<div style="display:flex;gap:10px;">' +
    '<button class="btn btn-secondary" style="flex:1;height:44px;font-size:14px;">取消</button>' +
    '<button class="btn btn-primary" style="flex:1;height:44px;font-size:14px;"></button>' +
    '</div></div>';
  ov.querySelector('.rw-title').textContent = title;
  ov.querySelector('.rw-msg').textContent = msg;
  var ok = ov.querySelectorAll('button')[1];
  ok.textContent = okText || '确定';
  ov.querySelectorAll('button')[0].addEventListener('click', function () { phone.removeChild(ov); });
  ok.addEventListener('click', function () { phone.removeChild(ov); if (onOk) onOk(); });
  ov.addEventListener('click', function (e) { if (e.target === ov) phone.removeChild(ov); });
  phone.appendChild(ov);
};

/* 轻提示：rwToast(文案) */
window.rwToast = function (msg) {
  var phone = document.querySelector('.phone');
  var t = document.createElement('div');
  t.className = 'rw-toast';
  t.textContent = msg;
  phone.appendChild(t);
  setTimeout(function () { phone.removeChild(t); }, 1800);
};

/* PRO 解锁弹窗：rwPro(功能名, 说明) → 「开通 Pro」进订阅页 */
window.rwPro = function (feature, desc) {
  var phone = document.querySelector('.phone');
  var ov = document.createElement('div');
  ov.className = 'rw-overlay';
  ov.style.alignItems = 'center';
  ov.style.justifyContent = 'center';
  ov.innerHTML =
    '<div class="rw-alert">' +
    '<div class="ib g-brand" style="width:52px;height:52px;border-radius:16px;margin:0 auto 12px;box-shadow:var(--rw-shadow-brand);"><i class="fa-solid fa-crown" style="font-size:20px;"></i></div>' +
    '<p class="rw-title"></p>' +
    '<p class="rw-msg"></p>' +
    '<button class="btn btn-primary" style="width:100%;height:46px;font-size:15px;">开通 ReWave Pro</button>' +
    '<button class="btn" style="width:100%;height:36px;margin-top:6px;color:var(--rw-text-tertiary);font-size:13px;">暂不</button>' +
    '</div>';
  ov.querySelector('.rw-title').textContent = feature + ' · Pro 功能';
  ov.querySelector('.rw-msg').textContent = desc || '升级 Pro 解锁全部专业能力。';
  ov.querySelectorAll('button')[0].addEventListener('click', function () { location.href = 'paywall.html'; });
  ov.querySelectorAll('button')[1].addEventListener('click', function () { phone.removeChild(ov); });
  ov.addEventListener('click', function (e) { if (e.target === ov) phone.removeChild(ov); });
  phone.appendChild(ov);
};

/* 处理流程：rwRun(标题, 副标题, 完成文案, [[按钮名, 跳转, 是否主按钮]])
   进度条动画 → 完成态 + 操作按钮；跳转为空则关闭弹层 */
window.rwRun = function (title, sub, doneMsg, actions) {
  var phone = document.querySelector('.phone');
  var ov = document.createElement('div');
  ov.className = 'rw-overlay';
  ov.style.alignItems = 'center';
  ov.style.justifyContent = 'center';
  ov.innerHTML =
    '<div class="rw-run-card">' +
    '<div class="rw-run-ic"><i class="fa-solid fa-spinner fa-spin"></i></div>' +
    '<p class="rw-title" style="margin-top:14px;"></p>' +
    '<p class="rw-msg" style="margin-bottom:0;"></p>' +
    '<div class="rw-prog"><b style="width:0%"></b></div>' +
    '<p class="mono" style="font-size:12px;color:var(--rw-text-tertiary);margin-top:10px;">0%</p>' +
    '</div>';
  ov.querySelector('.rw-title').textContent = title;
  ov.querySelector('.rw-msg').textContent = sub;
  phone.appendChild(ov);
  var bar = ov.querySelector('.rw-prog b'), pct = ov.querySelector('.mono'), v = 0;
  var t = setInterval(function () {
    v = Math.min(100, v + Math.round(5 + Math.random() * 9));
    bar.style.width = v + '%';
    pct.textContent = v + '%';
    if (v >= 100) { clearInterval(t); setTimeout(buildDone, 300); }
  }, 140);

  function buildDone() {
    var card = ov.querySelector('.rw-run-card');
    var html =
      '<div class="ib g-brand" style="width:60px;height:60px;border-radius:18px;margin:0 auto;box-shadow:var(--rw-shadow-brand);"><i class="fa-solid fa-check" style="font-size:24px;"></i></div>' +
      '<p class="rw-title" style="margin-top:14px;">完成</p>' +
      '<p class="rw-msg"></p>' +
      '<div style="display:flex;flex-direction:column;gap:9px;margin-top:16px;"></div>';
    card.innerHTML = html;
    card.querySelector('.rw-msg').textContent = doneMsg;
    var box = card.querySelector('div:last-child');
    (actions || [['完成', '', 1]]).forEach(function (a) {
      var b = document.createElement('button');
      b.className = 'btn ' + (a[2] ? 'btn-primary' : 'btn-secondary');
      b.style.cssText = 'width:100%;height:44px;font-size:14px;';
      b.textContent = a[0];
      b.addEventListener('click', function () {
        if (a[1]) { location.href = a[1]; } else { phone.removeChild(ov); }
      });
      box.appendChild(b);
    });
  }
};
