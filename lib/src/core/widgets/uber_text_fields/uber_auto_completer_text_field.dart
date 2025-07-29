import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:uber_clone_core/src/core/widgets/uber_text_fields/uber_text_field_widget.dart';
import 'package:uber_clone_core/src/model/addres.dart';


typedef OnSelectedAddres = void Function(Address)?;
typedef GetAddresCallSuggestion = Function(String);

class UberAutoCompleterTextField extends StatefulWidget {
  final OnSelectedAddres onSelcetedAddes;
  final GetAddresCallSuggestion getAddresCallSuggestion;
  final String labalText;
  final String? hintText;
  final Icon? prefIcon;
  final FormFieldValidator<String>? validator;
  final VoidCallback? hasFocus;
  final List<Address> lastAddress;

  const UberAutoCompleterTextField(
      {super.key,
      required this.onSelcetedAddes,
      required this.getAddresCallSuggestion,
      required this.labalText,
      required this.prefIcon,
      this.validator,
      this.hintText,
      this.hasFocus,
      required this.lastAddress});

  @override
  State<UberAutoCompleterTextField> createState() =>
      _UberAutoCompleterTextFieldState();
}

class _UberAutoCompleterTextFieldState
    extends State<UberAutoCompleterTextField> {
  var addresNameSelceted = '';

 

  @override
  void initState() {
    if (widget.hintText != null) {
      addresNameSelceted = widget.hintText ?? '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<Address>(
      debounceDuration: const Duration(seconds: 2),
      itemBuilder: itemAddressSearch,
      onSelected: onSelected,
      emptyBuilder: (context) {
        return widget.lastAddress.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Nenhum Endereço encontrado",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
              shrinkWrap: true,
              itemCount: widget.lastAddress.length,
              itemBuilder: (context, index) {
                final addres = widget.lastAddress[index];
                return ListTile(
                  onTap: () {
                    onSelected(addres);
                  },
                  leading: const Icon(Icons.location_on),
                  title: Text(addres.nomeDestino),
                );
              },
            );
      },
      suggestionsCallback: suggestionsCallBack,
      builder: (context, controller, focusNode) {
        controller.text = addresNameSelceted;

        return UberTextFieldWidget(
          controller: controller,
          focosNode: focusNode,
          onChange: (value) {
                 addresNameSelceted = value;
          },
          suffiWidget: controller.text.isNotEmpty
              ? IconButton(onPressed: () {
                 controller.text = '';
              }, icon: const Icon(Icons.clear))
              : null,
          prefixIcon: widget.prefIcon,
          label: widget.labalText,
          validator: widget.validator,
          inputType: TextInputType.streetAddress,
        );
      },
    );
  }

  FutureOr<List<Address>?> suggestionsCallBack(String search) async {
    
    if(search.isNotEmpty){
          var sugestions = <Address>[];
          sugestions = await widget.getAddresCallSuggestion(search);
           return sugestions;
    }

    return <Address>[];
  }
  
  void onSelected(Address? addres) {  

    if (addres != null ) {
       addresNameSelceted = addres.nomeDestino;
       widget.onSelcetedAddes!(addres);
    }
  }

  Widget itemAddressSearch(context, Address addres) {
    return ListTile(
      leading: const Icon(Icons.location_on),
      title: Text(addres.nomeDestino),
    );
  }
}
