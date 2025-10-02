import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/presentation/widgets/backgrounds/waves_background.dart';
import 'package:poc_street_path/presentation/widgets/shakles/shakle_home_item.dart';
import 'package:poc_street_path/core/l10n/app_localizations.dart';
import 'package:poc_street_path/core/themes/global_ui_options.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        body: Stack(
          children: [
            Transform.translate(
              offset: Offset(width * 0.3, height * 0.6),
              child: WaveBackground(color: Theme.of(context).colorScheme.primary),
            ),
            Transform.translate(
              offset: Offset(width * 0.3, height * 0.5),
              child: WaveBackground(color: Theme.of(context).colorScheme.primary),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(screenMargin),
                child: Column(
                  children: [
                    Expanded(child: SizedBox()),
                    Row(
                      children: [
                        Expanded(
                          child: ShakleHomeItem(
                            iconData: Icons.add_moderator_outlined,
                            title: AppLocalizations.of(context)!.homeAddOption,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ShakleHomeItem(
                            iconData: Icons.person_search_outlined,
                            title: AppLocalizations.of(context)!.homeSearchOption,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ShakleHomeItem(
                            iconData: Icons.perm_camera_mic_outlined,
                            title: AppLocalizations.of(context)!.homeNews,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ShakleHomeItem(
                            iconData: Icons.perm_camera_mic_outlined,
                            title: AppLocalizations.of(context)!.homeOptions,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
