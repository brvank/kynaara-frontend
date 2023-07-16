import 'package:bloc/bloc.dart';

sealed class LoaderEvent{}

final class LoaderLoading extends LoaderEvent{}

final class LoaderStopped extends LoaderEvent{}

class LoaderBloc extends Bloc<LoaderEvent, bool>{
  LoaderBloc() : super(false){
    on<LoaderLoading>((event, emit) {
      emit(true);
    });

    on<LoaderStopped>((event, emit) {
      emit(false);
    });
  }
}