// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class L10nId extends L10n {
  L10nId([String locale = 'id']) : super(locale);

  @override
  String get tapToRide => 'KETUK DAN MELUNCUR';

  @override
  String dailyTrick(String trick) {
    return 'TRIK HARI INI: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'GAYA: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'KOMIK';

  @override
  String get stylePixel => 'PIKSEL';

  @override
  String goCountdown(int seconds) {
    return 'AYO!  $seconds';
  }

  @override
  String get wrongTrick => 'TRIK SALAH';

  @override
  String get tooEarly => 'TERLALU CEPAT';

  @override
  String get waitForCircle => 'tunggu lingkarannya';

  @override
  String get noTrick => 'TANPA TRIK';

  @override
  String get losingSpeed => 'kecepatanmu turun';

  @override
  String get bailTiming => 'timing buruk';

  @override
  String get bailUnknown => 'trik tak dikenal';

  @override
  String get bailTooLong => 'trik tidak muat di udara';

  @override
  String get outOfSpeed => 'KEHABISAN KECEPATAN';

  @override
  String get rideOver => 'SESI SELESAI';

  @override
  String get bestTrick => 'TRIK TERBAIK';

  @override
  String get longestCombo => 'COMBO TERPANJANG';

  @override
  String get tricksLanded => 'TRIK';

  @override
  String get avgTiming => 'TIMING RATA-RATA';

  @override
  String get tapToContinue => 'KETUK UNTUK LANJUT';

  @override
  String get tabGrabs => 'GRAB';

  @override
  String get tabFlips => 'FLIP';

  @override
  String get tabSpins => 'SPIN';

  @override
  String get tabCombos => 'COMBO';

  @override
  String get trickBookHelp =>
      'Menyusuri tepi = spin (searah jarum jam FS, berlawanan BS) · lewat tengah = grab · belah ketupat = flip. Sambung trik dalam satu tarikan – trik berikutnya mulai di tempat trik sebelumnya berakhir. Angkat jari saat lingkaran menyentuh tepi.';

  @override
  String get spinNote => 'mulai di mana saja di tepi';

  @override
  String pointsShort(int points) {
    return '$points poin';
  }

  @override
  String get tuningTitle => 'PENYETELAN (M0)';

  @override
  String get tuningWindow => 'Lebar jendela timing';

  @override
  String get tuningLatency => 'Latensi sentuhan';

  @override
  String get tuningStartSpeed => 'Kecepatan awal';

  @override
  String get tuningCueLead => 'Jeda awal lingkaran';

  @override
  String get tuningDeltaHelp => 'Δ di pojok kanan atas = selisih lepasan terakhir dari tepi (− cepat, + lambat).';

  @override
  String get avatarBeanie => 'Kupluk';

  @override
  String get avatarDreads => 'Gimbal';

  @override
  String get avatarHelmet => 'Helm';

  @override
  String get avatarKid => 'Bocil';
}
