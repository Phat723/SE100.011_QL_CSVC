import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/UserModel/room_model.dart';

class RoomManagementScreen extends StatefulWidget {
  const RoomManagementScreen({super.key});

  @override
  State<RoomManagementScreen> createState() => _RoomManagementScreenState();
}

class _RoomManagementScreenState extends State<RoomManagementScreen> {
  String? selectedArea;
  TextEditingController roomIdController = TextEditingController();
  TextEditingController roomNameController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Room Management"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Khu vực",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Area")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Có lỗi xảy ra");
                        }
                        return Container(
                          width: context.width / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black12)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const DropdownMenuItem(
                                value: null,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Chọn Khu Vực"),
                                ),
                              ),
                              isExpanded: true,
                              value: selectedArea,
                              items: snapshot.data?.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem(
                                  value: document.id,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        (document.data() as Map)['Area Name']),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedArea = value!;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Area')
                      .doc(selectedArea)
                      .collection('Room')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Không tìm thấy phòng');
                    }
                    if (snapshot.hasData) {
                      List<Room> rooms = snapshot.data!.docs
                          .map((doc) => Room.fromMap(doc.data()))
                          .toList();
                      return Container(
                        height: 450,
                        padding: const EdgeInsets.all(8.0),
                        width: context.width,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Số cột trong grid
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: rooms.length + 1,
                          itemBuilder: (context, index) {
                            if (index == rooms.length) {
                              return GestureDetector(
                                onTap: () => showRoomForm(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                ),
                              );
                            }
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    rooms[index].roomName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'SL thiết bị: ${rooms[index].devices!.length}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addNewRoom() async{
    if (selectedArea == '' || selectedArea == null) {
      Get.snackbar('Thông Báo', "Bạn chưa chọn khu vực!");
    } else {
      String roomId = roomIdController.text;
      String roomName = roomNameController.text;
      String floor = floorController.text;
      String description = descriptionController.text;
      var areaDB = FirebaseFirestore.instance
          .collection("Area")
          .doc(selectedArea)
          .collection("Room");
      Room newRoom = Room(
          areaId: selectedArea!,
          roomId: roomId,
          roomName: roomName,
          floor: floor,
          description: description);
      setState(() {
        areaDB.doc(roomId).set(newRoom.toMap());
      });
      roomIdController.clear();
      roomNameController.clear();
      floorController.clear();
      descriptionController.clear();
    }
  }

  void showRoomForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.black, width: 2.0)),
          elevation: 2,
          title: const Text('Add New Room'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // RoomID input
                  TextFormField(
                    controller: roomIdController,
                    decoration: const InputDecoration(labelText: 'RoomID'),
                  ),
                  const SizedBox(height: 10),
                  // RoomName input
                  TextFormField(
                    controller: roomNameController,
                    decoration: const InputDecoration(labelText: 'RoomName'),
                  ),
                  const SizedBox(height: 10),
                  // Floor input
                  TextFormField(
                    controller: floorController,
                    decoration: const InputDecoration(labelText: 'Floor'),
                  ),
                  const SizedBox(height: 10),
                  // Description input
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                addNewRoom();
                Get.snackbar("Thông Báo!", "Thêm phòng mới thành công.");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
