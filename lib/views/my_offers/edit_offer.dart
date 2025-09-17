import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instajobs/models/offer-details_model.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/my_offers/add_addons_page.dart';
import 'package:dio/dio.dart' as diox;
import '../../bottom_sheets/choose_image_bottom_sheet.dart';
import '../../controllers/profile_controller.dart';
import '../../storage_services/local_stoage_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/currency_widget.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/form_input_with_hint_on_top.dart';
import '../../widgets/rounded_edged_button.dart';
import 'dart:convert';

class EditOffer extends StatefulWidget {
  final OfferDetailsModelData? offerDetailsModelData;

  const EditOffer({super.key, required this.offerDetailsModelData});

  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> with BaseClass {
  TextEditingController nameController = TextEditingController();
  TextEditingController deliveryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  ProfileController profileController = Get.put(ProfileController());

  //final List<File> _pickedImages = [];
  final Map<String, String> headers = {
    "Content-Type": "multipart/form-data",
    "Authorization": StorageService().getUserData().getAuthToken() ?? '',
  };
  Map<String, dynamic> queryParams = {};

  Future<void> _pickOne(ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (file == null) return;

    setState(() {
      _images.add(GridImage(file: File(file.path)));
      // _pickedImages.add(File(file.path));
    });
  }

  List<int> removedId = [];

  final List<int> _numbers = List.generate(90, (i) => i + 1);
  int? _selectedNumber;
  // Map<String, dynamic> addOnList = {};
  List<Map<String, dynamic>> addOnList = [];
  Future<void> _uploadImages() async {
    final localFiles =
    _images
        .where((img) => img.file != null)
        .map((img) => img.file!)
        .toList();
    if (localFiles.isEmpty) return;
    print('UPLOAD');
    final dio = diox.Dio();
    try {
      showGetXCircularDialog();
      // Build multipart form data
      final formData = diox.FormData.fromMap({
        ...queryParams,
        'image':
        localFiles.map((file) {
          return diox.MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split('/').last,
          );
        }).toList(),
      });

      print(queryParams);
      print(
        'https://app.superinstajobs.com/api/v1/offers/${widget.offerDetailsModelData?.id ?? -1}',
      );
      final response = await dio.put(
        'https://app.superinstajobs.com/api/v1/offers/${widget.offerDetailsModelData?.id ?? -1}',
        data: formData,
        options: diox.Options(headers: headers),
      );

      Get.back();
      if (response.statusCode == 200) {
        removeFocusFromEditText(context: context);
        showSuccess(title: 'Offer', message: 'Offer updated successfully');
        profileController.getOffersApi();

      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      showError(title: 'Offer', message: e.toString());
    }
  }

  final List<GridImage> _images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.offerDetailsModelData?.name ?? '';
    deliveryController.text =
    '${widget.offerDetailsModelData?.deliveryTime.toString() ?? '0'} days';
    priceController.text = widget.offerDetailsModelData?.price.toString() ?? '';
    descriptionController.text =
        widget.offerDetailsModelData?.description ?? '';
    _selectedNumber = widget.offerDetailsModelData?.deliveryTime ?? 0;

    for (var url in widget.offerDetailsModelData?.offerImages ?? []) {
      _images.add(GridImage(url: url.attachments ?? '', id: url.id));
    }
  }

