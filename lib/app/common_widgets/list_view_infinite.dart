import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fulltimeforce_test/app/_childrens/commits/bloc/bloc.dart'
    as bloc;

class ListViewInfinite extends StatelessWidget {
  ListViewInfinite({
    Key? key,
    this.shrinkWrap = false,
    this.isLastPage = false,
    this.primary,
    required this.children,
    this.controller,
    this.onLoadingMore,
    this.scrollDirection = Axis.vertical,
    this.loadingWidget,
    this.padding,
    this.separation = const SizedBox.shrink(),
  }) : super(key: key);

  final _internalController = ScrollController();
  final bool shrinkWrap;
  final bool? primary;
  final List<Widget> children;
  final ScrollController? controller;
  final VoidCallback? onLoadingMore;
  final Axis scrollDirection;
  final Widget separation;
  final Widget? loadingWidget;
  final bool isLastPage;
  final EdgeInsetsGeometry? padding;

  List<Widget> get _getChildren {
    List<Widget> _children = [];
    for (Widget child in children) {
      _children.add(child);
    }
    if (!isLastPage) {
      _children.add(
        loadingWidget ??
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
      );
    }
    return _children;
  }

  void _addListener() {
    final _sc = controller ?? _internalController;
    _sc.addListener(() async {
      if (_sc.position.atEdge && _sc.offset > 0 && onLoadingMore != null) {
        onLoadingMore?.call();
      }
    });
  }

  void _bloclistener(BuildContext context, bloc.State state) {
    /*    if (state is bloc.SelectFilterState) {
      _internalController.jumpTo(0);
    } */
  }

  @override
  Widget build(BuildContext context) {
    _addListener();

    return BlocListener<bloc.Bloc, bloc.State>(
      listener: _bloclistener,
      child: ListView.separated(
        padding: padding,
        shrinkWrap: shrinkWrap,
        primary: primary,
        controller: controller == null ? _internalController : null,
        scrollDirection: scrollDirection,
        itemCount: _getChildren.length,
        itemBuilder: (_, index) => _getChildren[index],
        separatorBuilder: (_, __) => separation,
      ),
    );
  }
}
