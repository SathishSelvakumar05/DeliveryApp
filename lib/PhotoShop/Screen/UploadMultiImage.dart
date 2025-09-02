import 'dart:io';
import 'package:delivery_app/PhotoShop/Screen/single_photo_screen.dart';
import 'package:delivery_app/PhotoShop/Screen/view_all_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Components/Button/CustomButton.dart';
import '../../Components/CustomToast/CustomToast.dart';
import '../../Components/Textfield/CustomDescriptionField.dart';
import '../../Components/Textfield/CustomDropdown.dart';
import '../../Components/Textfield/CustomTextField.dart';
import '../../CustomerScreen/CustomerDashboard/CustomerDashboardScreen.dart';
import '../../Utils/Constants/ColorConstants.dart';
import '../../Utils/Constants/TextStyles.dart';
import '../Widgets/CustomSwticher.dart';
import '../Widgets/PickerComponent.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';



class UploadMultiImage extends StatefulWidget {
  const UploadMultiImage({super.key});

  @override
  State<UploadMultiImage> createState() => _UploadMultiImageState();
}

class _UploadMultiImageState extends State<UploadMultiImage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<File> _selectedImages = [];
  bool _loading = false;
  bool isOfferSelected = false;

  final picker = ImagePicker();
  final supabase = Supabase.instance.client;


  final GlobalKey _dropdownKey = GlobalKey();
  // String? selectedItems ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16).r,
      decoration: BoxDecoration(
        color:Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomElevatedButton(
            text: 'Cancel',
            onPressed: () {
              Navigator.pop(context);
            },
            buttonType: ButtonType.outlined,
          ),
          SizedBox(
            width: 10.w,
          ),
          CustomElevatedButton(
            text: "upload",
            width: 200.w,
            onPressed: () {
              _uploadData();
            },
            isLoading: _loading,
            buttonType: ButtonType.elevated,
          ),
        ],
      ),),

    // backgroundColor: const Color(0xFFf8f5f1),
      backgroundColor:Color(0xFFF5F7FA),
      appBar: AppBar(title:  Text("Upload Multiple Images",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,),),backgroundColor:Color(0xFFF5F7FA),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [

                Center(
                  child: CustomSwitcher(
                    firstTitle: "Offers",
                    secondTitle: "Upload",
                    isFirstSelected: isOfferSelected,
                    onFirstTap: () {
                      setState(() {
                        isOfferSelected = true;
                      });
                    },
                    onSecondTap: () {
                      setState(() {
                        isOfferSelected = false;
                      });
                    },
                  ),
                ),
                _selectedImages.isEmpty? dottedContainer(context,"only 3 images are allowed")
                    :
                Container(
              height: 120.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5).r,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 7.8,
                          offset: Offset(-3.6, 5.0))
                    ],
                  ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10).r,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        pickImage(context);
                      },
                      child: DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 2,
                        dashPattern: [6, 6],
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10).r,
                        child: Container(
                          height: 60.h,
                          width: 60.w,
                          alignment: Alignment.center,
                          child: Icon(Icons.add,
                              color: Theme.of(context).dividerColor, size: 50.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 15.w),
                        scrollDirection: Axis.horizontal,
                        itemCount:_selectedImages.length,
                        itemBuilder: (context, index) {
                          bool isLocalImage = true;
                          String fileExtension = _selectedImages[index].path.split('.').last??"";
                          String fileTitle =
                              "Image ${index + 1}.${fileExtension}";
                          return Column(
                            key: ValueKey(isLocalImage
                                ? _selectedImages[index].path
                                : ""),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  border:
                                  Border.all(color: Colors.grey, width: 0.50),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.file(
                                        _selectedImages[index],
                                        width: 60.w,
                                        height: 60.h,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: CircleAvatar(
                                          radius: 10.r,
                                          backgroundColor: KConstantColors.white,
                                          child: IconButton(
                                            icon: Icon(Icons.delete,
                                                color: KConstantColors.red,
                                                size: 11.sp),
                                            onPressed: () {
                                                removeImage(index);

                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        right: 5,
                                        child: CircleAvatar(
                                          radius: 10.r,
                                          backgroundColor: Colors.white,
                                          child: IconButton(
                                            icon: Icon(Icons.fullscreen,
                                                color: Colors.blue, size: 12.sp),
                                            onPressed: () => {
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                fileTitle,
                                style: TextStyle(fontSize: 8.sp),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
                 SizedBox(height: 10.h),
                if(!isOfferSelected)
                  Column(
                    children: [
                      //
                      // SearchableDropdown(lableName: "Frame Type",
                      //   dropdownKey: _dropdownKey,
                      //   selectedValue: selectedItems,
                      //   onChanged: (val) {
                      //     if(val==null||val.isEmpty)return;
                      //     setState(() {
                      //       selectedItems = val;
                      //     });
                      //   },
                      // ),
                      CustomTextField(
                        icon: Icons.currency_rupee,
                        name: 'price',
                        labelName: 'Price',
                        placeHolder: 'Enter Price ',
                        validators: [FormBuilderValidators.required()],
                      ),
                      CustomDescriptionField(
                        // icon: Icon(Icons.design_services_sharp),
                        MaxLines:  3,
                        Maxlength:  25 ,
                        name: "description",
                        placeHolder: 'Enter Description',
                        //initialValue: initialValue.isEmpty ? '' : initialValue,
                        labelName: "Description",
                        validators: [
                          FormBuilderValidators.required()
                        ],
                        required: true,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                        ),
                      ),

                    ],
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget headingText(String title, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5).r,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyleClass.textSize13Bold(
                color: Theme.of(context).hintColor),
          ),
          SizedBox(
            width: 5.w,
          ),
          if (required)
            Text(
              '*',
              style: TextStyleClass.textSize13(
                color: Colors.red.shade400,
              ),
            ),
        ],
      ),
    );
  }
  Future<void> pickImage(BuildContext context) async {
    int maxImages = 3;
    int lengthOfImages =_selectedImages.length;
    if (lengthOfImages >= maxImages) {
      showErrorToast('You Can Select Only $maxImages Images.');
      return;
    }
    final ImageSource? source = await showImageSourceDialog(context,);
    if (source == null) return;

    if (source == ImageSource.camera) {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
      );
      if (pickedFile == null) return;

      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    } else {
      int allowedImages = maxImages - lengthOfImages;
      final List<XFile> pickedFiles = await ImagePicker()
          .pickMultiImage(limit: allowedImages == 1 ? 2 : allowedImages);
      if (pickedFiles.isEmpty) return;
      if (pickedFiles.length > allowedImages) {
        showErrorToast('You Can Only Select $allowedImages More Images.');
      }
      List<File> selectedImages = pickedFiles
          .take(allowedImages)
          .map((file) => File(file.path))
          .toList();

      setState(() {
        _selectedImages.addAll(selectedImages);
      });
    }
  }
  Widget dottedContainer(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10).r,
      child: GestureDetector(
        onTap: () {
          pickImage(context);
        },
        child: DottedBorder(
          color: Colors.grey.shade400,
          strokeWidth: 1.5,
          dashPattern: [9, 3],
          borderType: BorderType.RRect,
          radius: const Radius.circular(10).r,
          child: Container(
            height: 52.h,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10).r,
            color:Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload,
                    size: 20.sp, color: Theme.of(context).primaryColorLight),
                Text(
                  text,
                  style: TextStyle(fontSize: 8.5.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }
  Future<void> _uploadData() async {

    if(isOfferSelected){
      if (_selectedImages.isEmpty) {
        showErrorToast("Please upload the image");
        return;
      }
      else{
        String bucketName='offers_bucket';
        String tableName='offers_table';
        try{
          setState(() => _loading = true);
          List<String?> imageUrls = [null, null, null];

          for (int i = 0; i < _selectedImages.length && i < 3; i++) {
            final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

            // Upload file
            final fileBytes = await _selectedImages[i].readAsBytes();
            await supabase.storage
                .from(bucketName)
                .uploadBinary(fileName, fileBytes, fileOptions: const FileOptions(upsert: false));

            // Get public URL
            final publicUrl = supabase.storage.from(bucketName).getPublicUrl(fileName);
            imageUrls[i] = publicUrl;
          }

          // Insert into Supabase table
          await supabase.from(tableName).insert({
            'image1': imageUrls[0],
            'image2': imageUrls[1],
            'image3': imageUrls[2],
          });

          showSuccessToast("Offers Uploaded Successfully");
          _formKey.currentState?.reset();
          setState(() => _selectedImages = []);
          Navigator.pop(context,true);
        }catch(e){
          print("aaaaaaaaaaaaaa");
          print("${e.toString()}");
          showErrorToast("Offers Uploaded failed");

        }
        finally{
          setState(() => _loading = false);

        }
      }
    }else{
      if (_selectedImages.isEmpty) {
        showErrorToast("Please upload the image");
        return;
      }

      if (_selectedImages.isNotEmpty && (_formKey.currentState?.saveAndValidate() ?? false)) {
        final formData = _formKey.currentState!.value;

        setState(() => _loading = true);

        try {
          // Determine bucket and table based on category
          String bucketName;
          String tableName;
          bucketName = 'wedding_bucket';
          tableName = 'wedding_table';

          List<String?> imageUrls = [null, null, null];

          for (int i = 0; i < _selectedImages.length && i < 3; i++) {
            print("3333");
            print(bucketName);
            final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

            // Upload file
            final fileBytes = await _selectedImages[i].readAsBytes();
            await supabase.storage
                .from(bucketName)
                .uploadBinary(fileName, fileBytes, fileOptions: const FileOptions(upsert: false));

            // Get public URL
            final publicUrl = supabase.storage.from(bucketName).getPublicUrl(fileName);
            imageUrls[i] = publicUrl;
          }

          // Insert into Supabase table
          await supabase.from(tableName).insert({
            'price': formData['price'].toString(),
            'description': formData['description'].toString(),
            'image1': imageUrls[0],
            'image2': imageUrls[1],
            'image3': imageUrls[2],
          });

          showSuccessToast("Uploaded Successfully");
          _formKey.currentState?.reset();
          setState(() => _selectedImages = []);
          Navigator.pop(context,true);


        } on StorageException catch (e) {
          print('object');
          showErrorToast("Storage Error: ${e.message}");
          debugPrint("Supabase storage error: ${e.message}");
        } catch (e) {
          showErrorToast("Unexpected error: $e");
          debugPrint("Unexpected error: $e");
        } finally {
          setState(() => _loading = false);
        }
      }

    }
      }
}
