import 'package:flutter/material.dart';

typedef OnChanged = Function(String)?;

class UberTextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final Widget? suffiWidget ;
  final String? hintText;
  final String? label; 
  final FocusNode?  focosNode;
  final TextInputType? inputType;
  final bool autoFocos;
  final Widget? prefixIcon;
  final ValueNotifier<bool> _obscureTextVN;
  final OnChanged onChange;

  UberTextFieldWidget({
    super.key,
    required this.controller,
    this.obscureText = false,
    this.hintText,
    this.label,
    this.validator,
    this.prefixIcon,
    this.inputType,
    this.focosNode,
    this.autoFocos =false,
    this.onChange,
    this.suffiWidget
  }) : _obscureTextVN = ValueNotifier(obscureText);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _obscureTextVN,
        builder: (_, vNObscureText, __) {
          return TextFormField(
            controller: controller,
            onChanged: onChange,
            keyboardType: inputType,
            focusNode: focosNode,
            autofocus: autoFocos,
            validator:validator ,
            obscureText: vNObscureText,
            decoration: InputDecoration(
              errorStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
              label:label != null ? Text(label!,style:const TextStyle(fontSize: 20),) : null,
              
              suffixIcon: obscureText
                        ? IconButton(
                            onPressed: () {
                              _obscureTextVN.value = !vNObscureText;
                            },
                            icon: Icon(_obscureTextVN.value
                                ? Icons.visibility
                                : Icons.visibility_off),
                          )
                        : suffiWidget,
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              prefixIcon: prefixIcon,
               
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            style: const TextStyle(fontSize: 18),
          );
        });
  }
}
