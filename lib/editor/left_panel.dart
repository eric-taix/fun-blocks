import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fp_blocky/editor/bloc/editor_cubit.dart';
import 'package:fp_blocky/editor/widgets/menu.dart';
import 'package:fp_blocky/models/drag_data.dart';
import 'package:fp_blocky/models/either/either_flatmap.dart';
import 'package:fp_blocky/models/either/either_map.dart';
import 'package:fp_blocky/models/either/either_to_option.dart';
import 'package:fp_blocky/models/node.dart';
import 'package:fp_blocky/models/option/option_flatmap.dart';
import 'package:fp_blocky/models/option/option_map.dart';
import 'package:fp_blocky/models/option/option_of.dart';
import 'package:fp_blocky/models/option/option_to_either.dart';
import 'package:fp_blocky/widgets/buttons/mini_button.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({super.key});

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    final tween = Tween<double>(begin: 300, end: 34);
    _animation = tween.animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: _animation.value,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Spacer(),
                    MiniButton(
                      child: Image(image: AssetImage('icons/left_panel_close.png')),
                      onTap: () {
                        if (_controller.isCompleted) {
                          _controller.reverse();
                        } else {
                          _controller.forward();
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (_animation.value > 100) ...[
                SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<EditorCubit, EditorState>(
                    builder: (context, state) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 18.0, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 0,
                          children: [
                            Menu(
                              name: 'Option',
                              children: [
                                _buildDraggableBlock(node: Node(OptionOf.prototype())),
                                _buildDraggableBlock(node: Node(OptionMap.prototype())),
                                _buildDraggableBlock(node: Node(OptionFlatMap.prototype())),
                                _buildDraggableBlock(node: Node(OptionToEither.prototype())),
                              ],
                            ),
                            Menu(
                              name: 'Either',
                              children: [
                                _buildDraggableBlock(node: Node(EitherFlatMap.prototype())),
                                _buildDraggableBlock(node: Node(EitherMap.prototype())),
                                _buildDraggableBlock(node: Node(EitherToOption.prototype())),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggableBlock({required Node node}) {
    return Draggable<DragData>(
      data: CreateBlockDragData(node),
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.7,
          child: node.widget,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: node.widget,
      ),
      child: node.widget,
    );
  }
}
