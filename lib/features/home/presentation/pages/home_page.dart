import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/responsive/responsive_builder.dart';
import 'package:multi_catalog_system/features/home/presentation/bloc/home_bloc.dart';
import 'package:multi_catalog_system/features/home/presentation/bloc/home_state.dart';
import 'package:multi_catalog_system/features/home/presentation/widgets/home_drawer_widget.dart';

class HomePage extends StatelessWidget {
  final Function(int index) onSelectTab;
  final Widget? body;
  const HomePage({super.key, required this.onSelectTab, this.body});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return ResponsiveBuilder(
          builder: (context, screen) {
            if (screen.isMobile) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: state.mapOrNull(
                    page: (p) => Text(
                      p.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                drawer: HomeDrawerWidget(onSelectTab: onSelectTab),
                body: body,
              );
            }

            return Row(
              children: [
                HomeDrawerWidget(onSelectTab: onSelectTab),
                Expanded(
                  child: Scaffold(
                    body: Column(
                      children: [
                        const SizedBox(height: 10),
                        ?state.mapOrNull(
                          page: (p) => Text(
                            p.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(child: body ?? Container()),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
