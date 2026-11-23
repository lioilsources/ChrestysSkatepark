// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class L10nBn extends L10n {
  L10nBn([String locale = 'bn']) : super(locale);

  @override
  String get tapToRide => 'ট্যাপ করুন, চালান';

  @override
  String dailyTrick(String trick) {
    return 'আজকের ট্রিক: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'স্টাইল: $style';
  }

  @override
  String get styleNeon => 'নিয়ন';

  @override
  String get styleComic => 'কমিক';

  @override
  String get stylePixel => 'পিক্সেল';

  @override
  String goCountdown(int seconds) {
    return 'চলো!  $seconds';
  }

  @override
  String get wrongTrick => 'ভুল ট্রিক';

  @override
  String get tooEarly => 'খুব তাড়াতাড়ি';

  @override
  String get waitForCircle => 'বৃত্তের জন্য অপেক্ষা করুন';

  @override
  String get noTrick => 'কোনো ট্রিক নেই';

  @override
  String get losingSpeed => 'গতি কমে যাচ্ছে';

  @override
  String get bailTiming => 'ভুল টাইমিং';

  @override
  String get bailUnknown => 'অজানা ট্রিক';

  @override
  String get bailTooLong => 'ট্রিক বাতাসে শেষ হয়নি';

  @override
  String get outOfSpeed => 'গতি শেষ';

  @override
  String get rideOver => 'রাইড শেষ';

  @override
  String get bestTrick => 'সেরা ট্রিক';

  @override
  String get longestCombo => 'দীর্ঘতম কম্বো';

  @override
  String get tricksLanded => 'ট্রিক';

  @override
  String get avgTiming => 'গড় টাইমিং';

  @override
  String get tapToContinue => 'চালিয়ে যেতে ট্যাপ করুন';

  @override
  String get tabGrabs => 'গ্র্যাব';

  @override
  String get tabFlips => 'ফ্লিপ';

  @override
  String get tabSpins => 'স্পিন';

  @override
  String get tabCombos => 'কম্বো';

  @override
  String get trickBookHelp =>
      'কিনারা ধরে = স্পিন (ঘড়ির কাঁটার দিকে FS, উল্টো দিকে BS) · মাঝখান দিয়ে = গ্র্যাব · রম্বস = ফ্লিপ। এক টানে ট্রিক জুড়ুন – পরেরটি শুরু হয় যেখানে আগেরটি শেষ হয়েছে। বৃত্ত কিনারায় পৌঁছালে আঙুল তুলুন।';

  @override
  String get spinNote => 'কিনারার যেকোনো জায়গা থেকে শুরু করুন';

  @override
  String pointsShort(int points) {
    return '$points পয়েন্ট';
  }

  @override
  String get tuningTitle => 'টিউনিং (M0)';

  @override
  String get tuningWindow => 'টাইমিং উইন্ডোর প্রস্থ';

  @override
  String get tuningLatency => 'স্পর্শ বিলম্ব';

  @override
  String get tuningStartSpeed => 'শুরুর গতি';

  @override
  String get tuningCueLead => 'বৃত্তের অগ্রিম সময়';

  @override
  String get tuningDeltaHelp => 'Δ উপরের ডান কোণে = শেষবার আঙুল ছাড়ার কিনারা থেকে বিচ্যুতি (− আগে, + দেরিতে)।';

  @override
  String get avatarBeanie => 'উলের টুপি';

  @override
  String get avatarDreads => 'ড্রেডস';

  @override
  String get avatarHelmet => 'হেলমেট';

  @override
  String get avatarKid => 'ছোটু';
}
