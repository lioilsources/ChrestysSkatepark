// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class L10nFr extends L10n {
  L10nFr([String locale = 'fr']) : super(locale);

  @override
  String get tapToRide => 'TOUCHE ET ROULE';

  @override
  String dailyTrick(String trick) {
    return 'FIGURE DU JOUR : $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'STYLE : $style';
  }

  @override
  String get styleNeon => 'NÉON';

  @override
  String get styleComic => 'BD';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'GO !  $seconds';
  }

  @override
  String get wrongTrick => 'MAUVAISE FIGURE';

  @override
  String get tooEarly => 'TROP TÔT';

  @override
  String get waitForCircle => 'attends le cercle';

  @override
  String get noTrick => 'SANS FIGURE';

  @override
  String get losingSpeed => 'tu perds de la vitesse';

  @override
  String get bailTiming => 'mauvais timing';

  @override
  String get bailUnknown => 'figure inconnue';

  @override
  String get bailTooLong => 'la figure n\'a pas tenu dans le saut';

  @override
  String get outOfSpeed => 'PLUS DE VITESSE';

  @override
  String get rideOver => 'FIN DU RIDE';

  @override
  String get bestTrick => 'MEILLEURE FIGURE';

  @override
  String get longestCombo => 'PLUS LONG COMBO';

  @override
  String get tricksLanded => 'FIGURES';

  @override
  String get avgTiming => 'TIMING MOYEN';

  @override
  String get tapToContinue => 'TOUCHE POUR CONTINUER';

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
      'Sur le bord = spin (sens horaire FS, antihoraire BS) · par le centre = grab · losange = flip. Enchaîne les figures d\'un seul trait – la suivante commence là où la précédente s\'est arrêtée. Lâche le doigt quand le cercle touche le bord.';

  @override
  String get spinNote => 'commence n\'importe où sur le bord';

  @override
  String pointsShort(int points) {
    return '$points pts';
  }

  @override
  String get tuningTitle => 'RÉGLAGES (M0)';

  @override
  String get tuningWindow => 'Largeur de la fenêtre de timing';

  @override
  String get tuningLatency => 'Latence tactile';

  @override
  String get tuningStartSpeed => 'Vitesse de départ';

  @override
  String get tuningCueLead => 'Avance du cercle';

  @override
  String get tuningDeltaHelp => 'Δ en haut à droite = écart du dernier lâcher par rapport au bord (− tôt, + tard).';

  @override
  String get avatarBeanie => 'Bonnet';

  @override
  String get avatarDreads => 'Dreads';

  @override
  String get avatarHelmet => 'Casque';

  @override
  String get avatarKid => 'Le Petit';
}
