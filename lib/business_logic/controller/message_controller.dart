import 'dart:async';

import '../blocs/message_bloc.dart';

@Deprecated("Class not in use")
class MessageController{
  Timer? _timer;

  MessageBloc messageBloc = MessageBloc("");

  Function? timerEndCallback;

  MessageController(this.timerEndCallback);

  void showMessage(String message){
    if(_timer != null){
      if(_timer!.isActive){
        _timer!.cancel();
      }
    }

    messageBloc.add(MessageReceived(message));

    _timer = Timer(const Duration(seconds: 2), () {
      clearMessage();
    });
  }

  void clearMessage(){
    if(_timer != null){
      if(!_timer!.isActive){
        messageBloc.add(MessageClear());
        timerEndCallback!();
      }
    }
  }
}