part of 'discount_bloc.dart';

class DiscountEvent {}

class GetDiscount extends DiscountEvent {}

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
