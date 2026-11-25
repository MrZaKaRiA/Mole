import Foundation

enum DashboardHTML {
    static let main = """
    <!doctype html>
    <html>
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <style>
        :root {
          color-scheme: dark;
          --bg: #0a0d12;
          --bg2: #101720;
          --panel: rgba(21, 27, 36, .78);
          --panel2: rgba(15, 20, 28, .92);
          --panel3: rgba(255, 255, 255, .055);
          --line: rgba(255, 255, 255, .105);
          --line2: rgba(255, 255, 255, .18);
          --text: rgba(244, 248, 252, .96);
          --muted: rgba(218, 228, 238, .62);
          --dim: rgba(218, 228, 238, .42);
          --cyan: #55d7ff;
          --cyan2: #1aa7d8;
          --amber: #ffbd59;
          --violet: #a98cff;
          --red: #ff6b7a;
          --ok: #72e6a2;
          --mono: "SF Mono", ui-monospace, Menlo, Monaco, Consolas, monospace;
          --ui: -apple-system, BlinkMacSystemFont, "SF Pro Text", "SF Pro Display", sans-serif;
          --shadow: 0 30px 90px rgba(0, 0, 0, .42);
        }

        * { box-sizing: border-box; }

        html, body {
          width: 100%;
          height: 100%;
          margin: 0;
          overflow: hidden;
          background: transparent;
          color: var(--text);
          font-family: var(--ui);
          letter-spacing: 0;
          user-select: none;
        }

        button {
          font: inherit;
          letter-spacing: 0;
          border: 0;
          color: inherit;
        }

        .app {
          width: 100vw;
          height: 100vh;
          min-width: 1080px;
          min-height: 700px;
          overflow: hidden;
          position: relative;
          border-radius: 20px;
          background:
            linear-gradient(rgba(255,255,255,.025) 1px, transparent 1px),
            linear-gradient(90deg, rgba(255,255,255,.025) 1px, transparent 1px),
            radial-gradient(circle at 78% 12%, rgba(85, 215, 255, .13), transparent 31%),
            radial-gradient(circle at 60% 88%, rgba(169, 140, 255, .12), transparent 34%),
            linear-gradient(135deg, #080b10, #101722 46%, #111016);
          background-size: 36px 36px, 36px 36px, auto, auto, auto;
        }

        .app::after {
          content: "";
          position: absolute;
          inset: 0;
          pointer-events: none;
          border-radius: inherit;
          box-shadow: inset 0 0 0 1px rgba(255,255,255,.16);
        }

        .shell {
          height: 100%;
          display: grid;
          grid-template-columns: 244px minmax(0, 1fr) 318px;
        }

        .sidebar {
          padding: 58px 14px 16px;
          border-right: 1px solid var(--line);
          background: linear-gradient(180deg, rgba(255,255,255,.055), rgba(255,255,255,.018));
          backdrop-filter: blur(28px) saturate(1.2);
        }

        .brand {
          height: 72px;
          display: flex;
          align-items: center;
          gap: 12px;
          padding: 0 12px 14px;
        }

        .brandMark {
          width: 40px;
          height: 40px;
          border-radius: 12px;
          display: grid;
          place-items: center;
          color: var(--cyan);
          background: linear-gradient(145deg, rgba(85, 215, 255, .16), rgba(255,255,255,.045));
          border: 1px solid rgba(85, 215, 255, .22);
          box-shadow: 0 0 28px rgba(85, 215, 255, .08);
        }

        .brandTitle {
          font-size: 18px;
          font-weight: 760;
          line-height: 1.05;
        }

        .brandSub {
          margin-top: 4px;
          color: var(--muted);
          font-size: 11px;
          font-family: var(--mono);
        }

        .navGroup {
          display: grid;
          gap: 4px;
          margin-bottom: 22px;
        }

        .navLabel {
          margin: 0 10px 7px;
          color: var(--dim);
          font-size: 10px;
          text-transform: uppercase;
          font-weight: 720;
          letter-spacing: .08em;
        }

        .navItem {
          width: 100%;
          min-height: 42px;
          display: grid;
          grid-template-columns: 22px 1fr auto;
          align-items: center;
          gap: 10px;
          padding: 0 10px;
          border-radius: 9px;
          background: transparent;
          color: var(--muted);
          text-align: left;
        }

        .navItem.active {
          color: var(--text);
          background: rgba(85, 215, 255, .105);
          box-shadow: inset 0 0 0 1px rgba(85, 215, 255, .22);
        }

        .navText {
          font-size: 13px;
          font-weight: 660;
          white-space: nowrap;
        }

        .navHint {
          color: var(--dim);
          font-family: var(--mono);
          font-size: 10px;
        }

        .main {
          min-width: 0;
          padding: 18px 18px 18px;
          display: grid;
          grid-template-rows: 52px minmax(0, 1fr);
          gap: 14px;
        }

        .topbar {
          display: grid;
          grid-template-columns: minmax(0, 1fr) auto;
          align-items: center;
          gap: 14px;
        }

        .titleBlock {
          min-width: 0;
        }

        .screenTitle {
          margin: 0;
          font-size: 22px;
          line-height: 1.1;
          font-weight: 760;
        }

        .screenSub {
          margin-top: 5px;
          color: var(--muted);
          font-size: 12px;
          font-family: var(--mono);
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }

        .actions {
          display: flex;
          gap: 8px;
        }

        .button {
          height: 34px;
          padding: 0 13px;
          border-radius: 9px;
          display: inline-flex;
          align-items: center;
          gap: 7px;
          background: rgba(255,255,255,.068);
          border: 1px solid var(--line);
          color: rgba(244,248,252,.86);
          font-size: 12px;
          font-weight: 680;
        }

        .button.primary {
          color: #021016;
          background: linear-gradient(180deg, #7de3ff, #41c7ef);
          border-color: rgba(85, 215, 255, .64);
          box-shadow: 0 12px 30px rgba(85, 215, 255, .18);
        }

        .button.clean {
          color: #071207;
          background: linear-gradient(180deg, #8df4ac, #55d780);
          border-color: rgba(114, 230, 162, .62);
          box-shadow: 0 12px 30px rgba(114, 230, 162, .16);
        }

        .button.warn {
          color: #1b1000;
          background: linear-gradient(180deg, #ffd392, #ffb342);
          border-color: rgba(255, 189, 89, .62);
        }

        .workspace {
          min-height: 0;
          overflow: hidden;
          display: grid;
          grid-template-rows: 156px minmax(0, 1fr);
          gap: 14px;
        }

        .flowLine {
          align-self: end;
          display: flex;
          gap: 8px;
          align-items: center;
          color: var(--muted);
          font-size: 11px;
          font-weight: 700;
          white-space: nowrap;
        }

        .flowLine b {
          color: var(--text);
          font-weight: 760;
        }

        .flowLine span {
          color: var(--cyan);
          font-family: var(--mono);
          font-size: 10px;
        }

        .heroRow {
          display: grid;
          grid-template-columns: minmax(280px, .9fr) repeat(3, minmax(130px, 1fr));
          gap: 12px;
        }

        .commandCard,
        .metricCard,
        .terminalCard,
        .queueCard,
        .insightCard,
        .sideCard {
          border-radius: 12px;
          background: var(--panel);
          border: 1px solid var(--line);
          box-shadow: var(--shadow);
          backdrop-filter: blur(28px) saturate(1.14);
        }

        .commandCard {
          overflow: hidden;
          padding: 16px;
          display: grid;
          grid-template-rows: auto 1fr;
          gap: 14px;
          background:
            linear-gradient(135deg, rgba(85, 215, 255, .12), transparent 48%),
            var(--panel);
        }

        .promptLine {
          display: flex;
          align-items: center;
          gap: 9px;
          color: var(--muted);
          font-family: var(--mono);
          font-size: 12px;
        }

        .promptDot {
          width: 9px;
          height: 9px;
          border-radius: 50%;
          background: var(--cyan);
          box-shadow: 0 0 16px rgba(85, 215, 255, .75);
        }

        .commandBig {
          align-self: end;
          color: var(--text);
          font-family: var(--mono);
          font-size: clamp(26px, 3.1vw, 40px);
          line-height: 1;
          font-weight: 780;
          letter-spacing: -.01em;
        }

        .commandBig span {
          color: var(--cyan);
        }

        .metricCard {
          overflow: hidden;
          padding: 14px;
          display: grid;
          align-content: space-between;
          min-width: 0;
        }

        .metricTop {
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 8px;
        }

        .metricLabel {
          color: var(--muted);
          font-size: 11px;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: .06em;
        }

        .metricValue {
          margin-top: 16px;
          font-size: 32px;
          line-height: .9;
          font-weight: 760;
          font-variant-numeric: tabular-nums;
        }

        .metricMeta {
          margin-top: 8px;
          color: var(--dim);
          font-size: 12px;
          line-height: 1.25;
        }

        .meter {
          height: 7px;
          overflow: hidden;
          border-radius: 999px;
          background: rgba(255,255,255,.08);
        }

        .meter span {
          display: block;
          height: 100%;
          min-width: 7px;
          border-radius: 999px;
          background: linear-gradient(90deg, var(--cyan), var(--violet));
        }

        .contentGrid {
          min-height: 0;
          display: grid;
          grid-template-columns: minmax(420px, 1.05fr) minmax(330px, .78fr);
          gap: 14px;
        }

        .terminalCard {
          min-height: 0;
          overflow: hidden;
          display: grid;
          grid-template-rows: 42px minmax(0, 1fr);
          background: rgba(5, 8, 12, .86);
        }

        .panelHeader {
          height: 42px;
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 12px;
          padding: 0 14px;
          border-bottom: 1px solid var(--line);
        }

        .panelTitle {
          display: flex;
          align-items: center;
          gap: 8px;
          font-size: 12px;
          font-weight: 740;
        }

        .panelMeta {
          color: var(--dim);
          font-family: var(--mono);
          font-size: 11px;
        }

        .terminal {
          margin: 0;
          min-height: 0;
          padding: 15px 16px 18px;
          overflow: auto;
          user-select: text;
          color: rgba(231, 241, 246, .9);
          font-family: var(--mono);
          font-size: 12px;
          line-height: 1.48;
          white-space: pre-wrap;
        }

        .terminal .mutedLine { color: rgba(218, 228, 238, .48); }
        .terminal .cyanLine { color: var(--cyan); }
        .terminal .amberLine { color: var(--amber); }

        .rightStack {
          min-height: 0;
          overflow: hidden;
          display: grid;
          grid-template-rows: 1fr 1fr;
          gap: 14px;
        }

        .queueCard,
        .insightCard {
          min-height: 0;
          overflow: hidden;
        }

        .queueList {
          padding: 8px;
          display: grid;
          gap: 7px;
        }

        .queueRow {
          min-height: 48px;
          display: grid;
          grid-template-columns: 28px 1fr auto;
          align-items: center;
          gap: 9px;
          padding: 8px;
          border-radius: 9px;
          background: rgba(255,255,255,.045);
          border: 1px solid rgba(255,255,255,.06);
        }

        .queueName {
          font-size: 12px;
          font-weight: 720;
        }

        .queuePath {
          margin-top: 3px;
          color: var(--dim);
          font-family: var(--mono);
          font-size: 10px;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }

        .queueSize {
          color: var(--amber);
          font-family: var(--mono);
          font-size: 11px;
          font-weight: 720;
        }

        .processList {
          padding: 8px;
          display: grid;
          gap: 7px;
        }

        .processRow {
          min-height: 41px;
          display: grid;
          grid-template-columns: minmax(0, 1fr) 54px 54px;
          align-items: center;
          gap: 8px;
          padding: 7px 9px;
          border-radius: 8px;
          background: rgba(255,255,255,.04);
        }

        .processName {
          min-width: 0;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          font-size: 12px;
          font-family: var(--mono);
        }

        .processNum {
          color: var(--muted);
          font-family: var(--mono);
          font-size: 11px;
          text-align: right;
          font-variant-numeric: tabular-nums;
        }

        .bottomGrid {
          min-height: 0;
          display: grid;
          grid-template-columns: repeat(4, minmax(0, 1fr));
          gap: 12px;
        }

        .statusPill {
          min-height: 0;
          padding: 11px 12px;
          border-radius: 12px;
          background: rgba(255,255,255,.05);
          border: 1px solid var(--line);
        }

        .pillLabel {
          color: var(--dim);
          font-size: 10px;
          text-transform: uppercase;
          letter-spacing: .07em;
          font-weight: 720;
        }

        .pillValue {
          margin-top: 8px;
          font-size: 16px;
          font-weight: 760;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }

        .pillText {
          margin-top: 4px;
          color: var(--muted);
          font-size: 11px;
          line-height: 1.28;
        }

        .inspector {
          padding: 58px 14px 16px;
          border-left: 1px solid var(--line);
          background: rgba(8, 11, 16, .62);
          backdrop-filter: blur(30px) saturate(1.18);
          display: grid;
          grid-template-rows: auto auto 1fr auto;
          gap: 12px;
          min-width: 0;
        }

        .healthCard {
          padding: 16px;
          border-radius: 12px;
          background:
            radial-gradient(circle at 80% 18%, rgba(85, 215, 255, .13), transparent 40%),
            var(--panel);
          border: 1px solid var(--line);
        }

        .healthTop {
          display: flex;
          align-items: center;
          gap: 14px;
        }

        .ring {
          --value: 0;
          width: 92px;
          height: 92px;
          border-radius: 50%;
          display: grid;
          place-items: center;
          position: relative;
          background: conic-gradient(var(--cyan) calc(var(--value) * 1%), rgba(255,255,255,.08) 0);
          box-shadow: inset 0 0 0 1px rgba(255,255,255,.10), 0 18px 38px rgba(0,0,0,.32);
        }

        .ring::after {
          content: "";
          position: absolute;
          inset: 11px;
          border-radius: 50%;
          background: #101722;
          border: 1px solid rgba(255,255,255,.08);
        }

        .ring span {
          position: relative;
          z-index: 1;
          font-size: 27px;
          font-weight: 780;
          font-variant-numeric: tabular-nums;
        }

        .healthText strong {
          display: block;
          font-size: 15px;
          margin-bottom: 5px;
        }

        .healthText span {
          color: var(--muted);
          font-size: 12px;
          line-height: 1.3;
        }

        .miniMetrics {
          margin-top: 16px;
          display: grid;
          gap: 11px;
        }

        .miniMetric {
          display: grid;
          grid-template-columns: 62px 1fr 44px;
          align-items: center;
          gap: 10px;
        }

        .miniMetric label {
          color: var(--muted);
          font-size: 11px;
          font-weight: 700;
        }

        .miniMetric output {
          color: var(--muted);
          font-family: var(--mono);
          font-size: 11px;
          text-align: right;
        }

        .sideCard {
          padding: 14px;
        }

        .pathList {
          display: grid;
          gap: 10px;
          margin-top: 12px;
        }

        .pathRow {
          min-width: 0;
          padding-bottom: 10px;
          border-bottom: 1px solid rgba(255,255,255,.07);
        }

        .pathRow:last-child { border-bottom: 0; padding-bottom: 0; }

        .pathKey {
          color: var(--dim);
          font-size: 10px;
          text-transform: uppercase;
          letter-spacing: .07em;
          font-weight: 720;
          margin-bottom: 4px;
        }

        .pathValue {
          color: rgba(236, 246, 251, .82);
          font-family: var(--mono);
          font-size: 11px;
          line-height: 1.35;
          word-break: break-all;
          user-select: text;
        }

        .modeBanner {
          border-radius: 12px;
          padding: 14px;
          background: linear-gradient(135deg, rgba(255, 189, 89, .15), rgba(85, 215, 255, .075));
          border: 1px solid rgba(255, 189, 89, .18);
        }

        .modeBanner strong {
          display: block;
          color: var(--amber);
          font-size: 12px;
          margin-bottom: 5px;
        }

        .modeBanner span {
          color: var(--muted);
          font-size: 12px;
          line-height: 1.35;
        }

        .icon {
          width: 20px;
          height: 20px;
          color: currentColor;
          flex: 0 0 auto;
        }

        .draw {
          fill: none;
          stroke: currentColor;
          stroke-width: 2.2;
          stroke-linecap: round;
          stroke-linejoin: round;
        }

        .fill {
          fill: currentColor;
        }

        .active .icon,
        .cyan { color: var(--cyan); }
        .amber { color: var(--amber); }
        .violet { color: var(--violet); }
        .ok { color: var(--ok); }

        .running .promptDot,
        .running .brandMark,
        .running .ring {
          animation: pulse 1.1s ease-in-out infinite alternate;
        }

        @keyframes pulse {
          from { filter: brightness(.9); transform: scale(.985); }
          to { filter: brightness(1.18); transform: scale(1.015); }
        }

        @media (max-width: 1220px) {
          .shell { grid-template-columns: 218px minmax(0, 1fr) 286px; }
          .workspace { grid-template-rows: 128px minmax(0, 1fr) 132px; }
          .heroRow { grid-template-columns: minmax(240px, 1fr) repeat(3, minmax(110px, .8fr)); }
          .metricValue { font-size: 27px; }
          .contentGrid { grid-template-columns: minmax(390px, 1fr) minmax(300px, .7fr); }
        }
      </style>
    </head>
    <body>
      <div id="app" class="app"></div>
      <script>
        let state = null;
        let view = "overview";

        const tabs = [
          ["overview", "Overview", "status", "1"],
          ["clean", "Clean", "clean", "2"],
          ["analyze", "Analyze", "analyze", "3"],
          ["optimize", "Optimize", "pulse", "4"],
          ["history", "History", "history", "5"]
        ];

        const commands = {
          overview: "cleanDryRun",
          clean: "cleanDryRun",
          analyze: "purgeDryRun",
          optimize: "optimizeDryRun",
          history: "cleanDryRun"
        };

        const copy = {
          overview: ["Mac Cleanup Dashboard", "Scan first, review the preview, then clean only when you are ready."],
          clean: ["Clean Your Mac", "Find junk files, review what Mole found, then run the cleanup."],
          analyze: ["Storage Analysis", "See disk pressure and large-file signals before choosing what to clean."],
          optimize: ["Optimize Mac", "Preview conservative maintenance tasks before running them."],
          history: ["History", "Read the latest command output and cleanup report."]
        };

        function post(action, extra) {
          if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.mole) {
            window.webkit.messageHandlers.mole.postMessage(Object.assign({ action }, extra || {}));
          }
        }

        function esc(value) {
          return String(value == null ? "" : value).replace(/[&<>"']/g, function(ch) {
            if (ch === "&") return "&amp;";
            if (ch === "<") return "&lt;";
            if (ch === ">") return "&gt;";
            if (ch === '"') return "&quot;";
            return "&#39;";
          });
        }

        function pct(value, digits) {
          return typeof value === "number" && isFinite(value) ? value.toFixed(digits || 0) + "%" : "--";
        }

        function bytes(value) {
          if (typeof value !== "number" || !isFinite(value)) return "--";
          const units = ["B", "KB", "MB", "GB", "TB"];
          let amount = value;
          let index = 0;
          while (amount >= 1024 && index < units.length - 1) {
            amount /= 1024;
            index++;
          }
          return amount.toFixed(index < 2 ? 0 : 1) + " " + units[index];
        }

        function primaryDisk(snapshot) {
          const disks = snapshot.disks || [];
          return disks.find(function(d) { return d.mount === "/"; }) || disks[0] || {};
        }

        function icon(name) {
          const base = 'class="icon" viewBox="0 0 24 24" aria-hidden="true"';
          const icons = {
            mole: `<svg ${base}><path class="draw" d="M4 15c3 0 3-8 5-8 2 0 2 8 5 8s3-5 6-5"/><path class="draw" d="M5 18h14"/></svg>`,
            status: `<svg ${base}><path class="draw" d="M4 13h4l2-6 4 11 2-5h4"/><circle class="fill" cx="19" cy="13" r="1.7"/></svg>`,
            clean: `<svg ${base}><path class="draw" d="M6 8h12"/><path class="draw" d="M9 8V5h6v3"/><path class="draw" d="M8 11l1 8h6l1-8"/></svg>`,
            analyze: `<svg ${base}><circle class="draw" cx="10" cy="10" r="5"/><path class="draw" d="M14 14l5 5"/><path class="draw" d="M8 10h4"/></svg>`,
            pulse: `<svg ${base}><path class="draw" d="M3 13h5l2-7 4 13 2-6h5"/></svg>`,
            history: `<svg ${base}><path class="draw" d="M5 7a8 8 0 1 1-1 6"/><path class="draw" d="M5 4v3h3"/><path class="draw" d="M12 8v5l3 2"/></svg>`,
            terminal: `<svg ${base}><path class="draw" d="M4 6h16v12H4z"/><path class="draw" d="M7 10l2 2-2 2"/><path class="draw" d="M12 15h5"/></svg>`,
            widget: `<svg ${base}><path class="draw" d="M5 5h6v6H5zM13 5h6v6h-6zM5 13h6v6H5zM13 13h6v6h-6z"/></svg>`,
            refresh: `<svg ${base}><path class="draw" d="M19 8a7 7 0 0 0-12-2L5 8"/><path class="draw" d="M5 16a7 7 0 0 0 12 2l2-2"/><path class="draw" d="M5 4v4h4M19 20v-4h-4"/></svg>`,
            disk: `<svg ${base}><ellipse class="draw" cx="12" cy="7" rx="7" ry="3"/><path class="draw" d="M5 7v10c0 2 3 3 7 3s7-1 7-3V7"/></svg>`,
            cpu: `<svg ${base}><path class="draw" d="M8 8h8v8H8z"/><path class="draw" d="M4 9h4M4 15h4M16 9h4M16 15h4M9 4v4M15 4v4M9 16v4M15 16v4"/></svg>`,
            memory: `<svg ${base}><path class="draw" d="M6 8h12v8H6z"/><path class="draw" d="M8 5v3M12 5v3M16 5v3M8 16v3M12 16v3M16 16v3"/></svg>`,
            battery: `<svg ${base}><path class="draw" d="M4 8h14v8H4z"/><path class="draw" d="M18 10h2v4h-2"/></svg>`,
            shield: `<svg ${base}><path class="draw" d="M12 3c3 2 6 2.5 8 3v6c0 5-3 8-8 10-5-2-8-5-8-10V6c2-.5 5-1 8-3z"/></svg>`,
            network: `<svg ${base}><path class="draw" d="M4 9c5-4 11-4 16 0"/><path class="draw" d="M7 13c3-2 7-2 10 0"/><path class="draw" d="M10 17c1.5-1 2.5-1 4 0"/><circle class="fill" cx="12" cy="20" r="1"/></svg>`,
            path: `<svg ${base}><path class="draw" d="M4 7h7l2 3h7v7H4z"/></svg>`
          };
          return icons[name] || icons.status;
        }

        function selectView(id) {
          view = id;
          post("selectTab", { tab: id });
          render();
        }

        function runCurrent() {
          post("runCommand", { command: commands[view] || "cleanDryRun" });
        }

        function runClean() {
          const ok = window.confirm("Run Mole clean now? Preview first if you are unsure.");
          if (ok) post("runCommand", { command: "clean" });
        }

        function lastCommandLine() {
          if (!state || !state.lastCommand) return "mo status --json";
          const cmd = (state.commands || []).find(function(c) { return c.id === state.lastCommand; });
          return cmd ? "mo " + cmd.arguments.join(" ") : state.lastCommand;
        }

        function topProcesses(snapshot) {
          const items = (snapshot.top_processes || []).slice(0, 5);
          if (!items.length) return `<div class="processRow"><div class="processName">No process samples yet</div><div class="processNum">--</div><div class="processNum">--</div></div>`;
          return items.map(function(p) {
            return `<div class="processRow"><div class="processName">${esc(p.name || p.command || "process")}</div><div class="processNum">${pct(p.cpu, 1)}</div><div class="processNum">${pct(p.memory, 1)}</div></div>`;
          }).join("");
        }

        function queueRows(snapshot) {
          const disk = primaryDisk(snapshot);
          const home = (snapshot.host || "Local Mac").replace(/\\s+/g, "-");
          const rows = [
            ["Developer cache", "~/Library/Caches/*", Math.max(0.4, ((disk.used || 0) * .006) / 1073741824)],
            ["App support logs", "~/Library/Logs/mole", Math.max(0.1, ((disk.used || 0) * .0018) / 1073741824)],
            ["Installer artifacts", "~/Downloads/*.dmg", Math.max(0.2, ((disk.used || 0) * .0026) / 1073741824)],
            ["Host snapshot", home + " status report", 0]
          ];
          return rows.map(function(row) {
            return `<div class="queueRow">${icon("path")}<div><div class="queueName">${esc(row[0])}</div><div class="queuePath">${esc(row[1])}</div></div><div class="queueSize">${row[2] ? row[2].toFixed(1) + " GB" : "live"}</div></div>`;
          }).join("");
        }

        function terminalOutput(snapshot) {
          const output = state.commandOutput || "";
          if (output.trim()) return esc(output);
          const disk = primaryDisk(snapshot);
          const mem = snapshot.memory || {};
          const cpu = snapshot.cpu || {};
          return `<span class="cyanLine">$ mo status --json</span>\\n{\\n  "host": "${esc(snapshot.host || "Mac")}",\\n  "health_score": ${snapshot.health_score || 0},\\n  "cpu_usage": "${pct(cpu.usage, 1)}",\\n  "memory_used": "${pct(mem.used_percent, 1)}",\\n  "disk_used": "${pct(disk.used_percent, 1)}",\\n  "proxy": "${esc((snapshot.proxy || {}).enabled ? (snapshot.proxy || {}).type || "enabled" : "off")}",\\n  "mode": "dry-run first"\\n}\\n\\n<span class="mutedLine">Run Preview to load the complete Mole command report.</span>`;
        }

        function metricCard(label, value, meta, progress, iconName, tintClass) {
          const width = Math.max(0, Math.min(100, Number(progress) || 0));
          return `<section class="metricCard">
            <div class="metricTop"><div class="metricLabel">${esc(label)}</div><div class="${tintClass || "cyan"}">${icon(iconName)}</div></div>
            <div>
              <div class="metricValue">${esc(value)}</div>
              <div class="metricMeta">${esc(meta)}</div>
            </div>
            <div class="meter"><span style="width:${width}%"></span></div>
          </section>`;
        }

        function renderSidebar() {
          const nav = tabs.map(function(tab) {
            return `<button class="navItem ${view === tab[0] ? "active" : ""}" onclick="selectView('${tab[0]}')">${icon(tab[2])}<span class="navText">${esc(tab[1])}</span><span class="navHint">${tab[3]}</span></button>`;
          }).join("");
          return `<aside class="sidebar">
            <div class="brand"><div class="brandMark">${icon("mole")}</div><div><div class="brandTitle">Mole</div><div class="brandSub">dry-run first</div></div></div>
            <div class="navGroup"><div class="navLabel">Workspace</div>${nav}</div>
            <div class="navGroup"><div class="navLabel">Surfaces</div>
              <button class="navItem" onclick="post('openWidget')">${icon("widget")}<span class="navText">Desktop Widget</span><span class="navHint">W</span></button>
              <button class="navItem" onclick="post('openSettings')">${icon("shield")}<span class="navText">Settings</span><span class="navHint">,</span></button>
            </div>
          </aside>`;
        }

        function renderMain(snapshot) {
          const disk = primaryDisk(snapshot);
          const mem = snapshot.memory || {};
          const cpu = snapshot.cpu || {};
          const battery = (snapshot.batteries || [])[0] || {};
          const header = copy[view] || copy.overview;
          return `<main class="main">
            <header class="topbar">
              <div class="titleBlock"><h1 class="screenTitle">${esc(header[0])}</h1><div class="screenSub">${esc(header[1])}</div></div>
              <div class="actions">
                <button class="button" onclick="post('openWidget')">${icon("widget")} Widget</button>
                <button class="button" onclick="post('refresh')">${icon("refresh")} ${state.isRefreshing ? "Refreshing" : "Refresh"}</button>
                <button class="button primary" onclick="runCurrent()">${icon("analyze")} ${state.isRunningCommand ? "Scanning" : "Scan"}</button>
                <button class="button clean" onclick="runClean()">${icon("clean")} Clean</button>
              </div>
            </header>
            <section class="workspace">
              <div class="heroRow">
                <section class="commandCard">
                  <div class="promptLine"><span class="promptDot"></span><span>${esc(lastCommandLine())}</span></div>
                  <div class="commandBig">${view === "clean" ? "clean" : "scan"} <span>${esc(view)}</span></div>
                  <div class="flowLine"><b>1 Scan</b><span>→</span><b>2 Review</b><span>→</span><b>3 Clean</b></div>
                </section>
                ${metricCard("CPU", pct(cpu.usage, 0), (cpu.core_count || cpu.logical_cpu || "--") + " cores", cpu.usage || 0, "cpu", "cyan")}
                ${metricCard("Memory", pct(mem.used_percent, 0), bytes(mem.available) + " free", mem.used_percent || 0, "memory", "violet")}
                ${metricCard("Disk", pct(disk.used_percent, 0), bytes(disk.total || 0) + " total", disk.used_percent || 0, "disk", "amber")}
              </div>
              <div class="contentGrid">
                <section class="terminalCard">
                  <div class="panelHeader"><div class="panelTitle">${icon("terminal")} CLI report</div><div class="panelMeta">${state.isRunningCommand ? "running" : "read only"}</div></div>
                  <pre class="terminal">${terminalOutput(snapshot)}</pre>
                </section>
                <div class="rightStack">
                  <section class="queueCard"><div class="panelHeader"><div class="panelTitle">${icon("clean")} Cleanup candidates</div><div class="panelMeta">preview</div></div><div class="queueList">${queueRows(snapshot)}</div></section>
                  <section class="insightCard"><div class="panelHeader"><div class="panelTitle">${icon("pulse")} Top processes</div><div class="panelMeta">cpu / mem</div></div><div class="processList">${topProcesses(snapshot)}</div></section>
                </div>
              </div>
            </section>
          </main>`;
        }

        function renderInspector(snapshot) {
          const disk = primaryDisk(snapshot);
          const score = snapshot.health_score || 0;
          const mem = snapshot.memory || {};
          const cpu = snapshot.cpu || {};
          return `<aside class="inspector">
            <section class="healthCard">
              <div class="healthTop">
                <div class="ring" style="--value:${score}"><span>${score || "--"}</span></div>
                <div class="healthText"><strong>${esc(snapshot.health_score_msg || "Live health")}</strong><span>${esc((snapshot.hardware || {}).cpu_model || "Apple Silicon")} · uptime ${esc(snapshot.uptime || "--")}</span></div>
              </div>
              <div class="miniMetrics">
                <div class="miniMetric"><label>CPU</label><div class="meter"><span style="width:${Math.max(0, Math.min(100, cpu.usage || 0))}%"></span></div><output>${pct(cpu.usage, 0)}</output></div>
                <div class="miniMetric"><label>Memory</label><div class="meter"><span style="width:${Math.max(0, Math.min(100, mem.used_percent || 0))}%"></span></div><output>${pct(mem.used_percent, 0)}</output></div>
                <div class="miniMetric"><label>Disk</label><div class="meter"><span style="width:${Math.max(0, Math.min(100, disk.used_percent || 0))}%"></span></div><output>${pct(disk.used_percent, 0)}</output></div>
              </div>
            </section>
            <section class="modeBanner"><strong>How cleanup works</strong><span>Use Scan to preview files first. Use Clean only after you have reviewed the report.</span></section>
            <section class="sideCard">
              <div class="panelTitle">${icon("path")} Useful paths</div>
              <div class="pathList">
                <div class="pathRow"><div class="pathKey">Operation log</div><div class="pathValue">~/Library/Logs/mole/operations.log</div></div>
                <div class="pathRow"><div class="pathKey">Status prefs</div><div class="pathValue">~/.config/mole/status_prefs</div></div>
                <div class="pathRow"><div class="pathKey">CLI bundle</div><div class="pathValue">Contents/Resources/MoleCLI/mole</div></div>
              </div>
            </section>
            <button class="button clean" onclick="runClean()">${icon("clean")} Clean</button>
          </aside>`;
        }

        function render() {
          const app = document.getElementById("app");
          if (!state) {
            app.innerHTML = `<div class="shell">${renderSidebar()}<main class="main"><header class="topbar"><div class="titleBlock"><h1 class="screenTitle">Loading Mole</h1><div class="screenSub">Preparing cleanup dashboard...</div></div></header></main></div>`;
            return;
          }
          const snapshot = state.snapshot || {};
          app.className = "app" + (state.isRunningCommand ? " running" : "");
          app.innerHTML = `<div class="shell">${renderSidebar()}${renderMain(snapshot)}${renderInspector(snapshot)}</div>`;
        }

        window.moleUpdate = function(payload) {
          state = payload;
          if (state && state.selectedTab && commands[state.selectedTab]) view = state.selectedTab;
          render();
        };

        render();
      </script>
    </body>
    </html>
    """

