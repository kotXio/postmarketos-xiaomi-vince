// SPDX-License-Identifier: MIT
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const vm = require('node:vm');
const { spawnSync } = require('node:child_process');

const packageRoot = path.resolve(__dirname, '../package');
const api = vm.createContext({});
vm.runInContext(fs.readFileSync(path.join(packageRoot, 'contents/ui/Telemetry.js'), 'utf8')
    .replace(/^\.pragma library\n/, ''), api);

for (const [current, text, direction] of [
    [420123, '+420 mA', 'charging'],
    [-307005, '−307 mA', 'discharging'],
    [0, '0 mA', 'idle'],
    [-500, '−0.5 mA', 'discharging'],
    [800, '+0.8 mA', 'charging']
]) {
    const sample = api.parse(JSON.stringify({ voltage: 3836800, current, capacity: 56 }), 0);
    assert.ok(sample);
    assert.equal(api.voltageText(sample), '3.837 V');
    assert.equal(api.currentText(sample), text);
    assert.equal(api.direction(sample), direction);
}
for (const output of [
    '', 'no battery', 'null', '{}',
    '{"voltage":"3836800","current":123,"capacity":56}',
    '{"voltage":0,"current":123,"capacity":56}',
    '{"voltage":3836800,"current":123.5,"capacity":56}',
    '{"voltage":3836800,"current":123,"capacity":101}'
]) {
    assert.equal(api.parse(output, 0), null);
}
assert.equal(api.parse('{"voltage":3836800,"current":0,"capacity":56}', 1), null);
assert.equal(api.voltageText(null), '— V');
assert.equal(api.currentText(null), '— mA');
const withTemperature = api.parse('{"voltage":3836800,"current":0,"capacity":56,"temperature":285}', 0);
assert.equal(api.temperatureText(withTemperature), '28.5 °C');
assert.equal(api.temperatureText(api.parse('{"voltage":3836800,"current":0,"capacity":56}', 0)), '— °C');
assert.equal(api.temperatureText(api.parse('{"voltage":3836800,"current":0,"capacity":56,"temperature":9000}', 0)), '— °C');

const fixture = fs.mkdtempSync(path.join(os.tmpdir(), 'vince-battery-fixture-'));
try {
    const reader = path.join(packageRoot, 'contents/code/read-battery.sh');
    function write(values) {
        for (const [file, value] of Object.entries(values)) {
            fs.writeFileSync(path.join(fixture, file), value + '\n');
        }
    }
    for (const current of ['-307005', '420123', '0']) {
        write({ voltage_now: '3836800', current_now: current, capacity: '56', temp: '285' });
        const result = spawnSync('sh', [reader, fixture], { encoding: 'utf8' });
        assert.equal(result.status, 0, result.stderr);
        assert.equal(api.parse(result.stdout, result.status).current, Number(current));
        assert.equal(api.temperatureText(api.parse(result.stdout, result.status)), '28.5 °C');
    }
    fs.unlinkSync(path.join(fixture, 'temp'));
    const noTemperature = spawnSync('sh', [reader, fixture], { encoding: 'utf8' });
    assert.equal(noTemperature.status, 0);
    assert.equal(api.temperatureText(api.parse(noTemperature.stdout, 0)), '— °C');
    write({ current_now: 'invalid' });
    assert.notEqual(spawnSync('sh', [reader, fixture]).status, 0);
    fs.unlinkSync(path.join(fixture, 'current_now'));
    assert.notEqual(spawnSync('sh', [reader, fixture]).status, 0);
} finally {
    fs.rmSync(fixture, { recursive: true });
}
console.log('PASS: signed current, units, zero, invalid/stale-error display and read-only reader');
