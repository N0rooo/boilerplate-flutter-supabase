int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;
  // speed of reading 225 words per minute
  final readingTime = (wordCount / 225);

  print(readingTime);
  return readingTime.ceil();
}
