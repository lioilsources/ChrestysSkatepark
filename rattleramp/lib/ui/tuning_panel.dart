import 'package:flutter/material.dart';

import 'app.dart';
import 'theme.dart';

/// M0 feel-tuning knobs. Becomes the PIN-gated admin screen in M4.
void showTuningPanel(BuildContext context, Settings settings) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Palette.rampFill,
    builder: (context) => ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        final c = settings.config;
        Widget slider(
          String label,
          double value,
          double min,
          double max,
          String Function(double) fmt,
          void Function(double) set,
        ) => Row(
          children: [
            SizedBox(width: 240, child: Text(label, style: hudStyle.copyWith(fontSize: 16))),
            Expanded(
              child: Slider(value: value.clamp(min, max), min: min, max: max, onChanged: set),
            ),
            SizedBox(width: 90, child: Text(fmt(value), style: hudStyle.copyWith(fontSize: 16))),
          ],
        );
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('LADĚNÍ (M0)', style: hudStyle.copyWith(fontSize: 20, color: Palette.coping)),
              slider(
                'Šířka timing okna',
                c.windowScale,
                0.5,
                2.0,
                (v) => '×${v.toStringAsFixed(2)}',
                (v) => settings.config = c.copyWith(windowScale: v),
              ),
              slider(
                'Latence dotyku',
                c.inputLatency * 1000,
                -50,
                150,
                (v) => '${v.round()} ms',
                (v) => settings.config = c.copyWith(inputLatency: v / 1000),
              ),
              slider(
                'Startovní rychlost',
                c.startSpeed,
                0.1,
                0.9,
                (v) => v.toStringAsFixed(2),
                (v) => settings.config = c.copyWith(startSpeed: v),
              ),
              slider(
                'Předstih kruhu',
                c.cueLead,
                0.5,
                1.6,
                (v) => '${v.toStringAsFixed(2)} s',
                (v) => settings.config = c.copyWith(cueLead: v),
              ),
              Text(
                'Δ v pravém horním rohu jízdy = odchylka posledního puštění od hrany (− brzy, + pozdě).',
                style: hudStyle.copyWith(fontSize: 12, color: Palette.dim),
              ),
            ],
          ),
        );
      },
    ),
  );
}
