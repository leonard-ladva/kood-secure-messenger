String initials(String name) {
  if (name.isEmpty) {
    return '';
  }
  name = name.trim();
  var names = name.split(' '),
      initials = names.first.substring(0, 1).toUpperCase();

  if (names.length > 1) {
    initials += names.last.substring(0, 1).toUpperCase();
  }

  return initials;
}
