import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/business_logic/controller/basic_view_controller.dart';
import 'package:kynaara_frontend/utils/constants/utility_functions.dart';

class BasicTableView extends StatefulWidget {
  const BasicTableView({Key? key}) : super(key: key);

  @override
  State<BasicTableView> createState() => _BasicTableViewState();
}

class _BasicTableViewState extends State<BasicTableView> {
  late BasicViewController _channelsTableController;

  int start = 0, size = 10, end = 0, total = 0;

  TextEditingController channelNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _channelsTableController = BasicViewController(() {
      logoutUser(context);
    });
    _channelsTableController.getChannels(
        start, size, channelNameController.text, (start, end, total) {
      this.start = start;
      this.end = end;
      this.total = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoaderBloc>(
            create: (context) {
              return _channelsTableController.loaderBloc;
            },
          ),
          BlocProvider<MessageBloc>(
            create: (context) {
              return _channelsTableController.messageBloc;
            },
          )
        ],
        child: BlocConsumer<MessageBloc, String>(
          listener: (context, state) {
            if (state.isNotEmpty) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state),
                  duration: const Duration(seconds: 2),
                ));
              }
            }
          },
          builder: (context, state) {
            return BlocBuilder<LoaderBloc, bool>(builder: (context, state) {
              return Container();
            });
          },
        ));
  }
}
