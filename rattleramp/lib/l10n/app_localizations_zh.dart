// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get tapToRide => '点击开滑';

  @override
  String dailyTrick(String trick) {
    return '今日招式：$trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return '风格：$style';
  }

  @override
  String get styleNeon => '霓虹';

  @override
  String get styleComic => '漫画';

  @override
  String get stylePixel => '像素';

  @override
  String goCountdown(int seconds) {
    return '出发！  $seconds';
  }

  @override
  String get wrongTrick => '招式错误';

  @override
  String get tooEarly => '太早了';

  @override
  String get waitForCircle => '等待圆圈';

  @override
  String get noTrick => '没有招式';

  @override
  String get losingSpeed => '你在减速';

  @override
  String get bailTiming => '时机不对';

  @override
  String get bailUnknown => '未知招式';

  @override
  String get bailTooLong => '招式在空中没做完';

  @override
  String get outOfSpeed => '速度耗尽';

  @override
  String get rideOver => '滑行结束';

  @override
  String get bestTrick => '最佳招式';

  @override
  String get longestCombo => '最长连招';

  @override
  String get tricksLanded => '招式数';

  @override
  String get avgTiming => '平均时机';

  @override
  String get tapToContinue => '点击继续';

  @override
  String get tabGrabs => '抓板';

  @override
  String get tabFlips => '翻板';

  @override
  String get tabSpins => '转体';

  @override
  String get tabCombos => '连招';

  @override
  String get trickBookHelp => '沿外圈 = 转体（顺时针 FS，逆时针 BS）· 经过中心 = 抓板 · 菱形 = 翻板。一笔连出多个招式——下一个从上一个结束的地方开始。圆圈落到边缘时松开手指。';

  @override
  String get spinNote => '从外圈任意位置开始';

  @override
  String pointsShort(int points) {
    return '$points 分';
  }

  @override
  String get tuningTitle => '调校 (M0)';

  @override
  String get tuningWindow => '时机窗口宽度';

  @override
  String get tuningLatency => '触控延迟';

  @override
  String get tuningStartSpeed => '起始速度';

  @override
  String get tuningCueLead => '圆圈提前量';

  @override
  String get tuningDeltaHelp => '滑行时右上角的 Δ = 最后一次松手与边缘的偏差（− 早，+ 晚）。';

  @override
  String get avatarBeanie => '毛线帽';

  @override
  String get avatarDreads => '脏辫';

  @override
  String get avatarHelmet => '头盔';

  @override
  String get avatarKid => '小不点';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class L10nZhHans extends L10nZh {
  L10nZhHans() : super('zh_Hans');

  @override
  String get tapToRide => '点击开滑';

  @override
  String dailyTrick(String trick) {
    return '今日招式：$trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return '风格：$style';
  }

  @override
  String get styleNeon => '霓虹';

  @override
  String get styleComic => '漫画';

  @override
  String get stylePixel => '像素';

  @override
  String goCountdown(int seconds) {
    return '出发！  $seconds';
  }

  @override
  String get wrongTrick => '招式错误';

  @override
  String get tooEarly => '太早了';

  @override
  String get waitForCircle => '等待圆圈';

  @override
  String get noTrick => '没有招式';

  @override
  String get losingSpeed => '你在减速';

  @override
  String get bailTiming => '时机不对';

  @override
  String get bailUnknown => '未知招式';

  @override
  String get bailTooLong => '招式在空中没做完';

  @override
  String get outOfSpeed => '速度耗尽';

  @override
  String get rideOver => '滑行结束';

  @override
  String get bestTrick => '最佳招式';

  @override
  String get longestCombo => '最长连招';

  @override
  String get tricksLanded => '招式数';

  @override
  String get avgTiming => '平均时机';

  @override
  String get tapToContinue => '点击继续';

  @override
  String get tabGrabs => '抓板';

  @override
  String get tabFlips => '翻板';

  @override
  String get tabSpins => '转体';

  @override
  String get tabCombos => '连招';

  @override
  String get trickBookHelp => '沿外圈 = 转体（顺时针 FS，逆时针 BS）· 经过中心 = 抓板 · 菱形 = 翻板。一笔连出多个招式——下一个从上一个结束的地方开始。圆圈落到边缘时松开手指。';

  @override
  String get spinNote => '从外圈任意位置开始';

  @override
  String pointsShort(int points) {
    return '$points 分';
  }

  @override
  String get tuningTitle => '调校 (M0)';

  @override
  String get tuningWindow => '时机窗口宽度';

  @override
  String get tuningLatency => '触控延迟';

  @override
  String get tuningStartSpeed => '起始速度';

  @override
  String get tuningCueLead => '圆圈提前量';

  @override
  String get tuningDeltaHelp => '滑行时右上角的 Δ = 最后一次松手与边缘的偏差（− 早，+ 晚）。';

  @override
  String get avatarBeanie => '毛线帽';

  @override
  String get avatarDreads => '脏辫';

  @override
  String get avatarHelmet => '头盔';

  @override
  String get avatarKid => '小不点';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class L10nZhHant extends L10nZh {
  L10nZhHant() : super('zh_Hant');

  @override
  String get tapToRide => '點擊開滑';

  @override
  String dailyTrick(String trick) {
    return '今日招式：$trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return '風格：$style';
  }

  @override
  String get styleNeon => '霓虹';

  @override
  String get styleComic => '漫畫';

  @override
  String get stylePixel => '像素';

  @override
  String goCountdown(int seconds) {
    return '出發！  $seconds';
  }

  @override
  String get wrongTrick => '招式錯誤';

  @override
  String get tooEarly => '太早了';

  @override
  String get waitForCircle => '等待圓圈';

  @override
  String get noTrick => '沒有招式';

  @override
  String get losingSpeed => '你在減速';

  @override
  String get bailTiming => '時機不對';

  @override
  String get bailUnknown => '未知招式';

  @override
  String get bailTooLong => '招式在空中沒做完';

  @override
  String get outOfSpeed => '速度耗盡';

  @override
  String get rideOver => '滑行結束';

  @override
  String get bestTrick => '最佳招式';

  @override
  String get longestCombo => '最長連招';

  @override
  String get tricksLanded => '招式數';

  @override
  String get avgTiming => '平均時機';

  @override
  String get tapToContinue => '點擊繼續';

  @override
  String get tabGrabs => '抓板';

  @override
  String get tabFlips => '翻板';

  @override
  String get tabSpins => '轉體';

  @override
  String get tabCombos => '連招';

  @override
  String get trickBookHelp => '沿外圈 = 轉體（順時針 FS，逆時針 BS）· 經過中心 = 抓板 · 菱形 = 翻板。一筆連出多個招式——下一個從上一個結束的地方開始。圓圈落到邊緣時放開手指。';

  @override
  String get spinNote => '從外圈任意位置開始';

  @override
  String pointsShort(int points) {
    return '$points 分';
  }

  @override
  String get tuningTitle => '調校 (M0)';

  @override
  String get tuningWindow => '時機窗口寬度';

  @override
  String get tuningLatency => '觸控延遲';

  @override
  String get tuningStartSpeed => '起始速度';

  @override
  String get tuningCueLead => '圓圈提前量';

  @override
  String get tuningDeltaHelp => '滑行時右上角的 Δ = 最後一次放開與邊緣的偏差（− 早，+ 晚）。';

  @override
  String get avatarBeanie => '毛線帽';

  @override
  String get avatarDreads => '髒辮';

  @override
  String get avatarHelmet => '頭盔';

  @override
  String get avatarKid => '小不點';
}
