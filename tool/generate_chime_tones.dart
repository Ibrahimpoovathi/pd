/// Generates chime tone + ambient bed .wav assets for the Pomodoro timer.
/// Run with: `dart run tool/generate_chime_tones.dart`
///
/// Tones (Stillness-inspired):
/// - warm: 1430 Hz pip, 180ms (default session-end chime)
/// - glass: 2200 Hz clear tone, 150ms
/// - wood: 800 Hz warm knock, 200ms
/// - bowl: 600 Hz resonant, 250ms
/// - start_tick: 880 Hz beep, 120ms (start/pause feedback)
///
/// Ambient beds (60s seamless loops, Stillness algorithms):
/// - brown_noise: leaky-integrator low-pass brown noise
/// - rain_noise: band-pass noise + drop pings
library;

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

void main() {
  const sampleRate = 44100;
  final tones = <String, (double, int)>{
    'warm': (1430.0, 180),
    'glass': (2200.0, 150),
    'wood': (800.0, 200),
    'bowl': (600.0, 250),
    'start_tick': (880.0, 120),
  };

  final outDir = Directory('assets/tones');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);

  for (final entry in tones.entries) {
    final name = entry.key;
    final (freq, durMs) = entry.value;
    final samples = _generateTone(freq, durMs, sampleRate);
    final wav = _encodeWav(samples, sampleRate);
    final file = File('assets/tones/$name.wav');
    file.writeAsBytesSync(wav);
    // ignore: avoid_print
    print('Wrote ${file.path} (${wav.length} bytes)');
  }

  // 60-second seamless ambient loops (Stillness algorithms).
  const ambientSeconds = 60;
  final brown = _generateBrown(ambientSeconds, sampleRate, seed: 42);
  final brownWav = _encodeWav(brown, sampleRate);
  final brownFile = File('assets/tones/brown_noise.wav');
  brownFile.writeAsBytesSync(brownWav);
  // ignore: avoid_print
  print('Wrote ${brownFile.path} (${brownWav.length} bytes)');

  final rain = _generateRain(ambientSeconds, sampleRate, seed: 7);
  final rainWav = _encodeWav(rain, sampleRate);
  final rainFile = File('assets/tones/rain_noise.wav');
  rainFile.writeAsBytesSync(rainWav);
  // ignore: avoid_print
  print('Wrote ${rainFile.path} (${rainWav.length} bytes)');
}

/// Generates seamless brown noise (leaky integrator, Stillness params).
/// Crossfades the tail into the head for gapless looping.
Int16List _generateBrown(int seconds, int sampleRate, {required int seed}) {
  final count = sampleRate * seconds;
  final rng = math.Random(seed);
  final raw = Float64List(count);
  var brownLast = 0.0;
  var lp = 0.0;
  const brownAlpha = 0.12;
  for (var i = 0; i < count; i++) {
    final white = rng.nextDouble() * 2 - 1;
    brownLast = (brownLast + 0.02 * white) / 1.02;
    var brown = brownLast * 3.5;
    lp = lp + brownAlpha * (brown - lp);
    raw[i] = lp * 0.52 * 0.55;
  }
  return _seamless(raw);
}

/// Generates seamless rain bed (band-pass + drop pings, Stillness params).
Int16List _generateRain(int seconds, int sampleRate, {required int seed}) {
  final count = sampleRate * seconds;
  final rng = math.Random(seed);
  final raw = Float64List(count);
  var brownLast = 0.0;
  var bp1 = 0.0;
  var bp2 = 0.0;
  var dropCounter = 0;
  var dropFreq = 1100.0;
  var dropGainCur = 0.0;
  var phase = 0.0;
  for (var i = 0; i < count; i++) {
    final white = rng.nextDouble() * 2 - 1;
    brownLast = (brownLast + 0.02 * white) / 1.02;
    final brown = brownLast * 3.5;
    bp1 = bp1 + 0.12 * (brown - bp1);
    final rainRaw = brown - bp1;
    bp2 = bp2 + 0.08 * (rainRaw - bp2);
    var rain = bp2 * 1.4;
    if (rng.nextDouble() < 0.0002) {
      dropCounter = 600;
      dropFreq = 1000 + rng.nextDouble() * 300;
      dropGainCur = 0.30;
    }
    if (dropCounter > 0) {
      final decay = dropCounter / 600.0;
      rain += math.sin(2 * math.pi * dropFreq * phase) *
          dropGainCur *
          decay *
          decay *
          0.5 *
          0.32;
      dropCounter--;
      phase += 2 * math.pi * dropFreq / sampleRate;
    } else {
      phase += 2 * math.pi * 10.0 / sampleRate;
    }
    raw[i] = rain * 0.24 * 0.55;
  }
  return _seamless(raw);
}

/// Applies a 2s raised-cosine crossfade between tail and head,
/// then quantizes to 16-bit PCM.
Int16List _seamless(Float64List raw) {
  const fadeSeconds = 2;
  final sampleRate = 44100;
  final fade = fadeSeconds * sampleRate;
  final n = raw.length;
  final out = Int16List(n);
  for (var i = 0; i < n; i++) {
    double v = raw[i];
    if (i < fade) {
      // Crossfade head with tail for seamless loop.
      final t = i / fade;
      final w = 0.5 - 0.5 * math.cos(math.pi * t);
      v = raw[i] * w + raw[n - fade + i] * (1 - w);
    }
    out[i] = (v * 32767).round().clamp(-32768, 32767);
  }
  return out;
}

/// Generates a sine tone with exponential decay envelope.
Int16List _generateTone(double freq, int durMs, int sampleRate) {
  final count = (sampleRate * durMs / 1000).round();
  final samples = Int16List(count);
  for (var i = 0; i < count; i++) {
    final t = i / sampleRate;
    // Exponential decay envelope for a bell-like feel
    final decay = math.exp(-3.0 * i / count);
    final value = math.sin(2 * math.pi * freq * t) * decay;
    samples[i] = (value * 32767).round().clamp(-32768, 32767);
  }
  return samples;
}

/// Encodes 16-bit mono PCM samples as a WAV file.
Uint8List _encodeWav(Int16List samples, int sampleRate) {
  final dataSize = samples.length * 2;
  final buffer = ByteData(44 + dataSize);

  // RIFF header
  _writeString(buffer, 0, 'RIFF');
  buffer.setUint32(4, 36 + dataSize, Endian.little);
  _writeString(buffer, 8, 'WAVE');

  // fmt chunk
  _writeString(buffer, 12, 'fmt ');
  buffer.setUint32(16, 16, Endian.little); // chunk size
  buffer.setUint16(20, 1, Endian.little); // PCM
  buffer.setUint16(22, 1, Endian.little); // mono
  buffer.setUint32(24, sampleRate, Endian.little);
  buffer.setUint32(28, sampleRate * 2, Endian.little); // byte rate
  buffer.setUint16(32, 2, Endian.little); // block align
  buffer.setUint16(34, 16, Endian.little); // bits per sample

  // data chunk
  _writeString(buffer, 36, 'data');
  buffer.setUint32(40, dataSize, Endian.little);
  for (var i = 0; i < samples.length; i++) {
    buffer.setInt16(44 + i * 2, samples[i], Endian.little);
  }

  return buffer.buffer.asUint8List();
}

void _writeString(ByteData buffer, int offset, String s) {
  for (var i = 0; i < s.length; i++) {
    buffer.setUint8(offset + i, s.codeUnitAt(i));
  }
}
