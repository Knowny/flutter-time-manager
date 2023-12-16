/// author(s): xhusar11en
import 'package:flutter/material.dart';

// https://api.flutter.dev/flutter/material/SegmentedButton-class.html

// *========================== SEGMENTED BUTTON ==========================*//

enum Selector { Tasks, Habits }

class SingleChoice extends StatefulWidget {
  final Selector selectorView;
  final Function(Selector) onSelectionChanged;

  const SingleChoice(
      {Key? key, required this.selectorView, required this.onSelectionChanged})
      : super(key: key);

  @override
  State<SingleChoice> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> {
  late Selector selectorView = Selector.Tasks;

  @override
  void initState() {
    selectorView =
        widget.selectorView; // Initialize selectorView with the provided value
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Selector>(
      style: ButtonStyle(
        side: MaterialStateProperty.all(const BorderSide(width: 0.1, color: Colors.transparent)),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.orange;
            }
            return Colors.grey.shade800;
          },
        ),
      ),
      segments: const <ButtonSegment<Selector>>[
        ButtonSegment<Selector>(
          value: Selector.Tasks,
          label: Text('Tasks'),
        ),
        ButtonSegment<Selector>(
          value: Selector.Habits,
          label: Text('Habits'),
        ),
      ],
      selected: <Selector>{selectorView},
      onSelectionChanged: (Set<Selector> newSelection) {
        setState(() {
          selectorView = newSelection.first;
        });
        widget.onSelectionChanged(newSelection.first);
      },
    );
  }
}
