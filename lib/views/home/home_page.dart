import 'package:alem_application/bloc/search/search_bloc.dart';
import 'package:alem_application/bloc/search/search_event.dart';
import 'package:alem_application/views/myClient/my_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alem_application/bloc/auth_bloc.dart';
import 'package:alem_application/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:alem_application/bloc/schedulePayment_bloc.dart';
import 'package:alem_application/views/calendar/calendar.dart';
import 'package:alem_application/views/home/widget/main_info_user.dart';
import 'package:alem_application/views/schedule_payment/schedule_payment.dart';
import 'package:alem_application/views/profile/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _pageController;
  int _currentIndex = 0;
  List<String> pageTitles = [
    "Главная",
    "Календарь",
    "Оплаты клиентов",
    "Клиенты"
        "Мой профиль",
  ]; // заголовки для каждой страницы

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavigationBarTap(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 4,
        backgroundColor: Color(0xFF035AA6),
        title: Text(pageTitles[_currentIndex]),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(ResetAuthEvent());
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _buildPageChildren(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  List<Widget> _buildPageChildren() {
    return [
      BlocProvider<CalendarBloc>(
        create: (context) => CalendarBloc()..add(FetchMeetings()),
        child: MainInfoUser(),
      ),
      BlocProvider(
        create: (context) => CalendarBloc()..add(FetchMeetings()),
        child: Calendar(),
      ),
      BlocProvider(
        create: (context) =>
            SchedulePaymentBloc()..add(CheckSchedulePaymentEvent()),
        child: SchedulePaymentPage(),
      ),
      BlocProvider(
        create: (context) => MyClientBloc()..add(SearchClientEvent('')),
        child: MyClient(),
      ),
      Center(child: UserBlock()),
    ];
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedFontSize: 15,
      unselectedFontSize: 12,
      iconSize: 26.0,
      selectedIconTheme: const IconThemeData(
        size: 32,
        color: Color.fromARGB(255, 14, 109, 192),
      ),
      unselectedIconTheme: const IconThemeData(size: 28),
      backgroundColor: Colors.white,
      selectedItemColor: const Color.fromARGB(255, 14, 109, 192),
      unselectedItemColor: const Color.fromARGB(255, 95, 128, 157),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onBottomNavigationBarTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Календарь',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_document),
          label: 'Оплаты',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.agriculture_outlined),
          label: 'Клиенты',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профиль',
        ),
      ],
    );
  }
}
