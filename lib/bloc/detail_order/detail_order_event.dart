part of 'detail_order_bloc.dart';

class DetailOrderEvent {}

class GetDetailOrder extends DetailOrderEvent {
  final String orderId;
  GetDetailOrder({required this.orderId});
}

class UpdateDeliveryStatus extends DetailOrderEvent {
  final String orderId;
  final String orderItemId;
  final bool deliveryStatus;

  UpdateDeliveryStatus({
    required this.orderId,
    required this.orderItemId,
    required this.deliveryStatus,
  });
}
