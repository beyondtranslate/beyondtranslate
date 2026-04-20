import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../utils/platform_util.dart';
import '../widgets/ui/loading_indicator.dart';
import 'home.dart';
import 'mini_translator.dart';

part 'bootstrap.g.dart';

/// Bootstrap route module.
///
/// This mirrors a TanStack Start-style route module layout:
/// - file-per-route entry
/// - route data colocated with route path declaration
@TypedGoRoute<BootstrapRoute>(
  path: '/bootstrap',
)
class BootstrapRoute extends GoRouteData with $BootstrapRoute {
  const BootstrapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BootstrapPage();
  }
}

class BootstrapPage extends StatefulWidget {
  const BootstrapPage({super.key});

  @override
  State<BootstrapPage> createState() => _BootstrapPageState();
}

class _BootstrapPageState extends State<BootstrapPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1)).then((_) => _init());
  }

  Future<void> _init() async {
    if (kIsAndroid || kIsIOS) {
      const HomeRoute().go(context);
    } else {
      const MiniTranslatorRoute().go(context);
    }
  }

  Widget _build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LoadingIndicator.threeBounce(
                            color: Theme.of(context).primaryColor,
                            size: 14.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
