/// author(s): xjesko01
import 'package:flutter/material.dart';

enum Selector { Today, Week, Month, ALL }

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
  late Selector selectorView = Selector.Today;

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
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.orange;
            }
            return Colors.grey.shade800;
          },
        ),
        minimumSize: MaterialStateProperty.all(Size(80,40)),
      ),
      segments: const <ButtonSegment<Selector>>[
        ButtonSegment<Selector>(
          value: Selector.Today,
          label: Text('Today'),
        ),
        ButtonSegment<Selector>(
          value: Selector.Week,
          label: Text('Week '),
        ),
        ButtonSegment<Selector>(
          value: Selector.Month,
          label: Text('Month'),
        ),
        ButtonSegment<Selector>(
          value: Selector.ALL,
          label: Text('All'),
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