// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class L10nMs extends L10n {
  L10nMs([String locale = 'ms']) : super(locale);

  @override
  String get tapToRide => 'KETIK DAN LUNCUR';

  @override
  String dailyTrick(String trick) {
    return 'HELAH HARI INI: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

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
    return 'JOM!  $seconds';
  }

  @override
  String get wrongTrick => 'HELAH SALAH';

  @override
  String get tooEarly => 'TERLALU AWAL';

  @override
  String get waitForCircle => 'tunggu bulatan';

  @override
  String get noTrick => 'TIADA HELAH';

  @override
  String get losingSpeed => 'kelajuan anda berkurang';

  @override
  String get bailTiming => 'masa tidak tepat';

  @override
  String get bailUnknown => 'helah tidak dikenali';

  @override
  String get bailTooLong => 'helah tidak muat di udara';

  @override
  String get outOfSpeed => 'KELAJUAN HABIS';

  @override
  String get rideOver => 'SESI TAMAT';

  @override
  String get bestTrick => 'HELAH TERBAIK';

  @override
  String get longestCombo => 'COMBO TERPANJANG';

  @override
  String get tricksLanded => 'HELAH';

  @override
  String get avgTiming => 'PURATA MASA';

  @override
  String get tapToContinue => 'KETIK UNTUK TERUSKAN';

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
      'Sepanjang tepi = spin (ikut arah jam FS, lawan arah jam BS) · melalui tengah = grab · rombus = flip. Rangkaikan helah dalam satu lakaran – helah seterusnya bermula di tempat helah sebelumnya berakhir. Angkat jari apabila bulatan menyentuh tepi.';

  @override
  String get spinNote => 'mula di mana-mana pada tepi';

  @override
  String pointsShort(int points) {
    return '$points mata';
  }

  @override
  String get tuningTitle => 'PELARASAN (M0)';

  @override
  String get tuningWindow => 'Lebar tetingkap masa';

  @override
  String get tuningLatency => 'Kependaman sentuhan';

  @override
  String get tuningStartSpeed => 'Kelajuan mula';

  @override
  String get tuningCueLead => 'Masa awal bulatan';

  @override
  String get tuningDeltaHelp => 'Δ di penjuru kanan atas = sisihan lepasan terakhir dari tepi (− awal, + lewat).';

  @override
  String get avatarBeanie => 'Kupiah';

  @override
  String get avatarDreads => 'Dread';

  @override
  String get avatarHelmet => 'Topi Keledar';

  @override
  String get avatarKid => 'Budak';
}
