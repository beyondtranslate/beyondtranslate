import '../../routes/routes.dart';
import '../../utilities/utilities.dart';
import '../../widgets/ui/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BootstrapPage extends StatefulWidget {
  const BootstrapPage({Key? key}) : super(key: key);

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
      const DesktopPopupRoute().go(context);
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
