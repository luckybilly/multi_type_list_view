library multi_type_list_view;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// build widget for items of type [T]
/// implements [ buildWidget ] function to create widget
///
/// subclass can change its rule via override [canBuild] function
abstract class MultiTypeWidgetBuilder<T> {
  /// Determines whether this builder can create widgets for this [ item ] and [ index ]
  /// by default, matches the class type
  /// subclass can change the rule by override this function
  bool canBuild(dynamic item, int index) {
    return item is T;
  }

  /// Build a widget for the specific item of type [ T ]
  /// when returns null:
  /// 1) is not production(release) environment, check [MultiTypeListView.showDebugPlaceHolder] value:
  /// 1.1)  true: returns a default widget which created by [ MultiTypeListView.buildDebugPlaceHolder ]
  /// 1.2) false: returns a [new Offstage] widget
  /// 2) production(release) environment: returns a [new Offstage] widget
  Widget buildWidget(BuildContext context, T item, int index);
}

/// data is not null, but no [ MultiTypeWidgetBuilder ] specified
/// this builder can accept all not null item by override [ canBuild ] function
abstract class UnsupportedItemTypeWidgetBuilder extends MultiTypeWidgetBuilder {
  /// By default, [ UnsupportedItemTypeWidgetBuilder ] will match all items
  ///     which not null but none of [MultiTypeListView.widgetBuilders] matches
  ///
  /// Override this function will change the matching rule
  @override
  bool canBuild(item, int index) {
    return item != null;
  }
}

///
typedef WidgetWrapper<T> = Widget Function(Widget widget, T item, int index);

class MultiTypeListView extends ListView {
  static final bool inProduction =
      const bool.fromEnvironment("dart.vm.product");

  /// widget builders for item in [ items ]
  /// normally, the item is not null when called [ MultiTypeWidget.buildWidget ],
  ///     unless subclass override [ MultiTypeWidget.canBuild ] function to change the rule.
  final List<MultiTypeWidgetBuilder> widgetBuilders;

  /// widget builder for item in [ items ]
  final UnsupportedItemTypeWidgetBuilder widgetBuilderForUnsupportedItemType;

  /// list of multi-type items to show
  ///   each item in the list will match a [ MultiTypeWidgetBuilder ] by its class type by default.
  ///   Override [ MultiTypeWidgetBuilder.canBuild ] method will change the mapping of item -> builder.
  final List<dynamic> items;

  /// If set true, show debug place-holder if the building widget result is null in non-production environment
  final bool showDebugPlaceHolder;

  /// to wrap the building widget for each item (unless the building widget result is null)
  final WidgetWrapper widgetWrapper;

  MultiTypeListView({
    @required this.items,
    @required this.widgetBuilders,
    this.widgetBuilderForUnsupportedItemType,
    this.showDebugPlaceHolder = false,
    this.widgetWrapper,

    /// params copy from [ new ListView.builder ]
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    double itemExtent,
    int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  })  : assert(widgetBuilders != null, 'builders should not be null!'),
        assert(items != null, 'items should not be null!'),
        super.builder(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          itemExtent: itemExtent,
          itemCount: itemCount ?? items.length,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          itemBuilder: (context, index) {
            Widget itemWidget;
            dynamic item = items[index];
            MultiTypeWidgetBuilder builder = widgetBuilders
                .firstWhere((it) => it.canBuild(item, index), orElse: () {
              // none builder matches this item
              // try to match with widgetBuilderForUnsupportedItemType (if it not null)
              if (widgetBuilderForUnsupportedItemType != null &&
                  widgetBuilderForUnsupportedItemType.canBuild(item, index)) {
                return widgetBuilderForUnsupportedItemType;
              }
              return null;
            });
            itemWidget = builder?.buildWidget(context, item, index);

            if (itemWidget == null) {
              // The reasons why logical execution got here:
              //  1. no builder matches:
              //    1.1 none builder inside widgetBuilders matches this item
              //    1.2 widgetBuilderForUnsupportedItemType is null or widgetBuilderForUnsupportedItemType not match this item
              //  2. builder.buildWidget returns null
              if (showDebugPlaceHolder && !inProduction) {
                // debug mode only
                itemWidget = buildDebugPlaceHolder(index, item, builder);
              }
            }

            if (itemWidget != null && widgetWrapper != null) {
              itemWidget = widgetWrapper(itemWidget, item, index) ?? itemWidget;
            }

            return itemWidget ?? Offstage();
          },
        );

  /// (debug only) Build a debug place-holder widget
  static Container buildDebugPlaceHolder(
      int index, item, MultiTypeWidgetBuilder builder) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[300],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "DebugPlaceHolder of MultiTypeListView:\nindex: $index\nitem: $item\nbuilder:$builder\n"),
          Text(
            "You see this block because `showDebugPlaceHolder` is `true` and the current environment is in `debug` mode",
            style: TextStyle(color: Colors.grey[200]),
          ),
        ],
      ),
    );
  }
}
