import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
// Create a expandable/ collapsable text widget
class TextWrapper extends StatefulWidget {
  const TextWrapper({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  State<TextWrapper> createState() => _TextWrapperState();
}

class _TextWrapperState extends State<TextWrapper>
    with TickerProviderStateMixin {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: ConstrainedBox(
              constraints: isExpanded
                  ? const BoxConstraints()
                  : const BoxConstraints(maxHeight: 70),
              child: Text(
                widget.text,
                // style: const TextStyle(fontSize: 12),
                softWrap: true,
                overflow: TextOverflow.fade,
              ))),
      isExpanded
          ? OutlinedButton.icon(
              icon: const Icon(Icons.arrow_upward),
              label: Text('Read less',
              style:  TextStyle(
                fontSize: 10.sp , 
              ),),
              onPressed: () => setState(() => isExpanded = false))
          : TextButton.icon(
              icon: const Icon(Icons.arrow_downward),
              label: Text('Read more',
              style:  TextStyle(
                fontSize: 10.sp , 
              ),),
              onPressed: () => setState(() => isExpanded = true))
    ]);
  }
}