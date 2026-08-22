# Tomica 典藏庫

以 HTML 為前端的 Tomica 收藏管理系統。

## 專案狀態

- 介面版本：V1.0 Draft
- 日期：2026-08-22
- 階段：GitHub Pages 可操作介面
- 正式版本基線：`main` 分支，後續以 Git tag 管理

## V1.0 目標

1. 建立每一台實際藏品的獨立紀錄，而不只記錄車款名稱。
2. 支援 Tomica 編號、車身、底盤、包裝與版本差異。
3. 商品／系列編號與底盤刻印編號分開保存，底盤可明確標示無編號。
4. 支援多張照片、缺件與保存狀況。
5. 提供快速搜尋、篩選、統計、匯入與備份。
6. 採可逐步升級的前端與資料層設計。

完整規格見 `docs/V1.0-SPEC.md`，資料庫草案見 `database/schema.sql`。

## 預定技術基線

- 前端：HTML5、CSS3、Vanilla JavaScript
- 本機資料：IndexedDB
- 後續雲端：REST API + SQLite/D1 或 Supabase（於同步階段再決策）
- 圖片：前端壓縮、縮圖、原圖分離
- 部署：GitHub Pages

## V1.0 已完成頁面

- 首頁儀表板與待處理提醒
- 我的典藏、搜尋、篩選與卡片列表
- 藏品詳情與商品／底盤編號分離顯示
- 五步驟新增藏品介面與本機草稿
- 車款資料庫、JSON 備份、深色模式與手機版導覽

## 預定 Repository 結構

```text
tomica-collection/
├─ index.html
├─ README.md
├─ CHANGELOG.md
├─ assets/
│  ├─ css/
│  ├─ js/
│  └─ icons/
├─ docs/
│  └─ V1.0-SPEC.md
├─ database/
│  └─ schema.sql
└─ tests/
```
