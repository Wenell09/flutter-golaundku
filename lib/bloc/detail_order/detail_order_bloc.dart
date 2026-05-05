import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/order_items_model.dart';
import 'package:flutter_golaundku/repository/order_repository.dart';

part 'detail_order_event.dart';
part 'detail_order_state.dart';

class DetailOrderBloc extends Bloc<DetailOrderEvent, DetailOrderState> {
  final OrderRepository orderRepository;
  DetailOrderBloc(this.orderRepository) : super(DetailOrderInitial()) {
    on<GetDetailOrder>((event, emit) async {
      emit(DetailOrderLoading());
      try {
        final detailOrderData = await orderRepository.getDetailOrder(
          event.orderId,
        );
        emit(DetailOrderLoaded(detailOrderData: detailOrderData));
      } catch (e) {
        emit(DetailOrderError());
      }
    });

    on<UpdateDeliveryStatus>((event, emit) async {
      try {
        await orderRepository.updateStatusDeliveryOrder(
          event.orderItemId,
          event.deliveryStatus,
        );
        emit(DetailOrderUpdateDeliverySuccess());
        add(GetDetailOrder(orderId: event.orderId));
      } catch (e) {
        emit(DetailOrderError());
      }
    });
  }
}
