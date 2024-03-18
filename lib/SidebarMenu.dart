import 'package:adminmmas/sidebar_menu_bloc/sidebar_menu_event.dart';
import 'package:adminmmas/sidebar_menu_bloc/sidebar_menu_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



import 'BLoC.dart';
import 'ScreensView.dart';
import 'constants.dart';
import 'menuTree.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => SidebarMenuBloc()
              ..add(FetchSidebarMenuEvent(menu: "Dashboard")),
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFe2e1e4),
          body: BlocBuilder<SidebarMenuBloc, SidebarMenuState>(
            builder: (context, state) {
              if (state is SidebarMenuSuccess) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color:Colors.white,
                      width: 270,
                      child: Column(
                        children: [
                          // Widget at the top side of the sidebar (preference).
                          Container(
                            color: Colors.white,
                            width: 270,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                                left: 12,
                                right: 12,
                                bottom: 15,
                              ),
                              child:  Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage(
                                              "${HOST}/media/assets/logo/logommas.png"),
                                        )
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Meet me after school",
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          // Sidebar menu widget
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: TreeView.simple(
                                tree: menuTree,
                                expansionBehavior: ExpansionBehavior.collapseOthers,
                                indentation: const Indentation(width: 0),
                                expansionIndicatorBuilder: (context, node) {
                                  return ChevronIndicator.rightDown(
                                    alignment: Alignment.centerLeft,
                                    tree: node,
                                    color: Colors.black,
                                    icon: Icons.arrow_right,
                                  );
                                },
                                onItemTap: (item) {
                                  BlocProvider.of<SidebarMenuBloc>(context).add(
                                      FetchSidebarMenuEvent(menu: item.key));
                                },
                                builder: (context, node) {
                                  final isSelected = state.menu == node.key;
                                  final isExpanded = node.isExpanded;
                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Container(
                                      color: node.level >= 2 || isExpanded
                                          ? Colors.white// For coloring the background of child nodes
                                          : Colors.white,
                                      height:
                                      45, // Padding between one menu and another.
                                      width: 270,
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: node.level >= 2
                                            ? const EdgeInsets.only(
                                            left:
                                            27) // Padding for the children of the node
                                            : const EdgeInsets.only(left: 0),
                                        child: Container(
                                          width: 270,
                                          height:
                                          45, // The size dimension of the active button
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? node.isLeaf
                                                ? Colors.orange// The color for the active node.
                                                : null
                                                : null,
                                            borderRadius:
                                            const BorderRadius.only(
                                              topLeft: Radius.circular(
                                                50,
                                              ),
                                              bottomLeft: Radius.circular(
                                                50,
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 25,
                                            ),
                                            child: node.level >= 2
                                                ? Text(
                                              node.key,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            )
                                                : Row(
                                              children: [
                                                Icon(
                                                  node.data,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  node.key,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ScreensView(menu: state.menu),
                    ),
                  ],
                );
              } else if (state is SidebarMenuError) {
                return const Center(
                  child: Text(
                    "An error has occurred. Please try again later.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}