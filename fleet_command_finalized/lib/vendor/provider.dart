library vendor_provider;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Minimal Provider implementation - replaces package:provider
class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  final T Function(BuildContext) create;
  final Widget child;

  const ChangeNotifierProvider({
    super.key,
    required this.create,
    required this.child,
  });

  static T of<T>(BuildContext context, {bool listen = true}) {
    final provider = context.dependOnInheritedWidgetOfExactType<_InheritedProvider<T>>();
    assert(provider != null, 'No ChangeNotifierProvider<$T> found in context');
    return provider!.value;
  }

  @override
  State<ChangeNotifierProvider<T>> createState() => _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier> extends State<ChangeNotifierProvider<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.create(context);
    _value.addListener(_onChange);
  }

  void _onChange() => setState(() {});

  @override
  void dispose() {
    _value.removeListener(_onChange);
    _value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedProvider<T>(
      value: _value,
      child: widget.child,
    );
  }
}

class _InheritedProvider<T> extends InheritedWidget {
  final T value;

  const _InheritedProvider({
    required this.value,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedProvider<T> old) => true;
}

class MultiProvider extends StatelessWidget {
  final List<ChangeNotifierProvider> providers;
  final Widget child;

  const MultiProvider({
    super.key,
    required this.providers,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = child;
    for (final provider in providers.reversed) {
      result = provider;
    }
    return result;
  }
}

class Consumer<T> extends StatelessWidget {
  final Widget Function(BuildContext, T, Widget?) builder;
  final Widget? child;

  const Consumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final value = ChangeNotifierProvider.of<T>(context);
    return builder(context, value, child);
  }
}

class Consumer2<A, B> extends StatelessWidget {
  final Widget Function(BuildContext, A, B, Widget?) builder;
  final Widget? child;

  const Consumer2({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final a = ChangeNotifierProvider.of<A>(context);
    final b = ChangeNotifierProvider.of<B>(context);
    return builder(context, a, b, child);
  }
}

extension ProviderContext on BuildContext {
  T watch<T>() => ChangeNotifierProvider.of<T>(this, listen: true);
  T read<T>() => ChangeNotifierProvider.of<T>(this, listen: false);
}
