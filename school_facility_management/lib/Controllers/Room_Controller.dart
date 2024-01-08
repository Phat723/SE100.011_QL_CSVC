import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/UserModel/devices_detail_model.dart';
import 'package:school_facility_management/UserModel/room_model.dart';

class RoomController extends GetxController{
  static RoomController get instance => Get.find();

  Future<void> addDeviceToRoom(String areaId, String roomId, Map<String, dynamic> deviceName) async{
    try {
      // Lấy tham chiếu đến tài liệu Room cần cập nhật
      DocumentReference roomRef = FirebaseFirestore.instance.collection('Area').doc(areaId).collection("Room").doc(roomId);

      // Lấy dữ liệu hiện tại của tài liệu Room
      DocumentSnapshot roomSnapshot = await roomRef.get();
      if (roomSnapshot.exists) {
        // Chuyển dữ liệu từ Firestore thành đối tượng Room
        Room currentRoom = Room.fromMap(roomSnapshot.data() as Map<String, dynamic>);

        // Kiểm tra xem tên phòng mới đã tồn tại trong danh sách chưa
        if (!currentRoom.devices!.contains(deviceName)) {
          // Thêm tên phòng mới vào danh sách
          currentRoom.devices!.add(deviceName);

          // Cập nhật lại tài liệu Room trên Firestore
          await roomRef.update(currentRoom.toMap());

          print('Đã cập nhật danh sách tên phòng thành công.');
        } else {
          print('Tên phòng đã tồn tại trong danh sách.');
        }
      } else {
        print('Không tìm thấy phòng với mã: $roomId');
      }
    } catch (e) {
      print('Lỗi khi cập nhật danh sách tên phòng: $e');
    }
  }
  // Hàm để xóa thiết bị khỏi danh sách của một phòng và cập nhật lên Firestore
  Future<void> deleteDeviceFromRoom(String areaId, String roomId, DeviceDetail deviceName) async {
    try {
      // Lấy tham chiếu đến tài liệu Room cần cập nhật
      DocumentReference roomRef = FirebaseFirestore.instance.collection('Area').doc(areaId).collection("Room").doc(roomId);

      // Lấy dữ liệu hiện tại của tài liệu Room
      DocumentSnapshot roomSnapshot = await roomRef.get();
      if (roomSnapshot.exists) {
        // Chuyển dữ liệu từ Firestore thành đối tượng Room
        Room currentRoom = Room.fromMap(roomSnapshot.data() as Map<String, dynamic>);

        // Xóa thiết bị khỏi danh sách
        currentRoom.devices!.removeWhere((element) => element['DeviceDetail Name'] == deviceName.deviceDetailName);
        // Cập nhật lại tài liệu Room trên Firestore
        await roomRef.update(currentRoom.toMap());

        print('Đã cập nhật danh sách thiết bị và lưu lên Firestore thành công.');
      } else {
        print('Không tìm thấy phòng với mã: $roomId');
      }
    } catch (e) {
      print('Lỗi khi cập nhật danh sách thiết bị và lưu lên Firestore: $e');
    }
  }
  Future<void> updateStatusDevice(String areaId, String roomId, DeviceDetail deviceName, String statusChange) async {
    try {
      // Lấy tham chiếu đến tài liệu Room cần cập nhật
      DocumentReference roomRef = FirebaseFirestore.instance.collection('Area').doc(areaId).collection("Room").doc(roomId);

      // Lấy dữ liệu hiện tại của tài liệu Room
      DocumentSnapshot roomSnapshot = await roomRef.get();
      if (roomSnapshot.exists) {
        // Chuyển dữ liệu từ Firestore thành đối tượng Room
        Room currentRoom = Room.fromMap(roomSnapshot.data() as Map<String, dynamic>);

        currentRoom.devices!.removeWhere((element) => element['DeviceDetail Id'] == deviceName.deviceDetailId);
        deviceName.deviceStatus = statusChange;
        currentRoom.devices!.add(deviceName.toMap());


        // Cập nhật lại tài liệu Room trên Firestore
        await roomRef.update(currentRoom.toMap());

        print('Đã cập nhật danh sách thiết bị và lưu lên Firestore thành công.');
      } else {
        print('Không tìm thấy phòng với mã: $roomId');
      }
    } catch (e) {
      print('Lỗi khi cập nhật danh sách thiết bị và lưu lên Firestore: $e');
    }
  }
}