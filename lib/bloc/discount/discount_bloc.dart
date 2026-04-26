import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/discount_model.dart';
import 'package:flutter_golaundku/repository/discount_repository.dart';

part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final DiscountRepository discountRepository;
  DiscountBloc(this.discountRepository) : super(DiscountInitial()) {
    on<GetDiscount>((event, emit) async {
      emit(DiscountLoading());
      try {
        final discountData = await discountRepository.getDiscount();
        emit(DiscountLoaded(discountData: discountData));
      } catch (e) {
        emit(DiscountError());
      }
    });
    on<AddDiscount>((event, emit) async {
      emit(DiscountLoading());
      try {
        await discountRepository.addDiscount(event.data);
        emit(DiscountAddSuccess());
        add(GetDiscount());
      } catch (e) {
        emit(DiscountError());
      }
    });
    on<UpdateDiscount>((event, emit) async {
      emit(DiscountLoading());
      try {
        await discountRepository.updateDiscount(event.data);
        emit(DiscountUpdateSuccess());
        add(GetDiscount());
      } catch (e) {
        emit(DiscountError());
      }
    });
    on<DeleteDiscount>((event, emit) async {
      emit(DiscountLoading());
      try {
        await discountRepository.deleteDiscount(event.discountId);
        emit(DiscountDeleteSuccess());
        add(GetDiscount());
      } catch (e) {
        emit(DiscountError());
      }
    });
  }
}
