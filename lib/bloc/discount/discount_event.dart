part of 'discount_bloc.dart';

class DiscountEvent {}

class StartDiscountStream extends DiscountEvent {}

class ErrorDiscountStream extends DiscountEvent {
  final String message;
  ErrorDiscountStream({required this.message});
}

class GetDiscount extends DiscountEvent {
  final List<DiscountModel> data;
  GetDiscount({required this.data});
}

class AddDiscount extends DiscountEvent {
  final Map<String, dynamic> data;
  AddDiscount({required this.data});
}

class UpdateDiscount extends DiscountEvent {
  final Map<String, dynamic> data;
  UpdateDiscount({required this.data});
}

class DeleteDiscount extends DiscountEvent {
  final String discountId;
  DeleteDiscount({required this.discountId});
}
