import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/UserModel/room_model.dart';

class RoomManagementScreen extends StatefulWidget {
  const RoomManagementScreen({Key? key}) : super(key: key);

  @override
  State<RoomManagementScreen> createState() => _RoomManagementScreenState();
}

class _RoomManagementScreenState extends State<RoomManagementScreen> {
  String? selectedArea;
  TextEditingController roomIdController = TextEditingController();
  TextEditingController roomNameController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Room? selectedRoom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Quản Lý Phòng Học',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Themes.gradientDeepClr, Themes.gradientLightClr],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
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
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: rooms.length + 1,
                          itemBuilder: (context, index) {
                            if (index == rooms.length) {
                              return GestureDetector(
                                onTap: () => showRoomForm(null),
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

                            bool canDeleteRoom = rooms[index].devices!.isEmpty;
                            return Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => showRoomForm(rooms[index]),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          rooms[index].roomName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'SL thiết bị: ${rooms[index].devices!.length}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (canDeleteRoom) {
                                        // Chức năng xóa lớp khi nhấn chọn
                                        showDeleteConfirmation(rooms[index]);
                                      } else {
                                        // Hiển thị thông báo không cho phép xóa
                                        showSnackbar("Không thể xóa phòng!");
                                      }
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: canDeleteRoom
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showRoomForm(Room? existingRoom) {
    String generatedRoomId = generateRoomId();
    selectedRoom = existingRoom;
    roomIdController.text = existingRoom?.roomId ?? 'R$generatedRoomId';
    roomNameController.text = existingRoom?.roomName ?? '';
    floorController.text = existingRoom?.floor ?? '';
    descriptionController.text = existingRoom?.description ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color.fromARGB(222, 19, 81, 238), width: 2.0),
          ),
          elevation: 2,
          title: Text(
            selectedRoom == null ? 'Thêm mới phòng' : 'Cập nhật phòng',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 24, 87, 222),
            ),
            textAlign: TextAlign.center,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // RoomID input
                  TextFormField(
                    controller: roomIdController,
                    decoration: InputDecoration(
                      labelText: 'Mã Phòng',
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  // RoomName input
                  TextFormField(
                    controller: roomNameController,
                    decoration: InputDecoration(
                      labelText: 'Tên Phòng',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên phòng';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Floor input
                  TextFormField(
                    controller: floorController,
                    decoration: InputDecoration(
                      labelText: 'Tầng',
                    ),
                    keyboardType: TextInputType.number, // Set the keyboard type to number
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Allow only numeric input
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tầng';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Description input
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Mô tả',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mô tả';
                      }
                      return null;
                    },
                  ),
                ],
              );
            },
          ),
           actions: <Widget>[
            TextButton(
              child: Text(
                selectedRoom == null ? 'Thêm' : 'Cập nhật',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 24, 87, 222)),
              ),
              onPressed: () {
                if (_validateForm()) {
                  selectedRoom == null ? addNewRoom() : updateRoom(selectedRoom!);
                  Get.snackbar("Thông Báo!", selectedRoom == null ? "Thêm phòng mới thành công." : "Cập nhật phòng thành công.");
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar("Lỗi", "Vui lòng điền đầy đủ thông tin");
                }
              },
            ),
          ],
        );
      },
    );
  }

  void updateRoom(Room room) async {
    if (selectedArea == null) {
      Get.snackbar('Thông Báo', "Bạn chưa chọn khu vực!");
    } else {
      var areaDB = FirebaseFirestore.instance.collection("Area").doc(selectedArea).collection("Room");

      await areaDB.doc(room.roomId).update({
        'Room Name': roomNameController.text,
        'Floor': floorController.text,
        'Description': descriptionController.text,
      });

      roomIdController.clear();
      roomNameController.clear();
      floorController.clear();
      descriptionController.clear();
    }
  }

  bool _validateForm() {
    // Add your validation logic here
    if (roomNameController.text.isEmpty ||
        floorController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      return false;
    }
    return true;
  }

  String generateRoomId() {
    // You can implement your logic to generate a unique Room ID here.
    // For example, you can use a random number or a timestamp.
    return DateTime.now().millisecondsSinceEpoch.toString().substring(7);
  }

  void showDeleteConfirmation(Room room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận Xóa Phòng'),
          content: const Text('Bạn có chắc chắn muốn xóa phòng này không?'),
          actions: [
            TextButton(
              onPressed: () {
                // Xử lý chức năng xóa phòng
                deleteRoom(room);
                Navigator.of(context).pop();
              },
              child: const Text('Xóa'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  void deleteRoom(Room room) {
    FirebaseFirestore.instance
        .collection('Area')
        .doc(selectedArea)
        .collection('Room')
        .doc(room.roomId)
        .delete();
  }

  void addNewRoom() async {
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
        description: description,
      );
      setState(() {
        areaDB.doc(roomId).set(newRoom.toMap());
      });
      roomIdController.clear();
      roomNameController.clear();
      floorController.clear();
      descriptionController.clear();
    }
  }
}
