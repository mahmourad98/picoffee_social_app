import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final Widget? prefix;
  final String? initialValue;
  final bool? enabled;
  final bool obscureText;


  EntryField({this.controller, this.hint, this.prefix, this.initialValue,this.enabled,this.obscureText=false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
 obscureText: obscureText,
      obscuringCharacter:'*',
      enabled: enabled,
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(

        hintText: hint,

        suffixIcon:prefix ,
        hintStyle: theme.textTheme.bodyText2!
            .copyWith(color: theme.hintColor, fontSize: 15),
      ),
    );
  }
}
