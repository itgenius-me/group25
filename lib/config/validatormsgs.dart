import 'package:form_field_validator/form_field_validator.dart';
import 'package:streambox/config/enumvals.dart';

// Contains all form field validation messages to be used in inputfield
List<FieldValidator<dynamic>> errorMessages(
  FieldType formField,
  String text,
) {
  List<FieldValidator<dynamic>> messages = [
    RequiredValidator(errorText: "$text is a required field")
  ];
  if (formField == FieldType.password) {
    messages.add(
      MinLengthValidator(6, errorText: "$text must be 6 digits long"),
    );
  } else if (formField == FieldType.email) {
    messages.add(
      EmailValidator(
        errorText: "invalid $text",
      ),
    );
  } else if (formField == FieldType.phone) {
    messages.add(
      MinLengthValidator(10, errorText: "$text must be 10 digits long"),
    );
  }
  return messages;
}
