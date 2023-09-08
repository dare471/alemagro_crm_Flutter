import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserBlock extends StatefulWidget {
  @override
  _UserBlockState createState() => _UserBlockState();
}

class _UserBlockState extends State<UserBlock>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final authData = Hive.box('authBox').get('data');

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
      padding: EdgeInsets.all(10),
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
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white, fontSize: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const CircleAvatar(
                        maxRadius: 60,
                        child: Icon(
                          Icons.person,
                          size: 80,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(authData['user']['name'].toString()),
                    ],
                  ),
                  SizedBox(width: 30),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Почта: '),
                        Text('${authData['user']['email'].toString()}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13)),
                        Text(
                            'Телеграм ID: ${authData['user']['telegramId'].toString()}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13))
                      ]),
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
                        child: Text("Раздел Уведомления"),
                      ),
                      Center(
                        child: Text("Раздел Контрактов"),
                      ),
                      Center(
                        child: Text("Раздел Настроек"),
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
