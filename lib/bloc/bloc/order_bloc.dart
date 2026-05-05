import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/customer_model.dart';
import 'package:flutter_golaundku/models/discount_model.dart';
import 'package:flutter_golaundku/models/order_header.dart';
import 'package:flutter_golaundku/models/order_item.dart';
import 'package:flutter_golaundku/models/order_model.dart';
import 'package:flutter_golaundku/repository/customer_repository.dart';
import 'package:flutter_golaundku/repository/discount_repository.dart';
import 'package:flutter_golaundku/repository/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;
  final CustomerRepository customerRepository;
  final DiscountRepository discountRepository;
  StreamSubscription<List<OrderModel>>? _subscription;
  StreamSubscription<List<CustomerModel>>? _customerSub;
  StreamSubscription<List<DiscountModel>>? _discountSub;
  List<CustomerModel> _customers = [];
  List<DiscountModel> _discounts = [];
  List<OrderModel> allOrder = [];
  OrderBloc(
    this.orderRepository,
    this.customerRepository,
    this.discountRepository,
  ) : super(OrderInitial()) {
    on<StartOrderStream>((event, emit) async {
      emit(OrderLoading());
      await _subscription?.cancel();
      await _customerSub?.cancel();
      await _discountSub?.cancel();
      _subscription = orderRepository.streamOrders().listen(
        (data) {
          add(GetOrder(data: data));
        },
        onError: (error) {
          add(ErrorOrderStream(message: error.toString()));
        },
      );
      _customerSub = customerRepository.streamCustomers().listen((data) {
        _customers = data;
      });
      _discountSub = discountRepository.streamDiscounts().listen((data) {
        _discounts = data;
      });
    });

    on<GetOrder>((event, emit) {
      final customerMap = {for (var c in _customers) c.customerId: c};
      final discountMap = {for (var d in _discounts) d.discountId: d};
      final mappedOrders = event.data.map((order) {
        final customer = customerMap[order.customerId];
        final discount = discountMap[order.discountId];
        return order.copyWith(customerModel: customer, discountModel: discount);
      }).toList();
      allOrder = mappedOrders;
      emit(OrderLoaded(orderData: allOrder));
    });

    on<AddOrder>((event, emit) async {
      emit(OrderLoading());
      try {
        await orderRepository.addOrder(event.orderHeader, event.items);
        emit(OrderAddSuccess());
      } catch (e) {
        emit(OrderActionError(message: "Gagal menambahkan orders!"));
      }
    });

    on<UpdateStatusOrder>((event, emit) async {
      try {
        await orderRepository.updateStatusOrder(event.orderId, event.status);
        emit(OrderUpdateStatusSuccess());
      } catch (e) {
        emit(OrderActionError(message: "Gagal mengupdate status order!"));
      }
    });

    on<SearchOrder>((event, emit) {
      final keyword = event.keyword.toLowerCase().trim();
      if (keyword.isEmpty) {
        emit(OrderLoaded(orderData: allOrder));
        return;
      }
      final filtered = allOrder.where((data) {
        return data.orderId.toLowerCase().contains(keyword) ||
            data.customerModel!.name.toLowerCase().contains(keyword);
      }).toList();
      emit(OrderLoaded(orderData: filtered));
    });
  }
}
