import 'dart:convert';
import 'dart:math';

import 'package:ii_code_gen/util/logging.dart';
import 'package:open_llm_studio_api/service/ai_service.dart';
import 'package:open_llm_studio_api/util/text_segmentation.dart';

enum SegmentBy { Sentences, WordCount, Paragraphs, Other }

const tag = 'tex_segmentation.dart';

Future<List<String>> segmentText({
  required bool useAi,
  required String segmentBy,
  required String text,
  required int? wordCount,
}) async {
  const method = 'segmentText';
  try {
    devLog(tag: tag, message: '$method starting');
    List<String> segmentedData = [];
    if (useAi) {
      segmentedData = await _segmentWithAi(segmentBy, text);
    } else {
      segmentedData = _segmentWithRejex(segmentBy, text, wordCount);
    }
    devLog(
        tag: 'segmentText',
        message: 'segmentedData length ${segmentedData.length}');
    return segmentedData;
  } catch (e) {
    errorLog(tag: tag, message: '$method exception: $e');
  }
  return [];
}

Future<List<String>> _segmentWithAi(String segmentBy, text) async {
  devLog(tag: tag, message: '_segmentWithAi started');
  List<String> segmentedData = [];
  String prompt = '';

  if (segmentBy == SegmentByAi.Paragraphs.name) {
    prompt =
        """Using the principles of soft-prompt tuning in transformer architectures, segment the following text into logical paragraphs based on thematic breaks and content continuity. Ensure the output is in Dart list format, encapsulated within "[]". Each string inside this list should represent a distinct paragraph. The essence of the original text should remain intact; only its segmentation into paragraphs should change: $text""";
  }
  if (segmentBy == SegmentByAi.Sentences.name) {
    prompt =
        """Using the principles of soft-prompt tuning in transformer architectures, segment the following text into individual sentences based on grammatical breaks and content continuity. Ensure the output is in valid JSON format, with each string representing a distinct sentence. The essence of the original text should remain intact; only its segmentation into sentences should change:
$text""";
  } else {
    prompt =
        """Using the principles of soft-prompt tuning in transformer architectures, segment the following text based on the user-specified criterion: $segmentBy. The output should be a valid JSON list, where each string inside the list represents a distinct segment based on the given criterion. The essence of the original text should remain intact; only its segmentation should change based on the provided criterion. Please format your response as: ["segment1", "segment2", ...]:
$text""";
  }

  devLog(tag: tag, message: 'prompt $prompt');
  final response = await aiService.sendPromptGPT3turbo16k(prompt);
  devLog(tag: tag, message: "response $response");
  if (response != null) {
    try {
      segmentedData = stringToList(response);
      return segmentedData;
    } catch (e) {
      devLog(tag: tag, message: 'exception in _segmentWithAi $e');
      segmentedData = stringToList(response);
    }
  }
  return segmentedData;
}

List<String> _segmentWithRejex(String segmentBy, text, wordsPerChonk) {
  List<String> segmentedData = [];

  if (segmentBy == SegmentBy.Sentences.name) {
    segmentedData = _splitIntoSentences(text);
  } else if (segmentBy == SegmentBy.WordCount.name) {
    segmentedData = _splitIntoWords(text, wordsPerChonk ?? 42);
  } else if (segmentBy == SegmentBy.Paragraphs.name) {
    segmentedData = _splitIntoParagraphs(text);
  }
  return segmentedData;
}

List<String> _splitIntoWords(String text, int wordsPerChonk) {
  List<String> listOfwords = text.split(' ');
  List<String> result = [];

  for (int i = 0; i < listOfwords.length; i += wordsPerChonk) {
    result.add(listOfwords
        .sublist(i, min(i + wordsPerChonk, listOfwords.length))
        .join(' '));
  }

  for (final i in result) {
    devLog(tag: tag, message: i);
  }

  return result;
}

final RegExp prefixes = RegExp(
    r'(Mr|St|Mrs|Ms|Dr|Prof|Capt|Cpt|Lt|Col|Gen|Adm|Atty|Hon|Rev|Rep|Sen)[.]');
final RegExp websites = RegExp(r'[.](com|net|org|io|gov|edu|me)');
final RegExp digits = RegExp(r'([0-9])');
final RegExp multipleDots = RegExp(r'\.{2,}');
const String alphabets = r'([A-Za-z])';
final RegExp acronyms = RegExp(r'([A-Z][.][A-Z][.](?:[A-Z][.])?)');
final RegExp starters = RegExp(
    r'(Mr|Mrs|Ms|Dr|Prof|Capt|Cpt|Lt|He\s|She\s|It\s|They\s|Their\s|Our\s|We\s|But\s|However\s|That\s|This\s|Wherever)');
