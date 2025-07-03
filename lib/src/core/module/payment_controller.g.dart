// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PaymentController on PaymentControllerBase, Store {
  late final _$_errorMessageAtom =
      Atom(name: 'PaymentControllerBase._errorMessage', context: context);

  String? get errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  String? get _errorMessage => errorMessage;

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  late final _$createIntentPaymentAsyncAction = AsyncAction(
      'PaymentControllerBase.createIntentPayment',
      context: context);

  @override
  Future<void> createIntentPayment(String amount, TypesPayment type) {
    return _$createIntentPaymentAsyncAction
        .run(() => super.createIntentPayment(amount, type));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
