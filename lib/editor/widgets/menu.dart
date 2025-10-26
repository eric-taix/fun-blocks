import 'package:flutter/material.dart';
import 'package:fp_blocky/theme_extensions.dart';

class Menu extends StatefulWidget {
  const Menu({required this.name, required this.children, super.key});

  final String name;
  final List<Widget> children;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.name, style: Theme.of(context).extension<FunBlockMenuStyleExtension>()?.textStyle),
            Spacer(),
            IconButton(
              icon: Icon(
                _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                size: 14,
                color: Theme.of(context).extension<FunBlockMenuStyleExtension>()?.textStyle.color,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ],
        ),
        if (_isExpanded)
          ...widget.children.map((e) => Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 18),
                child: e,
              )),
      ],
    );
  }
}
