part of 'discount_bloc.dart';

class DiscountState {}

final class DiscountInitial extends DiscountState {}

final class DiscountLoading extends DiscountState {}

final class DiscountLoaded extends DiscountState {
  final List<DiscountModel> discountData;
  DiscountLoaded({required this.discountData});
}

final class DiscountAddSuccess extends DiscountState {}

final class DiscountUpdateSuccess extends DiscountState {}

final class DiscountDeleteSuccess extends DiscountState {}

final class DiscountError extends DiscountState {}
