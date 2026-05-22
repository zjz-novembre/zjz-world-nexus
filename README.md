# zjz-world-nexus

## 命名约定
- `src/`: 人直接维护的前端源码
- `public/`: 图标、字体这类静态资源
- `cloudflare/zjz-world-nexus-web/`: 页面、登录、会话和 API 转发 Worker
- `cloudflare/zjz-world-nexus-data/`: Nexus 数据和图标 Worker
- 项目根目录下的 `build-zjz-world-nexus.py`: 打包脚本

## 现在的主维护入口
- 页面结构: `/Users/zjz/Documents/zjz-world-nexus/src/index.html`
- 样式: `/Users/zjz/Documents/zjz-world-nexus/src/assets/nexus-web.css`
- 逻辑: `/Users/zjz/Documents/zjz-world-nexus/src/assets/nexus-web.js`

## 打包
```bash
python3 /Users/zjz/Documents/zjz-world-nexus/build-zjz-world-nexus.py
```

## 浏览器扩展
- 扩展源码: `/Users/zjz/Documents/zjz-world-nexus/extensions/zjz-world-nexus-browser-extension`
- 扩展打包: `python3 /Users/zjz/Documents/zjz-world-nexus/build-zjz-world-nexus-browser-extension.py`
- Chrome 商店 zip: `/Users/zjz/Documents/zjz-world-nexus/dist/zjz-world-nexus-browser-extension/chrome-web-store/zjz-world-nexus-browser-extension.zip`
- Safari 打包脚本: `/Users/zjz/Documents/zjz-world-nexus/extensions/zjz-world-nexus-browser-extension/package-safari-web-extension.sh`

## 发布产物
- `/Users/zjz/Documents/zjz-world-nexus/cloudflare/zjz-world-nexus-web/worker.js`
- `/Users/zjz/Documents/zjz-world-nexus/cloudflare/zjz-world-nexus-data/worker.js`

## 说明
- 线上结构恢复为两只 Worker: `zjz-world-nexus-web` 和 `zjz-world-nexus-data`。
- `zjz-world-nexus-web` 已经吸收原先 `core` 的职责，不再保留 `core` Worker 名称。
- 静态资源统一收敛到 `public/shared/`。
