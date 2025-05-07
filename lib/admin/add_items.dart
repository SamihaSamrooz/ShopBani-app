import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shop_bani/widget/widget_support.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  bool isLoading = false;

  final List<String> items = ['Bags', 'Perfumes', 'Glasses', 'Pouch'];
  String? value;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  //getting the image from the gallery and saving and uplaoding it to cloudinary
  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
      String? imageUrl = await uploadImageToCloudinary(selectedImage!);

      if (imageUrl != null) {
        print('Image uploaded successfully: $imageUrl');
      } else {
        print('Image upload failed');
      }
    }
  }

  //Uploading the images to cloudinary
  Future<void> uploadItem() async {
    if (selectedImage != null &&
        namecontroller.text.trim().isNotEmpty &&
        pricecontroller.text.trim().isNotEmpty &&
        detailcontroller.text.trim().isNotEmpty &&
        value != null) {
      String? imageUrl = await uploadImageToCloudinary(selectedImage!);

      // data-mapping for firestore
      if (imageUrl != null) {
        Map<String, dynamic> addItem = {
          "image": imageUrl,
          "name": namecontroller.text.trim(),
          "price": pricecontroller.text.trim(),
          "detail": detailcontroller.text.trim(),
          "timestamp": FieldValue.serverTimestamp(),
        };
        //adding the value to firestore collection
        await FirebaseFirestore.instance
            .collection(value!)
            .add(addItem)
            .then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.orangeAccent,
                  content: Text(
                    "Product added Successfully",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              );

              // Clear input fields to reset the form after successful uploading
              setState(() {
                namecontroller.clear();
                pricecontroller.clear();
                detailcontroller.clear();
                selectedImage = null;
                value = null;
              });
            })
            .catchError((e) {
              print("Firestore error: $e");
            });
      } else {
        print("Cloudinary image upload failed");
      }
    } else {
      print("Please fill in all fields and select an image.");
    }
  }

  // main function to upload the image in cloudinary and get back the image uRL
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    final cloudinaryUploadUrl = dotenv.env['CLOUDINARY_URL'];
    final uploadPreset = dotenv.env['UPLOAD_PRESET'];

    if (cloudinaryUploadUrl == null || uploadPreset == null) {
      print("Cloudinary URL or Upload Preset is missing in .env file.");
      return null;
    }

    final request =
        http.MultipartRequest('POST', Uri.parse(cloudinaryUploadUrl))
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    final response = await request.send(); //sends the request to cloudinary

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final resJson = json.decode(resStr);
      return resJson['secure_url']; //URL to assess the image
    } else {
      print("Cloudinary upload failed: ${response.statusCode}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 218, 217),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xFF373866),
          ),
        ),
        centerTitle: true,
        title: Text("Add Items", style: AppWidget.headlineTextFeildStyle()),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
            bottom: 50.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload Product Picture",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              SizedBox(height: 20.0),
              selectedImage == null
                  ? GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                  : Center(
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
              SizedBox(height: 20.0),
              Text("Product Name", style: AppWidget.semiBoldTextFeildStyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 209, 140, 140),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Product Name",
                    hintStyle: AppWidget.lightTextFeildStyle(),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Product Price", style: AppWidget.semiBoldTextFeildStyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 209, 140, 140),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: pricecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Product Price",
                    hintStyle: AppWidget.lightTextFeildStyle(),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Product Detail", style: AppWidget.semiBoldTextFeildStyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 209, 140, 140),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines: 6,
                  controller: detailcontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Product Detail",
                    hintStyle: AppWidget.lightTextFeildStyle(),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Product Category",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 209, 140, 140),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items:
                        items.map((items) {
                          return DropdownMenuItem<String>(
                            value: items,
                            child: Text(
                              items,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged:
                        ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    hint: Text("Select Category"),
                    iconSize: 36,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: value,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 133, 32, 32),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap:
                            isLoading
                                ? null
                                : () async {
                                  if (selectedImage != null) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    String? imageUrl =
                                        await uploadImageToCloudinary(
                                          selectedImage!,
                                        );

                                    if (imageUrl != null) {
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection(value!)
                                            .add({
                                              "name":
                                                  namecontroller.text.trim(),
                                              "price":
                                                  pricecontroller.text.trim(),
                                              "detail":
                                                  detailcontroller.text.trim(),
                                              "image": imageUrl,
                                              "timestamp":
                                                  FieldValue.serverTimestamp(),
                                            });

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Product added successfully!",
                                            ),
                                          ),
                                        );

                                        setState(() {
                                          namecontroller.clear();
                                          pricecontroller.clear();
                                          detailcontroller.clear();
                                          value = null;
                                          selectedImage = null;
                                        });
                                      } catch (e) {
                                        print("Failed to add product: $e");
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Failed to add product.",
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      print('Image upload failed');
                                    }

                                    setState(() {
                                      isLoading = false;
                                    });
                                  } else {
                                    print('No image selected');
                                  }
                                },

                        child:
                            isLoading
                                ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  "Add",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
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
    );
  }
}
