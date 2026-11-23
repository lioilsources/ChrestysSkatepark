// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class L10nTr extends L10n {
  L10nTr([String locale = 'tr']) : super(locale);

  @override
  String get tapToRide => 'DOKUN VE KAY';

  @override
  String dailyTrick(String trick) {
    return 'GÜNÜN HAREKETİ: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'STİL: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'ÇİZGİ ROMAN';

  @override
  String get stylePixel => 'PİKSEL';

  @override
  String goCountdown(int seconds) {
    return 'BAŞLA!  $seconds';
  }

  @override
  String get wrongTrick => 'YANLIŞ HAREKET';

  @override
  String get tooEarly => 'ÇOK ERKEN';

  @override
  String get waitForCircle => 'çemberi bekle';

  @override
  String get noTrick => 'HAREKET YOK';

  @override
  String get losingSpeed => 'hız kaybediyorsun';

  @override
  String get bailTiming => 'kötü zamanlama';

  @override
  String get bailUnknown => 'bilinmeyen hareket';

  @override
  String get bailTooLong => 'hareket havaya sığmadı';

  @override
  String get outOfSpeed => 'HIZ BİTTİ';

  @override
  String get rideOver => 'SÜRÜŞ BİTTİ';

  @override
  String get bestTrick => 'EN İYİ HAREKET';

  @override
  String get longestCombo => 'EN UZUN KOMBO';

  @override
  String get tricksLanded => 'HAREKET';

  @override
  String get avgTiming => 'ORTALAMA ZAMANLAMA';

  @override
  String get tapToContinue => 'DEVAM ETMEK İÇİN DOKUN';

  @override
  String get tabGrabs => 'GRABLER';

  @override
  String get tabFlips => 'FLIPLER';

  @override
  String get tabSpins => 'SPINLER';

  @override
  String get tabCombos => 'KOMBOLAR';

  @override
  String get trickBookHelp =>
      'Kenar boyunca = spin (saat yönünde FS, tersine BS) · ortadan = grab · eşkenar dörtgen = flip. Hareketleri tek çizgide bağla – sonraki, öncekinin bittiği yerden başlar. Çember kenara değdiğinde parmağını kaldır.';

  @override
  String get spinNote => 'kenarda herhangi bir yerden başla';

  @override
  String pointsShort(int points) {
    return '$points puan';
  }

  @override
  String get tuningTitle => 'AYAR (M0)';

  @override
  String get tuningWindow => 'Zamanlama penceresi genişliği';

  @override
  String get tuningLatency => 'Dokunma gecikmesi';

  @override
  String get tuningStartSpeed => 'Başlangıç hızı';

  @override
  String get tuningCueLead => 'Çember ön süresi';

  @override
  String get tuningDeltaHelp => 'Δ sağ üst köşede = son bırakışın kenardan sapması (− erken, + geç).';

  @override
  String get avatarBeanie => 'Bere';

  @override
  String get avatarDreads => 'Rasta';

  @override
  String get avatarHelmet => 'Kask';

  @override
  String get avatarKid => 'Ufaklık';
}
