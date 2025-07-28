import 'package:flutter/material.dart';
import 'package:vra_asset_manager/models/gear.dart';
import 'package:vra_asset_manager/widgets/click_icon.dart';

class GearTab extends StatelessWidget {
  final Future<List<Gear>> gears;
  final Map<int, List<String>> selection;

  const GearTab({super.key, required this.gears, required this.selection});

  bool _isSelected(id, key) {
    return selection.containsKey(id) && selection[id]!.contains(key);
  }

  void _toggleSelection(id, key) {
    if (!selection.containsKey(id)) {
      selection[id] = [key];
    } else {
      List<String> keys = selection[id]!;
      if (keys.contains(key)) {
        keys.remove(key);
        if (keys.isEmpty) {
          selection.remove(id);
        }
      } else {
        keys.add(key);
      }
    }
  }

  void _showInputDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final FocusNode focusNode = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add Note'),
          content: TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Enter your note',
              border: OutlineInputBorder(),
            ),
            maxLines: 6,
            maxLength: 300,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String userInput = controller.text;
                print('User entered: $userInput');
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Gear>>(
      future: gears,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }
        final gears = snapshot.data ?? [];
        if (gears.isEmpty) {
          return const Center(child: Text('No gears found'));
        }
        return ListView.builder(
          itemCount: gears.length,
          itemBuilder: (context, index) {
            final gear = gears[index];
            return ListTile(
              // contentPadding: EdgeInsets.symmetric(
              //   horizontal: 4.0,
              //   vertical: 4.0,
              // ),
              // leading: Badge(label: Text("New"), child: Icon(Icons.circle)),
              dense: true,
              // trailing: index % 2 == 0
              //     ? IconButton(icon: Icon(Icons.edit), onPressed: () {})
              //     : Checkbox(value: false, onChanged: (value) {}),
              tileColor: index % 2 == 0
                  ? Colors.greenAccent[50]
                  : Colors.green[50],
              // subtitle: Row(children: [ClickIcon(), ClickIcon()]),
              title: Column(
                children: [
                  Row(
                    children: [
                      Text(gear.name, style: TextStyle(fontSize: 16)),

                      const SizedBox(width: 4),

                      gear.createdAt != null &&
                              DateTime.now()
                                      .difference(gear.createdAt!)
                                      .inDays
                                      .abs() <
                                  7
                          ? Badge(
                              label: Text("New"),
                              backgroundColor: Colors.blue,
                            )
                          : const SizedBox.shrink(),

                      // not accurate; expiring and expired to be handled
                      gear.expiryDate != null &&
                              gear.expiryDate!
                                      .difference(DateTime.now())
                                      .inDays <
                                  0
                          ? Badge(
                              label: Text("Expiring"),
                              backgroundColor: Colors.red,
                            )
                          : const SizedBox.shrink(),
                      gear.missing!
                          ? Badge(
                              label: Text("Missing"),
                              backgroundColor: Colors.orange,
                            )
                          : const SizedBox.shrink(),
                      gear.damaged!
                          ? Badge(
                              label: Text("Damaged"),
                              backgroundColor: Colors.red,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  gear.damaged! ? Text('Do not used!') : SizedBox.shrink(),
                  gear.missing! == false && gear.damaged! == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClickIcon(
                              id: gear.id,
                              title: 'Used',
                              iconData: Icons.check_box,
                              selected: _isSelected(gear.id, 'Used'),
                              onChanged: (value) {
                                _toggleSelection(gear.id, 'Used');
                              },
                            ),
                            ClickIcon(
                              id: gear.id,
                              title: 'Damaged',
                              iconData: Icons.broken_image,
                              selectedColor: Colors.red,
                              selected: _isSelected(gear.id, 'Damaged'),
                              onChanged: (value) {
                                _toggleSelection(gear.id, 'Damaged');
                              },
                            ),
                            ClickIcon(
                              id: gear.id,
                              title: 'Missing',
                              iconData: Icons.question_mark,
                              selectedColor: Colors.orange,
                              selected: _isSelected(gear.id, 'Missing'),
                              onChanged: (value) {
                                _toggleSelection(gear.id, 'Missing');
                              },
                            ),
                            ClickIcon(
                              id: gear.id,
                              title: 'Add Note',
                              iconData: Icons.note_add,
                              selectedColor: Colors.green,
                              selected: _isSelected(gear.id, 'Add Note'),
                              onChanged: (value) {
                                _toggleSelection(gear.id, 'Add Note');
                                if (value == true) {
                                  _showInputDialog(context);
                                }
                              },
                            ),

                            // ChoiceChip(
                            //   label: Text('Used'),
                            //   selected: false,
                            //   // selected: _value == index,
                            //   // onSelected: (bool selected) {
                            //   //   setState(() {
                            //   //     _value = selected ? index : null;
                            //   //   });
                            //   // },
                            // ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              // subtitle: Text(gear.gearContainerId.toString()),
              // trailing: Text(gear.id.toString()),
              // onTap: () {gear
              //   // Optional: Navigate to a detailed view
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text('Selected: ${gear.name}')),
              //   );
              // },
              // leading: Icon(
              //   Icons.circle,
              //   color: index % 2 == 0 ? Colors.blue : Colors.green,
              // ),
            );
          },
        );
      },
    );
  }
}
