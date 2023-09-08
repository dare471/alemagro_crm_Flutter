import 'package:flutter/material.dart';

class UserBlock extends StatefulWidget {
  @override
  _UserBlockState createState() => _UserBlockState();
}

class _UserBlockState extends State<UserBlock>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(25),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF035AA6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        maxRadius: 60,
                        child: Icon(
                          Icons.person,
                          size: 80,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Name'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('information'),
                      Text('information'),
                      Text('information'),
                      Text('information'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      icon: Icon(
                        Icons.info_outlined,
                        color: Color(0xFF035AA6),
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.dashboard_customize_sharp,
                        color: Color(0xFF035AA6),
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.brightness_5_sharp,
                        color: Color(0xFF035AA6),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      Center(
                        child: Text("It's info user here"),
                      ),
                      Center(
                        child: Text("It's order here"),
                      ),
                      Center(
                        child: Text("It's setting here"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
