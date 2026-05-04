import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/order_header.dart';
import 'package:flutter_golaundku/models/order_item.dart';
import 'package:flutter_golaundku/models/order_model.dart';
import 'package:flutter_golaundku/repository/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;
  StreamSubscription<List<OrderModel>>? _subscription;
  List<OrderModel> allCustomer = [];
  OrderBloc(this.orderRepository) : super(OrderInitial()) {
    // on<StartOrderStream>((event, emit) async {
    //   emit(OrderLoading());
    //   await _subscription?.cancel();
    //   _subscription = orderRepository.streamOrders().listen(
    //     (data) {
    //       add(GetOrder(data: data));
    //     },
    //     onError: (error) {
    //       add(ErrorOrderStream(message: error.toString()));
    //     },
    //   );
    // });

    on<GetOrder>((event, emit) {
      allCustomer = event.data;
      emit(OrderLoaded(orderData: allCustomer));
    });

    on<AddOrder>((event, emit) async {
      try {
        await orderRepository.addOrder(event.orderHeader, event.items);
        emit(OrderAddSuccess());
      } catch (e) {
        emit(OrderActionError(message: "Gagal menambahkan orders!"));
      }
    });
  }
}
