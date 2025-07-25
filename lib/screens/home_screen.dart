import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vra_asset_manager/models/gear.dart';
import 'package:vra_asset_manager/models/gear_type.dart';
import 'package:vra_asset_manager/widgets/gear_tab.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasLocalData = false;
  // bool _isOnline = true;
  final Map<int, List<String>> selectionMap = {};

  // Future<void> _checkConnectivity() async {
  //   final result = await ConnectivityService().isOnline();
  //   setState(() {
  //     _isOnline = result;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // _checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Gear>>(
      future: Provider.of<DatabaseService>(
        context,
        listen: false,
      ).fetchByType(GearType.container),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasData == false) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }
        final containers = snapshot.data!;
        return DefaultTabController(
          length: containers.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('VRA Asset Manager'),
              actions: [
                Consumer<DatabaseService>(
                  builder: (context, service, child) {
                    return service.isDataSavedLocally
                        ? IconButton(
                            icon: const Icon(Icons.upload, color: Colors.red),
                            tooltip: 'Save Tab',
                            onPressed: () {
                              Provider.of<DatabaseService>(
                                context,
                                listen: false,
                              ).uploadSavedData();
                              // setState(() {});
                            },
                          )
                        : const SizedBox.shrink();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.save, color: Colors.black),
                  tooltip: 'Save Tab',
                  onPressed: () {
                    Provider.of<DatabaseService>(
                      context,
                      listen: false,
                    ).saveGearLog(selectionMap);

                    selectionMap.clear();
                    setState(() {});
                  },
                ),
              ],
              bottom: TabBar(
                tabs: containers.map((item) => Tab(text: item.name)).toList(),
                isScrollable: true,
              ),
            ),
            body: containers.isEmpty
                ? AlertDialog(
                    title: Text('App does not have preloaded data to run'),
                    content: Text(
                      'Run the app at least once with connectivity to preload data for offline mode',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // _checkConnectivity();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  )
                : TabBarView(
                    children: containers.map((item) {
                      return GearTab(
                        gears: Provider.of<DatabaseService>(
                          context,
                          listen: false,
                        ).fetchByParent(id: item.id),
                        selection: selectionMap,
                      );
                    }).toList(),
                  ),
          ),
        );
      },
    );
  }
}