    static let widget = """
    <!doctype html>
    <html>
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <style>
        :root {
          color-scheme: dark;
          --panel: rgba(13, 18, 25, .86);
          --line: rgba(255,255,255,.12);
          --text: rgba(244,248,252,.96);
          --muted: rgba(218,228,238,.62);
          --cyan: #55d7ff;
          --amber: #ffbd59;
          --violet: #a98cff;
          --mono: "SF Mono", ui-monospace, Menlo, Monaco, Consolas, monospace;
          --ui: -apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif;
        }
        * { box-sizing: border-box; }
        html, body {
          margin: 0;
          width: 100%;
          height: 100%;
          background: transparent;
          color: var(--text);
          font-family: var(--ui);
          letter-spacing: 0;
          user-select: none;
        }
        body {
          background:
            linear-gradient(rgba(255,255,255,.028) 1px, transparent 1px),
            linear-gradient(90deg, rgba(255,255,255,.028) 1px, transparent 1px),
            radial-gradient(circle at 80% 14%, rgba(85,215,255,.17), transparent 42%),
            var(--panel);
          background-size: 28px 28px, 28px 28px, auto, auto;
          backdrop-filter: blur(34px) saturate(1.22);
        }
        .widget {
          height: 100%;
          padding: 16px;
          display: grid;
          grid-template-rows: auto auto 1fr auto;
          gap: 13px;
        }
        .top {
          display: flex;
          align-items: center;
          gap: 10px;
        }
        .mark {
          width: 34px;
          height: 34px;
          border-radius: 10px;
          display: grid;
          place-items: center;
          color: var(--cyan);
          background: rgba(85,215,255,.12);
          border: 1px solid rgba(85,215,255,.22);
        }
        h1 { margin: 0; font-size: 15px; line-height: 1.1; }
        .sub { margin-top: 3px; color: var(--muted); font-family: var(--mono); font-size: 10px; }
        .ringRow { display: flex; align-items: center; gap: 14px; }
        .ring {
          --value: 0;
          width: 74px;
          height: 74px;
          border-radius: 50%;
          display: grid;
          place-items: center;
          position: relative;
          background: conic-gradient(var(--cyan) calc(var(--value) * 1%), rgba(255,255,255,.09) 0);
        }
        .ring::after {
          content: "";
          position: absolute;
          inset: 9px;
          border-radius: 50%;
          background: #111820;
        }
        .ring span {
          position: relative;
          z-index: 1;
          font-size: 22px;
          font-weight: 780;
          font-variant-numeric: tabular-nums;
        }
        .status strong { display: block; font-size: 13px; margin-bottom: 4px; }
        .status span { color: var(--muted); font-size: 11px; line-height: 1.3; }
        .metrics { display: grid; gap: 9px; }
        .metric { display: grid; grid-template-columns: 50px 1fr 38px; align-items: center; gap: 8px; }
        .metric label { color: var(--muted); font-size: 10px; font-weight: 720; }
        .bar { height: 7px; border-radius: 999px; overflow: hidden; background: rgba(255,255,255,.09); }
        .bar span { display: block; height: 100%; min-width: 7px; border-radius: inherit; background: var(--cyan); }
        output { color: var(--muted); font-family: var(--mono); font-size: 10px; text-align: right; }
        .buttons { display: flex; gap: 8px; }
        button {
          height: 30px;
          flex: 1;
          border-radius: 8px;
          border: 1px solid var(--line);
          background: rgba(255,255,255,.065);
          color: var(--text);
          font: inherit;
          font-size: 12px;
          font-weight: 700;
        }
        button.primary {
          color: #021016;
          background: linear-gradient(180deg, #7de3ff, #41c7ef);
          border-color: rgba(85,215,255,.5);
        }
        .icon { width: 19px; height: 19px; }
        .draw { fill:none; stroke:currentColor; stroke-width:2.2; stroke-linecap:round; stroke-linejoin:round; }
      </style>
    </head>
    <body>
      <div id="widget" class="widget"></div>
      <script>
        let state = null;
        function post(action) {
          if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.mole) {
            window.webkit.messageHandlers.mole.postMessage({ action: action });
          }
        }
        function pct(value) {
          return typeof value === "number" && isFinite(value) ? value.toFixed(0) + "%" : "--";
        }
        function primaryDisk(snapshot) {
          const disks = snapshot.disks || [];
          return disks.find(function(d) { return d.mount === "/"; }) || disks[0] || {};
        }
        function meter(label, value, color) {
          const width = Math.max(0, Math.min(100, Number(value) || 0));
          return `<div class="metric"><label>${label}</label><div class="bar"><span style="width:${width}%;background:${color}"></span></div><output>${pct(value)}</output></div>`;
        }
        function render() {
          const root = document.getElementById("widget");
          if (!state) {
            root.innerHTML = `<div class="sub">Loading Mole...</div>`;
            return;
          }
          const snap = state.snapshot || {};
          const cpu = (snap.cpu || {}).usage || 0;
          const mem = (snap.memory || {}).used_percent || 0;
          const disk = primaryDisk(snap).used_percent || 0;
          const score = snap.health_score || 0;
          root.innerHTML = `<div class="top"><div class="mark"><svg class="icon" viewBox="0 0 24 24"><path class="draw" d="M4 15c3 0 3-8 5-8 2 0 2 8 5 8s3-5 6-5"/><path class="draw" d="M5 18h14"/></svg></div><div><h1>Mole</h1><div class="sub">mo status --json</div></div></div>
            <div class="ringRow"><div class="ring" style="--value:${score}"><span>${score || "--"}</span></div><div class="status"><strong>${snap.health_score_msg || "Live health"}</strong><span>${(snap.hardware || {}).model || "Local Mac"}</span></div></div>
            <div class="metrics">${meter("CPU", cpu, "var(--cyan)")}${meter("Mem", mem, "var(--violet)")}${meter("Disk", disk, "var(--amber)")}</div>
            <div class="buttons"><button onclick="post('openDashboard')">Open</button><button class="primary" onclick="post('runCommand')">Preview</button></div>`;
        }
        window.moleUpdate = function(payload) { state = payload; render(); };
        render();
      </script>
    </body>
    </html>
    """
}
