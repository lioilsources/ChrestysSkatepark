// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class L10nEl extends L10n {
  L10nEl([String locale = 'el']) : super(locale);

  @override
  String get tapToRide => 'ΠΑΤΑ ΚΑΙ ΚΥΛΑ';

  @override
  String dailyTrick(String trick) {
    return 'ΚΟΛΠΟ ΤΗΣ ΗΜΕΡΑΣ: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'ΣΤΥΛ: $style';
  }

  @override
  String get styleNeon => 'ΝΕΟΝ';

  @override
  String get styleComic => 'ΚΟΜΙΚ';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'ΦΥΓΑΜΕ!  $seconds';
  }

  @override
  String get wrongTrick => 'ΛΑΘΟΣ ΚΟΛΠΟ';

  @override
  String get tooEarly => 'ΠΟΛΥ ΝΩΡΙΣ';

  @override
  String get waitForCircle => 'περίμενε τον κύκλο';

  @override
  String get noTrick => 'ΧΩΡΙΣ ΚΟΛΠΟ';

  @override
  String get losingSpeed => 'χάνεις ταχύτητα';

  @override
  String get bailTiming => 'κακός συγχρονισμός';

  @override
  String get bailUnknown => 'άγνωστο κόλπο';

  @override
  String get bailTooLong => 'το κόλπο δεν χώρεσε στον αέρα';

  @override
  String get outOfSpeed => 'ΤΕΛΕΙΩΣΕ Η ΤΑΧΥΤΗΤΑ';

  @override
  String get rideOver => 'ΤΕΛΟΣ ΔΙΑΔΡΟΜΗΣ';

  @override
  String get bestTrick => 'ΚΑΛΥΤΕΡΟ ΚΟΛΠΟ';

  @override
  String get longestCombo => 'ΜΕΓΑΛΥΤΕΡΟ COMBO';

  @override
  String get tricksLanded => 'ΚΟΛΠΑ';

  @override
  String get avgTiming => 'ΜΕΣΟΣ ΣΥΓΧΡΟΝΙΣΜΟΣ';

  @override
  String get tapToContinue => 'ΠΑΤΑ ΓΙΑ ΣΥΝΕΧΕΙΑ';

  @override
  String get tabGrabs => 'GRABS';

  @override
  String get tabFlips => 'FLIPS';

  @override
  String get tabSpins => 'SPINS';

  @override
  String get tabCombos => 'COMBOS';

  @override
  String get trickBookHelp =>
      'Γύρω από την άκρη = spin (δεξιόστροφα FS, αριστερόστροφα BS) · από το κέντρο = grab · ρόμβος = flip. Ένωσε κόλπα με μία κίνηση – το επόμενο ξεκινά εκεί που τελείωσε το προηγούμενο. Άφησε το δάχτυλο όταν ο κύκλος ακουμπήσει την άκρη.';

  @override
  String get spinNote => 'ξεκίνα οπουδήποτε στην άκρη';

  @override
  String pointsShort(int points) {
    return '$points πόντοι';
  }

  @override
  String get tuningTitle => 'ΡΥΘΜΙΣΗ (M0)';

  @override
  String get tuningWindow => 'Πλάτος παραθύρου συγχρονισμού';

  @override
  String get tuningLatency => 'Καθυστέρηση αφής';

  @override
  String get tuningStartSpeed => 'Αρχική ταχύτητα';

  @override
  String get tuningCueLead => 'Προπορεία κύκλου';

  @override
  String get tuningDeltaHelp => 'Δ πάνω δεξιά = απόκλιση της τελευταίας απελευθέρωσης από την άκρη (− νωρίς, + αργά).';

  @override
  String get avatarBeanie => 'Σκουφάκι';

  @override
  String get avatarDreads => 'Ράστα';

  @override
  String get avatarHelmet => 'Κράνος';

  @override
  String get avatarKid => 'Πιτσιρίκος';
}
