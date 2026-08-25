import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTabBarWidget extends StatelessWidget {
  const AppTabBarWidget({super.key, required this.tabs, required this.titles});

  final List<Widget> tabs, titles;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Retrieve specific theme colors
    Color primaryColor = theme.primaryColor;
    return Expanded(
      child: DefaultTabController(
        length: tabs.length,
        child: Column(
          children: [
            // Tab bar
            Container(
              color: primaryColor,
              padding: EdgeInsets.only(
                bottom: 10.h,
              ),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorColor: Colors.white,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 2.h,
                    color: Colors.white,
                  ),
                  insets: EdgeInsets.only(
                    top: 6.h,
                    right: 4,
                  ), // 👈 THIS
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
                tabs: titles,
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20.r),
                  ),
                ),
                child: TabBarView(
                  children: tabs,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
