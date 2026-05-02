import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/discount_model.dart';
import 'package:flutter_golaundku/repository/discount_repository.dart';

part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final DiscountRepository discountRepository;
  StreamSubscription<List<DiscountModel>>? _subscription;
  DiscountBloc(this.discountRepository) : super(DiscountInitial()) {
    on<StartDiscountStream>((event, emit) async {
      emit(DiscountLoading());
      await _subscription?.cancel();
      _subscription = discountRepository.streamDiscounts().listen(
        (data) {
          add(GetDiscount(data: data));
        },
        onError: (error) {
          add(ErrorDiscountStream(message: error.toString()));
        },
      );
    });

    on<GetDiscount>((event, emit) async {
      emit(DiscountLoaded(discountData: event.data));
    });

    on<AddDiscount>((event, emit) async {
      try {
        await discountRepository.addDiscount(event.data);
        emit(DiscountAddSuccess());
      } catch (e) {
        emit(DiscountActionError(message: "gagal menambahkan diskon!"));
      }
    });
    on<UpdateDiscount>((event, emit) async {
      try {
        await discountRepository.updateDiscount(event.data);
        emit(DiscountUpdateSuccess());
      } catch (e) {
        emit(DiscountActionError(message: "gagal mengupdate diskon!"));
      }
    });
    on<DeleteDiscount>((event, emit) async {
      try {
        await discountRepository.deleteDiscount(event.discountId);
        emit(DiscountDeleteSuccess());
      } catch (e) {
        emit(DiscountActionError(message: "gagal menghapus diskon!"));
      }
    });
  }
}
