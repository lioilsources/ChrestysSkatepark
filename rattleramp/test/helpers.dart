import 'dart:io';

import 'package:rattleramp/core/trick_defs.dart';
import 'package:rattleramp/core/trick_parser.dart';

final TrickBook book = TrickBook.fromJson(File('assets/tricks.json').readAsStringSync());
final TrickParser parser = TrickParser(book);
