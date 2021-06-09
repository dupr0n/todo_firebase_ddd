import 'package:flutter/material.dart';

import '../../../../domain/notes/note_failure.dart';

class CriticalFailureWidget extends StatelessWidget {
  final NoteFailure failure;

  const CriticalFailureWidget({
    Key key,
    @required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            '😱',
            style: TextStyle(fontSize: 100),
          ),
          Text(
            failure.maybeMap(
              insufficientPermission: (_) => 'Insufficient Permissions',
              orElse: () => 'Unexpected Error.\nPlease contact support.',
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
          ),
          FlatButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.mail),
                SizedBox(width: 4),
                Text('Get help'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
