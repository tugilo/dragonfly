/**
 * Scenario: wp_origin
 * Target: www.cheer-print.com WordPress public pages
 * Does NOT include: wp-admin, login, contact POST, search, xmlrpc
 */
import http from 'k6/http';
import { check, sleep } from 'k6';
import {
  buildStages,
  defaultThresholds,
  envFloat,
  envInt,
  makeHandleSummary,
  requestParams,
} from './lib.js';

const BASE = __ENV.WP_BASE || 'https://www.cheer-print.com';

// Weighted pool (approx 40/25/20/15)
const WEIGHTED = [
  { url: `${BASE}/`, w: 40 },
  { url: `${BASE}/news/`, w: 25 },
  { url: `${BASE}/how-to-purchase/`, w: 10 },
  { url: `${BASE}/bl/`, w: 7 },
  { url: `${BASE}/sports/`, w: 7 },
  { url: `${BASE}/entertainment/`, w: 6 },
  // Optional campaign article (still public GET)
  { url: `${BASE}/news/avexroyalbrats_01/`, w: 5 },
];

function pickUrl() {
  const total = WEIGHTED.reduce((s, x) => s + x.w, 0);
  let r = Math.random() * total;
  for (const item of WEIGHTED) {
    r -= item.w;
    if (r <= 0) return item.url;
  }
  return WEIGHTED[0].url;
}

const maxVu = envInt('MAX_VU', envInt('MAX_VU_WP', 2));

export const options = {
  stages: buildStages(maxVu),
  thresholds: defaultThresholds(),
  summaryTrendStats: ['avg', 'min', 'med', 'max', 'p(90)', 'p(95)', 'p(99)'],
};

export const handleSummary = makeHandleSummary({
  id: 'wp_origin',
  label: 'WordPress 本サイト',
  urls: WEIGHTED.map((x) => x.url),
  maxVu,
});

export default function () {
  const url = pickUrl();
  const res = http.get(url, requestParams());
  check(res, {
    'status is 2xx': (r) => r.status >= 200 && r.status < 300,
  });
  sleep(envFloat('SLEEP', 1));
}
