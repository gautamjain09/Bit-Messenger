import 'package:bit_messenger/features/chat/widgets/chat_contacts_list.dart';
import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/features/home/delegates/serch_user_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
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
              Tab(
                text: 'CALLS',
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
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
