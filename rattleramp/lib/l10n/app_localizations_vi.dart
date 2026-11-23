// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class L10nVi extends L10n {
  L10nVi([String locale = 'vi']) : super(locale);

  @override
  String get tapToRide => 'CHẠM ĐỂ TRƯỢT';

  @override
  String dailyTrick(String trick) {
    return 'TRICK CỦA NGÀY: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'PHONG CÁCH: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'TRUYỆN TRANH';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'ĐI!  $seconds';
  }

  @override
  String get wrongTrick => 'SAI TRICK';

  @override
  String get tooEarly => 'QUÁ SỚM';

  @override
  String get waitForCircle => 'chờ vòng tròn';

  @override
  String get noTrick => 'KHÔNG CÓ TRICK';

  @override
  String get losingSpeed => 'bạn đang mất tốc độ';

  @override
  String get bailTiming => 'sai thời điểm';

  @override
  String get bailUnknown => 'trick không xác định';

  @override
  String get bailTooLong => 'trick không kịp trên không';

  @override
  String get outOfSpeed => 'HẾT TỐC ĐỘ';

  @override
  String get rideOver => 'KẾT THÚC LƯỢT';

  @override
  String get bestTrick => 'TRICK HAY NHẤT';

  @override
  String get longestCombo => 'COMBO DÀI NHẤT';

  @override
  String get tricksLanded => 'SỐ TRICK';

  @override
  String get avgTiming => 'THỜI ĐIỂM TRUNG BÌNH';

  @override
  String get tapToContinue => 'CHẠM ĐỂ TIẾP TỤC';

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
      'Quanh viền = spin (theo chiều kim đồng hồ FS, ngược BS) · qua tâm = grab · hình thoi = flip. Nối các trick bằng một nét – trick tiếp theo bắt đầu nơi trick trước kết thúc. Nhấc ngón tay khi vòng tròn chạm mép.';

  @override
  String get spinNote => 'bắt đầu ở bất kỳ đâu trên viền';

  @override
  String pointsShort(int points) {
    return '$points điểm';
  }

  @override
  String get tuningTitle => 'TINH CHỈNH (M0)';

  @override
  String get tuningWindow => 'Độ rộng cửa sổ thời điểm';

  @override
  String get tuningLatency => 'Độ trễ cảm ứng';

  @override
  String get tuningStartSpeed => 'Tốc độ xuất phát';

  @override
  String get tuningCueLead => 'Thời gian báo trước của vòng tròn';

  @override
  String get tuningDeltaHelp => 'Δ ở góc trên bên phải = độ lệch của lần thả cuối so với mép (− sớm, + muộn).';

  @override
  String get avatarBeanie => 'Mũ len';

  @override
  String get avatarDreads => 'Tóc dread';

  @override
  String get avatarHelmet => 'Mũ bảo hiểm';

  @override
  String get avatarKid => 'Nhóc';
}
