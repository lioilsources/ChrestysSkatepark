/// All tunable numbers for the ride. M0 is about tuning these on the real
/// tablet — keep every feel-related constant here, nowhere else.
library;

class RideConfig {
  // ── Ramp geometry (metres) ────────────────────────────────────────────
  final double rampRadius;
  final double flatWidth;
  final double vertHeight;
  final double gravity;

  // ── Speed ─────────────────────────────────────────────────────────────
  /// Normalised speed 0…1 maps to coping launch velocity [vLow]…[vHigh] m/s.
  final double vLow;
  final double vHigh;
  final double startSpeed;
  final double gainPerfect;
  final double gainGood;
  final double lossLate;

  /// Extra gain per trick grade (longer tricks pump more).
  final double gainPerGrade;

  /// Loss for an air without a trick; below 0 the skater can't reach coping.
  final double lossEmptyAir;

  // ── Timing (seconds, relative to leaving the coping) ──────────────────
  final double perfectWindow;
  final double goodWindow;
  final double lateWindow;

  /// Windows shrink linearly to this factor at full speed.
  final double windowScaleAtMaxSpeed;

  /// Global admin multiplier on all windows.
  final double windowScale;

  /// How long before the edge the cue appears; releases earlier are ignored.
  final double cueLead;

  /// Subtracted from every release timestamp to compensate touch latency.
  final double inputLatency;

  // ── Trick playback ────────────────────────────────────────────────────
  final double secondsPerMove;
  final double secondsPerToken;

  // ── Simulation ────────────────────────────────────────────────────────
  final double dt;
  final double dropInDelay;
  final double bailDuration;

  const RideConfig({
    this.rampRadius = 3.0,
    this.flatWidth = 4.0,
    this.vertHeight = 0.3,
    this.gravity = 9.81,
    this.vLow = 2.8,
    this.vHigh = 6.6,
    this.startSpeed = 0.4,
    this.gainPerfect = 0.08,
    this.gainGood = 0.04,
    this.lossLate = 0.05,
    this.gainPerGrade = 0.012,
    this.lossEmptyAir = 0.18,
    this.perfectWindow = 0.05,
    this.goodWindow = 0.11,
    this.lateWindow = 0.2,
    this.windowScaleAtMaxSpeed = 0.7,
    this.windowScale = 1.0,
    this.cueLead = 1.0,
    this.inputLatency = 0.0,
    this.secondsPerMove = 0.05,
    this.secondsPerToken = 0.08,
    this.dt = 1 / 120,
    this.dropInDelay = 0.6,
    this.bailDuration = 1.6,
  });

  /// Only the knobs exposed in the tuning panel (admin in M4).
  RideConfig copyWith({double? startSpeed, double? windowScale, double? inputLatency, double? cueLead}) => RideConfig(
    rampRadius: rampRadius,
    flatWidth: flatWidth,
    vertHeight: vertHeight,
    gravity: gravity,
    vLow: vLow,
    vHigh: vHigh,
    startSpeed: startSpeed ?? this.startSpeed,
    gainPerfect: gainPerfect,
    gainGood: gainGood,
    lossLate: lossLate,
    gainPerGrade: gainPerGrade,
    lossEmptyAir: lossEmptyAir,
    perfectWindow: perfectWindow,
    goodWindow: goodWindow,
    lateWindow: lateWindow,
    windowScaleAtMaxSpeed: windowScaleAtMaxSpeed,
    windowScale: windowScale ?? this.windowScale,
    cueLead: cueLead ?? this.cueLead,
    inputLatency: inputLatency ?? this.inputLatency,
    secondsPerMove: secondsPerMove,
    secondsPerToken: secondsPerToken,
    dt: dt,
    dropInDelay: dropInDelay,
    bailDuration: bailDuration,
  );

  double get copingHeight => rampRadius + vertHeight;

  double launchVelocity(double speed) => vLow + (vHigh - vLow) * speed.clamp(0.0, 1.0);

  double windowFactor(double speed) => windowScale * (1 - (1 - windowScaleAtMaxSpeed) * speed.clamp(0.0, 1.0));
}
