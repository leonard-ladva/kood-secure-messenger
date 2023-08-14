import 'package:formz/formz.dart';

/// Validation errors for the [Name] [FormzInput].
enum NameValidationError {
  /// Generic invalid error.
  invalid,
  cantBeEmpty,
  tooShort,
  tooLong,
  invalidCharacters,
}

/// {@template name}
/// Form input for an name input.
/// {@endtemplate}
class Name extends FormzInput<String, NameValidationError> {
  /// {@macro name}
  const Name.pure() : super.pure('');

  /// {@macro name}
  const Name.dirty([super.value = '']) : super.dirty();

  static const int maxLength = 20;
  static const int minLenght = 3;
  static final RegExp _nameRegExp = RegExp(r'^[a-zA-Z0-9 ]+$');

  @override
  NameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return NameValidationError.cantBeEmpty;
    if (value.length < minLenght) return NameValidationError.tooShort;
    if (value.length > maxLength) return NameValidationError.tooLong;

    return _nameRegExp.hasMatch(value)
        ? null
        : NameValidationError.invalidCharacters;
  }
}
