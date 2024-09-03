String capitalizeFirstLetter(String text) {
  if (text == null) return '';
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
