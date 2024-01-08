// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/UserModel/feadback_model.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  FeedbackModel? _feedback;
  double? count;
  List<bool> colorStates = List.generate(5, (index) => false);
  bool _isSaving = false;

  final TextEditingController _feedbackController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _feedback = FeedbackModel();
    count = 0;
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber.shade100.withOpacity(0.7),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Vui lòng đánh giá chất lượng CSVC',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RatingBarIndicator(
                        rating: count!,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              count = index.toDouble() + 1;
                            });
                          },
                          child: const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        itemCount: 5,
                        itemSize: 50.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.lightbulb_fill,
                        color: Colors.orange,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Gợi ý đánh giá:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          colorStates[index] = !colorStates[index];
                        });
                      },
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorStates[index]
                              ? Colors.lightBlue.shade400
                              : Colors.grey.shade100,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            getTextFromIndex(index),
                            style: TextStyle(
                              fontSize: 15,
                              color: colorStates[index]
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        color: Colors.orange,
                        size: 33,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Ý kiến khác:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    controller: _feedbackController,
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey.shade100.withOpacity(0.7),
                        hintText:
                            'Chia sẻ về trải nghiệm sử dụng cơ sở vật chất của trường...',
                        hintStyle:
                            const TextStyle(fontWeight: FontWeight.w400)),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
              color: Colors.blueGrey,
              width: 0.3,
            ))),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        colorStates = List.generate(5, (index) => false);
                        _feedbackController.text = '';
                        count = 0;
                      });
                      Get.back();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      margin: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Hủy phiếu',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (count == 0) {
                          Get.snackbar(
                              "Thông Báo", "Vui lòng chọn điểm đánh giá CSVC!");

                          return;
                        }

                        _feedback!.useremail =
                            FirebaseAuth.instance.currentUser!.email;
                        _feedback!.idUser =
                            FirebaseAuth.instance.currentUser!.uid;
                        _feedback!.rateDate = DateTime.now();
                        _feedback!.content = [];
                        _feedback!.rating = count;
                        for (int i = 0; i < colorStates.length; i++) {
                          if (colorStates[i]) {
                            _feedback!.content!.add(getTextFromIndex(i));
                          }
                        }
                        if (_feedbackController.text != '') {
                          _feedback!.content!.add(_feedbackController.text);
                        }

                        saveFeedback(_feedback!);
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      margin: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Themes.gradientDeepClr,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Gửi phiếu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isSaving)
          const Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (_isSaving)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  String getTextFromIndex(int index) {
    switch (index) {
      case 0:
        return 'Vệ sinh không sạch sẽ';
      case 1:
        return 'Không gian chật';
      case 2:
        return 'Phòng thiếu ánh sáng';
      case 3:
        return 'Nhân viên kỹ thuật hỗ trợ không nhiệt tình';

      default:
        return '';
    }
  }

  Future<void> saveFeedback(FeedbackModel feedbackModel) async {
    setState(() {
      _isSaving = true;
    });
    try {
      // Lấy tham chiếu đến collection "feedback"
      CollectionReference feedbackCollection =
          FirebaseFirestore.instance.collection('feedback');

      // Tạo một document mới trong collection "feedback"
      String idDoc = DateTime.now().toString();
      DocumentReference newFeedbackDoc = feedbackCollection.doc(idDoc);
      _feedback!.idDoc = idDoc;
      _feedback!.username = await getClientName(_feedback!.idUser!);

      // Lưu dữ liệu feedback lên document mới
      await newFeedbackDoc.set(feedbackModel.toMap());
      Get.snackbar("Thông Báo", "Gửi phiếu đánh giá thành công");
      setState(() {
        colorStates = List.generate(5, (index) => false);
        _feedbackController.text = '';
        count = 0;
      });
      Navigator.of(context).pop();

      print('Lưu dữ liệu thành công!');
    } catch (error) {
      Get.snackbar(
          "Thông Báo", "Tạo phiếu đánh giá thất bại, vui lòng thử lại sau!");
      print('Lỗi khi lưu dữ liệu: $error');
    }
    setState(() {
      _isSaving = false;
    });
  }

  Future<String> getClientName(String idUser) async {
    String clientName = '';

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Client').doc(idUser).get();

    if (snapshot.exists) {
      String name = snapshot.data()?['Username'];
      clientName = name ?? '';
    }

    return clientName;
  }
}
