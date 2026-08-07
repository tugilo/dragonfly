/**
 * Cheer Print loadtest — shared helpers (k6)
 * Forbidden by default: wp-admin, login, contact POST, search bombing, xmlrpc
 */

import { textSummary } from 'https://jslib.k6.io/k6-summary/0.0.4/index.js';

export const UA = 'cheer-print-loadtest/1.0 (authorized; tugilo-local-docker)';

export function envInt(name, fallback) {
  const v = __ENV[name];
  if (v === undefined || v === '') return fallback;
  const n = parseInt(v, 10);
  return Number.isFinite(n) ? n : fallback;
}

export function envFloat(name, fallback) {
  const v = __ENV[name];
  if (v === undefined || v === '') return fallback;
  const n = parseFloat(v);
  return Number.isFinite(n) ? n : fallback;
}

export function profileName() {
  return (__ENV.PROFILE || 'dry').toLowerCase();
}

/**
 * Stage A/B/C for full; short smoke for dry.
 * MAX_VU caps the peak.
 */
export function buildStages(maxVu) {
  const profile = profileName();
  const cap = Math.max(1, maxVu);

  if (profile === 'dry') {
    const vu = Math.min(2, cap);
    return [
      { duration: '15s', target: vu },
      { duration: '20s', target: vu },
      { duration: '10s', target: 0 },
    ];
  }

  // full: A → B ramp → C hold → ramp down
  const a = Math.min(20, cap);
  const b1 = Math.min(50, cap);
  const b2 = Math.min(100, cap);
  const c = Math.min(cap, Math.max(b2, a));

  return [
    { duration: '2m', target: a }, // Stage A
    { duration: '3m', target: b1 }, // Stage B
    { duration: '3m', target: b2 }, // Stage B peak
    { duration: '5m', target: c }, // Stage C
    { duration: '1m', target: 0 },
  ];
}

export function defaultThresholds() {
  // Soft enough for dry; still flags severe failure in full.
  return {
    http_req_failed: ['rate<0.05'],
    http_req_duration: ['p(95)<5000'],
  };
}

export function requestParams() {
  const timeout = `${envInt('TIMEOUT_MS', 30000)}ms`;
  return {
    headers: { 'User-Agent': UA },
    timeout,
  };
}

function metricValue(data, name, agg) {
  const m = data.metrics && data.metrics[name];
  if (!m || !m.values) return null;
  return m.values[agg] !== undefined ? m.values[agg] : null;
}

export function buildSummaryPayload(data, scenarioMeta) {
  const failed = metricValue(data, 'http_req_failed', 'rate');
  const successRate =
    failed === null || failed === undefined ? null : Math.max(0, 1 - failed);

  return {
    scenario_id: scenarioMeta.id,
    scenario_label: scenarioMeta.label,
    profile: profileName(),
    stamp: __ENV.STAMP || '',
    source: __ENV.SOURCE || 'local-docker',
    generated_at_utc: new Date().toISOString(),
    urls: scenarioMeta.urls || [],
    max_vu_configured: scenarioMeta.maxVu,
    sleep_sec: envFloat('SLEEP', 1),
    metrics: {
      http_reqs: metricValue(data, 'http_reqs', 'count'),
      http_reqs_rate: metricValue(data, 'http_reqs', 'rate'),
      http_req_failed_rate: failed,
      success_rate: successRate,
      http_req_duration_avg_ms: metricValue(data, 'http_req_duration', 'avg'),
      http_req_duration_p50_ms: metricValue(data, 'http_req_duration', 'med'),
      http_req_duration_p95_ms: metricValue(data, 'http_req_duration', 'p(95)'),
      http_req_duration_p99_ms: metricValue(data, 'http_req_duration', 'p(99)'),
      vus_max: metricValue(data, 'vus_max', 'max'),
      iteration_duration_avg_ms: metricValue(data, 'iteration_duration', 'avg'),
    },
    root_group_checks: data.root_group || null,
  };
}

export function makeHandleSummary(scenarioMeta) {
  return function handleSummary(data) {
    const stamp = __ENV.STAMP || 'nostamp';
    const id = scenarioMeta.id;
    const payload = buildSummaryPayload(data, scenarioMeta);
    const jsonPath = `results/summary_${id}_${stamp}.json`;

    return {
      stdout: textSummary(data, { indent: ' ', enableColors: true }),
      [jsonPath]: JSON.stringify(payload, null, 2),
    };
  };
}
