import 'package:bit_messenger/features/auth/controller/auth_controller.dart';
import 'package:bit_messenger/features/home/screens/chat_contacts_list.dart';
import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/features/home/delegates/serch_user_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ref.read(authControllerProvider).setUserState(true);
    } else {
      // case AppLifecycleState.paused:
      // case AppLifecycleState.inactive:
      // case AppLifecycleState.detached:
      ref.read(authControllerProvider).setUserState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'Bit Messenger',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            indicatorColor: primaryColor,
            indicatorWeight: 4,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'CHATS',
                height: 40,
              ),
              Tab(
                text: 'STATUS',
                height: 40,
              ),
            ],
          ),
        ),
        body: const ChatContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //  delegates Inbuilt Method
            showSearch(
              context: context,
              delegate: SearchUserDelegate(ref),
            );
          },
          backgroundColor: primaryColor,
          child: const Icon(
            Icons.person_search_sharp,
            size: 28,
            color: greyColor,
          ),
        ),
      ),
    );
  }
}
