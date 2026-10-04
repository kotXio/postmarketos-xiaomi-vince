.pragma library
// SPDX-License-Identifier: MIT

function parse(output, exitCode) {
    if (exitCode !== 0) {
        return null;
    }
    try {
        var value = JSON.parse(output);
        if (!value || typeof value !== "object"
                || !Number.isSafeInteger(value.voltage)
                || !Number.isSafeInteger(value.current)
                || !Number.isSafeInteger(value.capacity)
                || value.voltage < 1000000 || value.voltage > 6000000
                || value.capacity < 0 || value.capacity > 100) {
            return null;
        }
        value.temperature = Number.isSafeInteger(value.temperature)
            && value.temperature >= -500 && value.temperature <= 1500
            ? value.temperature : null;
        return value;
    } catch (error) {
        return null;
    }
}

function voltageText(sample) {
    return sample ? (sample.voltage / 1000000).toFixed(3) + " V" : "— V";
}

function currentText(sample) {
    if (!sample) {
        return "— mA";
    }
    var ma = sample.current / 1000;
    var digits = Math.abs(ma) < 10 && ma !== 0 ? 1 : 0;
    var sign = ma > 0 ? "+" : ma < 0 ? "−" : "";
    return sign + Math.abs(ma).toFixed(digits) + " mA";
}

function direction(sample) {
    return !sample ? "unavailable"
        : sample.current > 0 ? "charging"
        : sample.current < 0 ? "discharging" : "idle";
}

function temperatureText(sample) {
    return sample && sample.temperature !== null && sample.temperature !== undefined
        ? (sample.temperature / 10).toFixed(1) + " °C" : "— °C";
}
