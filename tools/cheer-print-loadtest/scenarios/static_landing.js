/**
 * Scenario: static_landing
 * Target: cheer--print.com event static page (告知入口)
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

const BASE = __ENV.STATIC_BASE || 'https://cheer--print.com';
const PAGES = [`${BASE}/a-expo-fream/`];

const maxVu = envInt('MAX_VU', envInt('MAX_VU_STATIC', 2));

export const options = {
  stages: buildStages(maxVu),
  thresholds: defaultThresholds(),
  summaryTrendStats: ['avg', 'min', 'med', 'max', 'p(90)', 'p(95)', 'p(99)'],
};

export const handleSummary = makeHandleSummary({
  id: 'static_landing',
  label: '静的入口（告知URL）',
  urls: PAGES,
  maxVu,
});

export default function () {
  const url = PAGES[Math.floor(Math.random() * PAGES.length)];
  const res = http.get(url, requestParams());
  check(res, {
    'status is 2xx': (r) => r.status >= 200 && r.status < 300,
  });
  sleep(envFloat('SLEEP', 1));
}
