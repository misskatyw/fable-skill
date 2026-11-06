# fable-skill

一套由 Claude Fable 5 寫低、俾之後 Sonnet / Haiku 等較細模型長期沿用嘅作業制度，
包裝成 Claude skill。目標：每個之後嘅 session 都好似有個強模型幫佢定好規矩咁做嘢。

A Claude skill that turns a stronger model's judgment into rules weaker models can follow:
delegation, model/effort choice, escalation, verification, "is it done?", "should I ask?",
dispatch templates, and a maintenance protocol. Tuned for **Claude Code + Pro plan**.

## 入面有乜 What's inside
| Path | 用途 |
|---|---|
| `SKILL.md` | Skill 入口：六條硬規則 + 路由表 |
| `references/00-diagnosis.md` | 原環境三大漏洞診斷（漏 token／失焦／出錯）|
| `references/10-dispatch.md` | 模型調度：指揮官不下場、派工三件套、model/effort、升降級、回報合約、驗證不自驗 |
| `references/20-judgment.md` | 判斷力 rubric：幾時升級、幾時算完成、幾時問人、幾時換路、品質底線（每條附正反例）|
| `references/30-templates.md` | 派工模板：搜尋、實作、重構、研究、審查 |
| `references/40-maintenance.md` | 維護協議：邊啲可以自己改、邊啲要先問、教訓點寫、幾時精簡 |
| `references/50-letter.md` | 俾未來 session 嘅信 + 制度退化方式與預防 |
| `references/90-bootstrap.md` | 新專案第一次啟用檢查 |
| `assets/CLAUDE.md` | 專案用 CLAUDE.md 範本（≤60 行路由）|
| `assets/agents/` | 現成 subagent：`scout`（唯讀偵察, haiku）、`worker`（執行, sonnet）、`verifier`（驗收, sonnet）|
| `assets/ENVIRONMENT.md`, `assets/LESSONS.md` | 本機事實 stub、教訓日誌 seed |
| `scripts/install.sh` | 安裝到專案（先備份、唔覆蓋現有 CLAUDE.md／狀態檔、自動加 `.gitignore`）|

## 安裝 Install

**A. Claude Code 個人 skill（所有專案都用到）**
```bash
git clone https://github.com/misskatyw/fable-skill ~/.claude/skills/fable-skill
```

**B. 裝落某個專案（CLAUDE.md + subagents + 規則檔）**
```bash
cd your-project
bash ~/.claude/skills/fable-skill/scripts/install.sh .
```
然後開（或重開）Claude Code 講：`Run claude/90-bootstrap.md top to bottom`
（會做對抗審查；佢會請你打 `/model` 再貼返結果，記低你帳號實際有咩模型落 `claude/ENVIRONMENT.md`）。

**C. claude.ai**
下載呢個 repo 嘅 ZIP，喺 claude.ai 嘅 Skills 設定上載。冇 subagent 嘅環境，
`SKILL.md` 有寫點樣降級執行。

## 更新規則 Updating
跟 `references/40-maintenance.md`：教訓先寫入 `LESSONS.md`；改硬規則、升級梯、
rubric 之前要使用者同意；`00-diagnosis.md` 同 `50-letter.md` 係歷史紀錄，唔改。

## 誠實條款
拆解、驗證、多樣本評審補得到執行品質；品味同模糊需求補唔到——遇到時跟
`20-judgment.md §6`：俾預設方案＋選項、問使用者、或者直接講做唔好。
