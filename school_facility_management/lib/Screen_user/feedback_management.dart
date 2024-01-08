import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/UserModel/feadback_model.dart';

class FeedbackManagementPage extends StatefulWidget {
  const FeedbackManagementPage({super.key});

  @override
  State<FeedbackManagementPage> createState() => _FeedbackManagementPageState();
}

class _FeedbackManagementPageState extends State<FeedbackManagementPage> {
  // Định nghĩa các biến state cần thiết ở đây
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<String> itemList = ['Ngày', 'Tên', 'Email', 'Điểm'];
  String selectedItem = 'Ngày';

  List<String> hintItemList = [
    '01/01/2024',
    'Nguyễn Văn A',
    'nguyenvana@gmail.com',
    '5'
  ];
  int selectecHintText = 0;

  @override
  void initState() {
    super.initState();
    // Khởi tạo trạng thái ban đầu ở đây
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Phiếu đánh giá',
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0,
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      hintText: hintItemList[selectecHintText],
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white70,
                        size: 28,
                      ),
                      border: InputBorder.none,
                      suffixIconConstraints:
                          const BoxConstraints(maxHeight: 30, maxWidth: 30),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchText = '';
                            _searchController.text = _searchText;
                          });
                        },
                        child: Container(
                          width: 19,
                          height: 19,
                          margin: const EdgeInsets.only(
                            right: 10,
                          ),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white70,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.clear,
                              size: 18,
                              color: Colors.blueGrey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                        _searchController.text = _searchText;
                      });
                    },
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 50,
                margin: const EdgeInsets.only(right: 15, bottom: 9),
                padding: const EdgeInsets.only(left: 15, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedItem,
                    onChanged: (newValue) {
                      setState(() {
                        selectedItem = newValue!;
                        selectecHintText = itemList.indexOf(selectedItem);
                      });
                    },
                    items: itemList.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Đánh giá
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: getFeedbackDocumentStream(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              List<FeedbackModel> feedbackList = snapshot.data!.docs
                  .map((doc) => FeedbackModel.fromJson(doc.data()))
                  .toList();

              // Danh sách trống

              if (feedbackList.isEmpty) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/empty-box.png',
                          width: 250,
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Danh sách trống',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Text(
                          'Chưa có đánh giá từ người dùng.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              //-------------------------------

              feedbackList.sort((a, b) => b.rateDate!.compareTo(a.rateDate!));

              List<FeedbackModel> tempFeedbackList = feedbackList;
              if (_searchText.trim() == '') {
                feedbackList = tempFeedbackList;
              } else {
                feedbackList = tempFeedbackList.where((element) {
                  if (selectedItem == itemList[0]) {
                    String date =
                        DateFormat('dd/MM/yyyy').format(element.rateDate!);
                    if (date.contains(_searchText.trim().toLowerCase())) {
                      return true;
                    }
                  }
                  if (selectedItem == itemList[1]) {
                    if (element.username!
                        .toLowerCase()
                        .contains(_searchText.trim().toLowerCase())) {
                      return true;
                    }
                  }
                  if (selectedItem == itemList[2]) {
                    if (element.useremail!
                        .toLowerCase()
                        .contains(_searchText.trim().toLowerCase())) {
                      return true;
                    }
                  }
                  if (selectedItem == itemList[3]) {
                    if (element.rating!
                        .toString()
                        .contains(_searchText.trim().toLowerCase())) {
                      return true;
                    }
                  }
                  return false;
                }).toList();
              }
              // Xử lý không tìm ra kết quả
              if (feedbackList.isEmpty) {
                return SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/no_result_search_icon.png',
                          width: 250,
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                        const Text(
                          'Không tìm thấy kết quả',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Rất tiếc, chúng tôi không tìm thấy kết quả mà bạn mong muốn, hãy thử lại xem sao.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              //--------------------------------
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: feedbackList.length,
                itemBuilder: (BuildContext context, int index) {
                  final feedback = feedbackList[index];
                  String formattedDate =
                      DateFormat('dd/MM/yyyy HH:mm').format(feedback.rateDate!);
                  List<Widget> textWidgets =
                      generateTextWidgets(feedback.content!);

                  return Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          left: 15,
                          right: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feedback.username!.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              feedback.useremail!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RatingBar.builder(
                              initialRating: feedback.rating!,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 1),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              ignoreGestures: true,
                              onRatingUpdate: (rating) {},
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: textWidgets,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5),
                            ),
                          ],
                        ),
                      ),
                      // Positioned(
                      //   top: 20,
                      //   right: 30,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       _showDeleteConfirmationDialog(
                      //           context, feedback.idDoc!);
                      //     },
                      //     child: const Icon(
                      //       Icons.delete,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // )
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Đã xảy ra lỗi: ${snapshot.error}');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFeedbackDocumentStream() {
    return FirebaseFirestore.instance.collection('feedback').snapshots();
  }

  List<Widget> generateTextWidgets(List<String> content) {
    if (content.isNotEmpty) {
      int lastIndex = content.length - 1;
      String text1 = content.sublist(0, lastIndex).join(", ");
      String text2 = content[lastIndex];

      return [
        Text(
          '$text1.',
          style: const TextStyle(fontSize: 13),
        ),
        Text(
          'Ngoài ra: $text2.',
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(
          height: 5,
        ),
      ];
    }
    return [const SizedBox()];
  }

  // void _showDeleteConfirmationDialog(BuildContext context, String id) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Xác nhận xóa đánh giá'),
  //         content: const Text('Bạn có chắc chắn muốn xóa đánh giá này?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Hủy'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               _deleteFeedback(id);
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Xóa'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _deleteFeedback(String id) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('feedback').doc(id).delete();
  //   } catch (e) {
  //     print('Error deleting doctor: $e');
  //   }
  // }
}
