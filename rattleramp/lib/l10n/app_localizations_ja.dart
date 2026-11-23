// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get tapToRide => 'タップしてスタート';

  @override
  String dailyTrick(String trick) {
    return '今日のトリック：$trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'スタイル：$style';
  }

  @override
  String get styleNeon => 'ネオン';

  @override
  String get styleComic => 'コミック';

  @override
  String get stylePixel => 'ピクセル';

  @override
  String goCountdown(int seconds) {
    return 'ゴー！  $seconds';
  }

  @override
  String get wrongTrick => 'トリック失敗';

  @override
  String get tooEarly => '早すぎ';

  @override
  String get waitForCircle => 'サークルを待って';

  @override
  String get noTrick => 'トリックなし';

  @override
  String get losingSpeed => 'スピードが落ちている';

  @override
  String get bailTiming => 'タイミングが悪い';

  @override
  String get bailUnknown => '不明なトリック';

  @override
  String get bailTooLong => 'トリックがエア中に収まらない';

  @override
  String get outOfSpeed => 'スピード切れ';

  @override
  String get rideOver => 'ライド終了';

  @override
  String get bestTrick => 'ベストトリック';

  @override
  String get longestCombo => '最長コンボ';

  @override
  String get tricksLanded => 'トリック数';

  @override
  String get avgTiming => '平均タイミング';

  @override
  String get tapToContinue => 'タップして続ける';

  @override
  String get tabGrabs => 'グラブ';

  @override
  String get tabFlips => 'フリップ';

  @override
  String get tabSpins => 'スピン';

  @override
  String get tabCombos => 'コンボ';

  @override
  String get trickBookHelp =>
      '外周をなぞる＝スピン（時計回りFS、反時計回りBS）・中央を通る＝グラブ・ひし形＝フリップ。トリックはひと筆でつなげる。次のトリックは前のトリックが終わった所から始まる。サークルがエッジに重なったら指を離す。';

  @override
  String get spinNote => '外周のどこからでも始められる';

  @override
  String pointsShort(int points) {
    return '$points点';
  }

  @override
  String get tuningTitle => '調整 (M0)';

  @override
  String get tuningWindow => 'タイミング幅';

  @override
  String get tuningLatency => 'タッチ遅延';

  @override
  String get tuningStartSpeed => 'スタート速度';

  @override
  String get tuningCueLead => 'サークルの先行時間';

  @override
  String get tuningDeltaHelp => 'ライド中右上のΔ＝最後に指を離したタイミングとエッジのずれ（−早い、＋遅い）。';

  @override
  String get avatarBeanie => 'ニット帽';

  @override
  String get avatarDreads => 'ドレッド';

  @override
  String get avatarHelmet => 'ヘルメット';

  @override
  String get avatarKid => 'チビ';
}