  void _removeImage(int idx) {
    final removed = _images[idx];
    if (removed.url != null && removed.id != null) {
      removedId.add(removed.id ?? -1);
    }
    setState(() {
      _images.removeAt(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,

        title: Text(
          'Edit Offer',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            FormInputWithHint(
              label: 'Name',
              hintText: 'Title fof your project',
              controller: nameController,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Delivery',
                        textAlign: TextAlign.left,
                        style: AppStyles.font400_14().copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      CustomDropdown<int?>(
                        items: _numbers,
                        height: 48,
                        hint: 'Select Time',
                        selectedValue: _selectedNumber,
                        onChanged: (value) async {
                          setState(() {
                            _selectedNumber = value;
                          });
                        },
                        labelBuilder: (c) => '$c days',
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: FormInputWithHint(
                    label: 'Price',
                    hintText: 'Price',
                    keyboardType: TextInputType.number,

                    controller: priceController,
                    prefixIcon: GetCurrencyWidget(),
                    isDigitsOnly: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            FormInputWithHint(
              label: 'Describe your offer in more details!',
              hintText: 'Enter text here',
              controller: descriptionController,
              maxLine: 3,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    ChooseImageBottomSheet.show(
                      context: context,
                      onCancel: () {
                        popToPreviousScreen(context: context);
                      },
                      onCamera: () {
                        popToPreviousScreen(context: context);
                        _pickOne(ImageSource.camera);
                      },
                      onGallery: () {
                        popToPreviousScreen(context: context);
                        _pickOne(ImageSource.gallery);
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+ Upload files',
                      style: AppStyles.font500_14().copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pushToNextScreen(
                      context: context,
                      destination: AddAddonsPage(
                        onTap: (String title, String price, int workingDays) {
                          if (widget.offerDetailsModelData?.adOn?.isNotEmpty ??
                              false) {
                            addOnList.clear();
                          }
                          if (widget.offerDetailsModelData?.adOn == null) {
                            widget.offerDetailsModelData?.adOn = [];
                          }
                          widget.offerDetailsModelData?.adOn?.add(
                            OfferDetailsModelDataAdOn(
                              title: title,
                              price: price,
                              workingDays: workingDays.toString(),
                            ),
                          );
                          setState(() {});
                        },
                        addOnList: {},
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+ Add Addons',
                      style: AppStyles.font500_14().copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _images.length ?? 0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // ← 3 columns
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade200, // green background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image(
                          image: _images[index].provider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      /* Image(
                        image: NetworkImage(
                          widget.offerDetailsModelData?.offerImages
                                  ?.elementAt(index)
                                  ?.attachments ??
                              '',
                        ),
                        fit: BoxFit.cover,
                      ),*/
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      /* GestureDetector(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Colors.orange,
                          ),
                        ),
                        onTap: () {
                          // Handle image removal
                          setState(() {
                            _removeImage(index);
                            widget.offerDetailsModelData?.offerImages?.removeAt(
                              index,
                            );

                           */
                      /* removedId.add(
                              widget.offerDetailsModelData?.offerImages
                                      ?.elementAt(index)
                                      ?.id ??
                                  -1,
                            );*/
                      /*
                          });
                        },
                      ),*/
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.offerDetailsModelData?.adOn?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.offerDetailsModelData?.adOn
                                ?.elementAt(index)
                                ?.title ??
                                '',
                            style: AppStyles.font500_16().copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.offerDetailsModelData?.adOn
                                ?.elementAt(index)
                                ?.workingDays ??
                                '',
                            style: AppStyles.font500_16().copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      // --- price (right) ---
                      Padding(
                        padding: const EdgeInsets.only(right: 0, left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            GetCurrencyWidget(),
                            SizedBox(width: 6),
                            Text(
                              widget.offerDetailsModelData?.adOn
                                  ?.elementAt(index)
                                  ?.price ??
                                  '',
                              style: AppStyles.font500_16().copyWith(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            RoundedEdgedButton(
              buttonText: 'Update offer',
              onButtonClick: () async {
                String description = descriptionController.text.trim();
                String name = nameController.text.trim();
                String price = priceController.text.trim();
                int deliveryTime = _selectedNumber ?? 0;
                if (name.isEmpty) {
                  showError(title: 'Name', message: 'Please add name');
                } else if (name.length < 3) {
                  showError(title: 'Name', message: 'Name should be 3 character long');
                } else if (price.isEmpty) {
                  showError(title: 'Price', message: 'Please add price');
                } else if (description.isEmpty) {
                  showError(
                    title: 'Description',
                    message: 'Please add description',
                  );
                } else if (_selectedNumber == null) {
                  showError(
                    title: 'Delivery',
                    message: 'Please choose delivery time',
                  );
                } else {
                  final localFiles =
                  _images
                      .where((img) => img.file != null)
                      .map((img) => img.file!)
                      .toList();
                  if (localFiles.isNotEmpty) {
                    queryParams.addAll({
                      'description': description,
                      'name': name,
                      'price': price,
                      'deliveryTime': deliveryTime,
                    });
                    if (widget.offerDetailsModelData?.adOn != null && widget.offerDetailsModelData!.adOn!.isNotEmpty) {
                      final adOnList = widget.offerDetailsModelData!.adOn!
                          .whereType<OfferDetailsModelDataAdOn>()
                          .map((e) => e.toJson()
                          .map((key, value) => MapEntry(key.toString(), value.toString())))
                          .toList();

                      queryParams['adOn'] = jsonEncode(adOnList);;
                    }
                    if (removedId.isNotEmpty) {
                      queryParams.putIfAbsent(
                        'removeImageIds',
                            () => removedId.join(','),
                      );
                    }

                    if (kDebugMode) {
                      print(queryParams);
                    }
                    await _uploadImages();
                  } else {
                    try {
                      print(widget.offerDetailsModelData?.adOn?.length);
                      showGetXCircularDialog();
                      await profileController.editOffer(
                        description: description,
                        name: name,
                        price: price,
                        deliveryTime: deliveryTime,
                        removedImageId: removedId,
                        offerId:
                        widget.offerDetailsModelData?.id.toString() ?? '',
                        adOn: (widget.offerDetailsModelData?.adOn != null && widget.offerDetailsModelData!.adOn!.isNotEmpty)
                            ? widget.offerDetailsModelData!.adOn!
                            .whereType<OfferDetailsModelDataAdOn>() // filters out nulls
                            .map((e) => e.toJson()) // ensure `toJson()` exists in your model
                            .toList()
                            : null,
                      );
                      Get.back();
                      showSuccess(
                        title: 'Offer',
                        message: 'Offer updated successfully',
                      );
                      profileController.getOffersApi();
                    } catch (e) {
                      showError(title: 'Edit Offer', message: e.toString());
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GridImage {
  final File? file;
  final String? url;
  final int? id; // backend ID for network images

  GridImage({this.file, this.url, this.id})
      : assert(
  file != null || url != null,
  'Either file or url must be non-null',
  );

  ImageProvider get provider =>
      file != null ? FileImage(file!) : NetworkImage(url!);
}
