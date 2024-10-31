import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CattegoryDropdownController extends GetxController {
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  RxString? selectedCategoryId;
  RxString? selectedCategoryName;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      List<Map<String, dynamic>> categoriesList = [];

      querySnapshot.docs
          .forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        categoriesList.add({
          'categoryId': document.id,
          'categoryName': document['categoryName'],
          'categoryImg': document['categoryImg'],
        });
      });
      categories.value = categoriesList;
      update();
    } catch (e) {
      print("Error: $e");
    }
  }

  //Set selected Category
  void SetSelectedCategory(String? categoryId) {
    selectedCategoryId = categoryId?.obs;
    print("Selected category Id: $selectedCategoryId");
    update();
  }

  //Fetch Category Name
  Future<String?> getCategoryName(String? categoryId) async {
    try {
      // Access Firestore collection and document
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('categories')
          .doc(categoryId)
          .get();

      // Extract category name from snapshot
      if (snapshot.exists) {
        return snapshot.data()?['categoryName'];
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching category name: $e");
      return null;
    }
  }

  // set categoryName
  void setSelectedCategoryName(String? categoryName) {
    selectedCategoryName = categoryName?.obs;
    print('selectedCategoryName $selectedCategoryName');
    update();
  }

  // set old value
  void setOldValue(String? categoryId) {
    selectedCategoryId = categoryId?.obs;
    print('selectedCategoryId $selectedCategoryId');
    update();
  }
}
