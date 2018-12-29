
import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'package:isolate/isolate.dart';

// import 'package:flutter/foundation.dart' show profile;
import 'package:meta/meta.dart';


typedef ComputeCallbackRunner<Q,R> = FutureOr<R> Function(Q message);

Future<R> computeRunner<Q,R>(ComputeCallbackRunner<Q,R> computeCallback,Q message) async {
  final runner = await IsolateRunner.spawn();
  return runner
    .run(computeCallback, message)
    .whenComplete(() => runner.close());
}

typedef ComputeCallback<Q,R> = R Function(Q message);


Future<R> compute<Q, R>(ComputeCallback<Q, R> callback, Q message, { String debugLabel }) async {
  // profile(() { debugLabel ??= callback.toString(); });
  final Flow flow = Flow.begin();
  Timeline.startSync('$debugLabel: start', flow: flow);
  final ReceivePort resultPort = ReceivePort();
  Timeline.finishSync();
  final Isolate isolate = await Isolate.spawn<_IsolateConfiguration<Q, R>>(
    _spawn,
    _IsolateConfiguration<Q, R>(
      callback,
      message,
      resultPort.sendPort,
      debugLabel,
      flow.id,
    ),
    errorsAreFatal: true,
    onExit: resultPort.sendPort,
  );
  final R result = await resultPort.first;
  Timeline.startSync('$debugLabel: end', flow: Flow.end(flow.id));
  resultPort.close();
  isolate.kill();
  Timeline.finishSync();
  return result;
}

@immutable
class _IsolateConfiguration<Q, R> {
  const _IsolateConfiguration(
    this.callback,
    this.message,
    this.resultPort,
    this.debugLabel,
    this.flowId,
  );
  final ComputeCallback<Q, R> callback;
  final Q message;
  final SendPort resultPort;
  final String debugLabel;
  final int flowId;

  FutureOr<R> apply() {
    print('hello apply');
    var r = callback(message);
    print("apply result = $r");
    return r;
  }
}

void _spawn<Q, R>(_IsolateConfiguration<Q, R> configuration) {
  R result;
  Timeline.timeSync(
    '${configuration.debugLabel}',
    () async {
      FutureOr<R> tmp = configuration.apply();
      print('tmp = $tmp');
      if(tmp is Future<R>){
        print('tmp=Future<$R>');
        result = await tmp;
      }else{
        result = tmp;
      }
    },
    flow: Flow.step(configuration.flowId),
  );
  Timeline.timeSync(
    '${configuration.debugLabel}: returning result',
    () { configuration.resultPort.send(result); },
    flow: Flow.step(configuration.flowId),
  );
}