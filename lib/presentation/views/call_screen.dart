import 'package:ai_voice_assistant/presentation/bloc/call_bloc.dart';
import 'package:ai_voice_assistant/presentation/bloc/call_event.dart';
import 'package:ai_voice_assistant/presentation/bloc/call_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Call')),
      body: BlocBuilder<CallBloc, CallState>(
        builder: (context, state) {
          if (state is CallConnecting) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is CallConnected) {
            return Center(child: Text('Call connected'));
          }
          if (state is CallError) {
            return Center(child: Text(state.message));
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<CallBloc>().add(StartCall());
              },
              child: Text('Start call'),
            ),
          );
        },
      ),
    );
  }
}