final RegExp suffixes = RegExp(r'(Inc|Ltd|Jr|Sr|Co)');

List<String> _splitIntoSentences(String text) {
  text = ' ' + text + '  ';
  text = text.replaceAll('\n', ' ');
  text = text.replaceAll(prefixes, r'$1<prd>');
  text = text.replaceAll(websites, r'<prd>$1');
  text = text.replaceAllMapped(RegExp(r'([0-9])[.]([0-9])'),
      (match) => '${match.group(1)}<prd>${match.group(2)}');
  text = text.replaceAllMapped(multipleDots,
      (match) => '<prd>' * (match.group(0) ?? '').length + '<stop>');

  if (text.contains('Ph.D')) text = text.replaceAll('Ph.D.', 'Ph<prd>D<prd>');
  text = text.replaceAll(RegExp(r'\s' + alphabets + r'[.] '), r' $1<prd> ');
  text = text.replaceAllMapped(acronyms, (match) => '${match.group(1)}<stop>');
  text = text.replaceAll(
      RegExp(alphabets + r'[.]' + alphabets + r'[.]' + alphabets + r'[.]'),
      r'$1<prd>$2<prd>$3<prd>');
  text = text.replaceAll(
      RegExp(alphabets + r'[.]' + alphabets + r'[.]'), r'$1<prd>$2<prd>');
  text = text.replaceAllMapped(
      RegExp(r' ' + suffixes.pattern + r'[.] ' + starters.pattern),
      (match) => ' ${match.group(1)}<stop> ${match.group(2)}');
  text = text.replaceAllMapped(RegExp(r' ' + suffixes.pattern + r'[.]'),
      (match) => ' ${match.group(1)}<prd>');

  text = text.replaceAll(RegExp(r' ' + alphabets + r'[.]'), r' $1<prd>');

  if (text.contains('”')) text = text.replaceAll('.”', '”.');
  if (text.contains('"')) text = text.replaceAll('."', '".');

  text = text.replaceAll('.', '.<stop>');
  text = text.replaceAll('?', '?<stop>');
  text = text.replaceAll('!', '!<stop>');
  text = text.replaceAll('<prd>', '.');
  text = text.replaceAll(prefixes, r'$1<prd>');

  final RegExp decimalNumbers = RegExp(r'([0-9][.][0-9])');
  text = text.replaceAll(decimalNumbers, r'$1<prd>');

  List<String> sentences = text.split('<stop>');
  sentences = sentences.map((s) => s.trim()).toList();
  if (sentences.isNotEmpty && sentences.last.isEmpty) sentences.removeLast();
  return sentences;
}

List<String> stringToList(String str) {
  try {
    List<dynamic> decodedList = jsonDecode(str);
    return decodedList.map((item) => item.toString()).toList();
  } catch (e) {
    devLog(tag: tag, message: "Error: $e");
    return [];
  }
}

List<String> _splitIntoParagraphs(String text) {
  // Count the occurrences of double newlines.
  int doubleNewlineCount = '\n\n'.allMatches(text).length;

  // Choose the paragraph separator based on the count of double newlines.
  String paragraphSeparator = doubleNewlineCount < 5 ? '\n' : '\n\n';

  // Split the text by the chosen paragraph separator to get paragraphs.
  List<String> paragraphs = text.split(paragraphSeparator);

  List<String> chunks = [];
  String buffer = '';

  if (paragraphs.length == 1) {
    var sentences = _splitIntoSentences(text);

    for (var sentence in sentences) {
      buffer = buffer.isNotEmpty ? '$buffer. $sentence' : sentence;

      // If the buffer has 5 sentences, add to chunks and clear buffer.
      if (_splitIntoSentences(buffer).length >= 5) {
        chunks.add(buffer);
        buffer = '';
      }
    }
    // If there's anything left in the buffer, add it to the chunks.
    if (buffer.isNotEmpty) {
      chunks.add(buffer);
    }
  } else {
    for (var paragraph in paragraphs) {
      // Log: Check Sentence Splitting
      var sentences = _splitIntoSentences(paragraph);

      // If buffer is not empty, add current paragraph to the buffer.
      buffer = buffer.isNotEmpty
          ? '$buffer$paragraphSeparator$paragraph'
          : paragraph;

      sentences = _splitIntoSentences(buffer);

      if (sentences.length >= 3) {
        chunks.add(buffer);
        buffer = '';
      }
    }

    if (buffer.isNotEmpty) {
      chunks.add(buffer);
    }
  }

  return chunks;
}
