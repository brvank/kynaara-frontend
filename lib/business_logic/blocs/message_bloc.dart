import 'package:bloc/bloc.dart';

sealed class MessageEvent{
  String message;

  MessageEvent(this.message);
}

final class MessageReceived extends MessageEvent{
  MessageReceived(String message) : super (message);
}

final class MessageClear extends MessageEvent{
  MessageClear() : super ("");
}

class MessageBloc extends Bloc<MessageEvent, String>{
  MessageBloc(String message) : super(message){
    on<MessageReceived>((event, emit) {
      emit(event.message);
    });

    on<MessageClear>((event, emit) {
      emit(event.message);
    });
  }
}