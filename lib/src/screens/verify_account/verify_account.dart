/* import 'package:cached_network_image/cached_network_image.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/models/verify_account/owner_verification.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/screens/verify_account/location_input.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/button_custom.dart';
import 'package:smart_admin/src/utils/texts/button_custom_outlined.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:smart_admin/src/utils/texts/text_form_field_simple_custom.dart';
import 'package:smart_admin/src/utils/validators/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({super.key});

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  int currentStep = 0;
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final companyNameController = TextEditingController();
  final companyOwnerNameController = TextEditingController();
  final companyIFUNumberController = TextEditingController();
  final companyAdresseController = TextEditingController();
  final companyNumberController = TextEditingController();
  final companyRegisteSellController = TextEditingController();
  PlaceLocation? _selectedLocation;
  bool _isSubmitting = false;
  late OwnerVerificationModel ownerVerificationModel;

  bool isUploading = false;
  File? imageFile;
  String? registreImage;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  void _submitVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    final firebase = FirebaseFirestore.instance.collection(
      "ownerverifications",
    );
    if (user == null) return;

    setState(() => _isSubmitting = true);

    final ownerverificationjson = OwnerVerificationModel(
      userId: user.uid,
      companyName: companyNameController.text.trim(),
      companyOwnerName: companyOwnerNameController.text.trim(),
      companyIFUNumber: companyIFUNumberController.text.trim(),
      companyAdresse: _selectedLocation!.address,
      companyLocation: PlaceLocation(
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        address: _selectedLocation!.address,
      ),
      companyNumber: companyNumberController.text.trim(),
      registryDocUrl: registreImage!,
      status: 'pending',
      step1: VerificationStep(status: "pending"),
      step2: VerificationStep(status: "pending"),
      step3: VerificationStep(status: "pending"),
      createdAt: Timestamp.now(),
    );

    try {
      await firebase.doc(user.uid).set(ownerverificationjson.toMap());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Soumission réussie')));

      // Get.offAll(() => const TabsScreen(initialIndex: 0));
    } catch (e) {
      print('Erreur soumission $e');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur soumission $e')));
    }

    setState(() => _isSubmitting = false);
  }

  /*   bool _validateStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return companyNameController.text.isNotEmpty &&
            companyOwnerNameController.text.isNotEmpty &&
            companyIFUNumberController.text.isNotEmpty &&
            companyNumberController.text.isNotEmpty;
      case 1:
        return _selectedLocation != null;
      case 2:
        return companyRegisteSellController.text.isNotEmpty;
      default:
        return false;
    }
  } */

  StepState _getStepState(VerificationStep step, int index) {
    if (step.status == 'rejected') return StepState.error;
    if (step.status == 'approved') return StepState.complete;
    return currentStep == index ? StepState.editing : StepState.indexed;
  }

  Widget _buildStepError(String? reason) {
    if (reason == null) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(reason, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> loadExistingVerification() async {
    final doc = await FirebaseFirestore.instance
        .collection("ownerverifications")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (doc.exists) {
      ownerVerificationModel = OwnerVerificationModel.fromMap(doc.data()!);

      setState(() {
        companyNameController.text = ownerVerificationModel.companyName;
        companyOwnerNameController.text =
            ownerVerificationModel.companyOwnerName;
        companyIFUNumberController.text =
            ownerVerificationModel.companyIFUNumber;
        companyNumberController.text = ownerVerificationModel.companyNumber;
        companyAdresseController.text = ownerVerificationModel.companyAdresse;
        registreImage = ownerVerificationModel.registryDocUrl;
        _selectedLocation = ownerVerificationModel.companyLocation;
      });
    } else {
      // ownerVerificationModel = OwnerVerificationModel.empty();
    }

    setState(() {});
  }

  /* Management Principale Images */

  Future<void> _pickGalleryCarImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 675,
      maxWidth: 900,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      uploadCarImage(imageFile!);
    }
    Get.back();
  }

  Future _pickImageCarCamera() async {
    // final ImagePicker picker = ImagePicker();
    final returnImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 900,
    );
    // final LostDataResponse response = await picker.retrieveLostData();
    if (returnImage == null) return;

    ///load result and file details
    if (returnImage != null) {
      imageFile = File(returnImage.path);
      uploadCarImage(imageFile!);
      Get.back();
    }
  }

  Future<String> uploadCarImage(File file) async {
    try {
      setState(() {
        isUploading = true;
      });

      final storageRef = _storage.ref().child(
        'verify/${DateTime.now().millisecondsSinceEpoch}',
      );
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      setState(() {
        registreImage = url;
      });

      // Vider le cache
      await CachedNetworkImage.evictFromCache(url);

      return url;
    } catch (e) {
      print("Erreur d'upload: $e");
      rethrow;
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void showImagePickerCarOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickGalleryCarImage();
                    },
                    child: Column(
                      children: [Icon(Icons.image, size: 70), Text("Gallery")],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageCarCamera();
                    },
                    child: Column(
                      children: [
                        Icon(Icons.camera_enhance, size: 70),
                        Text("Camera"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    loadExistingVerification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tWhiteColor
                : ColorApp.tBlackColor,
          ),
          onPressed: () => Get.offAll(() => const TabsScreen(initialIndex: 0)),
        ),
        title: const TextCustom(
          TheText: "Vérification de mon compte",
          TheTextSize: 14,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ownerverifications')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            FirebaseFirestore.instance
                .collection('ownerverifications')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set({
                  'status': 'nouveau',
                  'step1': {'status': 'waiting', 'reason': ''},
                  'step2': {'status': 'waiting', 'reason': ''},
                  'step3': {'status': 'waiting', 'reason': ''},
                });
            setState(() {
              currentStep = 0;
            });
          }

          final data = snapshot.data!.data();
          final ownerVerificationModel = OwnerVerificationModel.fromMap(data!);
          final isPending = ownerVerificationModel.status == 'pending';

          final steps = [
            ownerVerificationModel.step1,
            ownerVerificationModel.step2,
            ownerVerificationModel.step3,
          ];

          final firstIncompleteIndex = steps.indexWhere(
            (s) => s.status == 'rejected',
          );

          if (isPending) {
            if (firstIncompleteIndex != -1 &&
                currentStep != firstIncompleteIndex) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => currentStep = firstIncompleteIndex);
              });
            } else if (steps.every((s) => s.status != 'rejected') &&
                currentStep != 3) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => currentStep = 3);
              });
            }
          }

          return Stepper(
            currentStep: currentStep,
            onStepContinue: isPending
                ? null
                : () {
                    print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
                    if (currentStep == 0 &&
                        _step1Key.currentState!.validate()) {
                      setState(() => currentStep += 1);
                    } else if (currentStep == 1) {
                      if (_selectedLocation == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Veuillez sélectionner la localisation.",
                            ),
                          ),
                        );
                        return;
                      }
                      setState(() => currentStep += 1);
                    } else if (currentStep == 2) {
                      if (!_step2Key.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Veuillez uploader le registre."),
                          ),
                        );
                        return;
                      }
                      _submitVerification();
                      setState(() => currentStep += 1);
                    }
                  },
            onStepCancel: isPending
                ? null
                : () {
                    if (currentStep > 0) {
                      setState(() => currentStep -= 1);
                    }
                  },
            onStepTapped: (index) {
              final stepStatus = steps[index].status;
              if (stepStatus != 'approved' && !isPending) {
                setState(() => currentStep = index);
              }
            },

            controlsBuilder: (context, details) {
              if (isPending) return const SizedBox.shrink(); // Ne rien afficher
              return Row(
                spacing: 5,
                children: [
                  if (currentStep > 0 && currentStep < 3)
                    Expanded(
                      child: ButtonCustomOutlined(
                        onPressed: details.onStepCancel,
                        text: 'Retour',
                        buttonBackgroundColor: ColorApp.tAccentColor,
                        textSize: 12,
                      ),
                    ),
                  if (currentStep < 3)
                    Expanded(
                      child: ButtonCustom(
                        onPressed: details.onStepContinue,
                        text: currentStep < 2 ? "Suivant" : "Soumettre",
                        buttonBackgroundColor: ColorApp.tAccentColor,
                        textSize: 12,
                      ),
                    ),
                ],
              );
            },
            type: StepperType.vertical,
            steps: [
              Step(
                title: Text("Identité de l'entreprise"),
                isActive: currentStep >= 0,
                state: _getStepState(ownerVerificationModel.step1, 0),
                content: Form(
                  key: _step1Key,
                  child: Column(
                    children: [
                      _buildStepError(ownerVerificationModel.step1.reason),
                      companyNameText(),
                      const SizedBox(height: 10),
                      companyNameField(
                        companyNameController: companyNameController,
                      ),
                      const SizedBox(height: 10),
                      companyOwnerNameText(),
                      const SizedBox(height: 10),
                      companyOwnerNameField(
                        companyOwnerNameController: companyOwnerNameController,
                      ),
                      const SizedBox(height: 10),
                      companyIFUNumberText(),
                      const SizedBox(height: 10),
                      companyIFUNumberField(
                        companyIFUNumberController: companyIFUNumberController,
                      ),
                      const SizedBox(height: 10),
                      companyNumberText(),
                      const SizedBox(height: 10),
                      companyNumberField(
                        companyNumberController: companyNumberController,
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Step(
                title: Text("Localisation"),
                isActive: currentStep >= 1,
                state: _getStepState(ownerVerificationModel.step2, 1),
                content: Column(
                  children: [
                    _buildStepError(ownerVerificationModel.step2.reason),
                    companyAdresseText(),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [instructionCompanyAdresseText()],
                    ),
                    const SizedBox(height: 10),
                    LocationInput(
                      onSelectedLocation: (value) {
                        _selectedLocation = value;
                        print(_selectedLocation!.address);
                      },
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Step(
                title: Text("Registre de commerce"),
                isActive: currentStep >= 2,
                state: _getStepState(ownerVerificationModel.step3, 2),
                content: Form(
                  key: _step2Key,
                  child: Column(
                    children: [
                      _buildStepError(ownerVerificationModel.step3.reason),
                      companyRegisteSellText(),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 160,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 1,
                            color: THelperFunctions.isDarkMode(context)
                                ? ColorApp.tWhiteColor
                                : ColorApp.tBlackColor,
                          ),
                        ),
                        child: Stack(
                          children: [
                            registreImage == null
                                ? GestureDetector(
                                    onTap: () {
                                      showImagePickerCarOption(context);
                                    },
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.camera),
                                          SizedBox(width: 5),
                                          Text("tCarImageText".tr),
                                        ],
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: GestureDetector(
                                      onTap: () {
                                        showImagePickerCarOption(context);
                                      },
                                      child: Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        child: Image.network(
                                          registreImage!,
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.error,
                                                  size: 50,
                                                  color: Colors.red,
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                  ),
                            if (isUploading)
                              const Positioned.fill(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: ColorApp.tsecondaryColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      /* companyRegisteSellField(
                        companyRegisteSellController:
                            companyRegisteSellController,
                      ), */
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Step(
                title: const Text('Confirmation'),
                content: isPending
                    ? const Text(
                        "✅ Vous avez terminé la soumission. Un administrateur est en train de valider vos informations.",
                      )
                    : const Text("✅ Votre compte a été vérifié avec succès. "),
                isActive: currentStep >= 3,
                state: StepState.complete,
              ),
            ],
          );
        },
      ),
    );
  }
}

class companyRegisteSellText extends StatelessWidget {
  const companyRegisteSellText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextCustom(
          TheText: "companyRegisteSell".tr,
          TheTextSize: 14,
          TheTextFontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

class instructionCompanyAdresseText extends StatelessWidget {
  const instructionCompanyAdresseText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Icon(Icons.warning, color: ColorApp.tPrimaryColor),
        Expanded(
          child: TextCustom(
            TheText: "instructionCompanyAdresse".tr,
            TheTextSize: 14,
            TheTextFontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class companyAdresseText extends StatelessWidget {
  const companyAdresseText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextCustom(
          TheText: "companyAdresse".tr,
          TheTextSize: 14,
          TheTextFontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

class companyNumberText extends StatelessWidget {
  const companyNumberText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextCustom(
          TheText: "companyNumber".tr,
          TheTextSize: 14,
          TheTextFontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

class companyIFUNumberText extends StatelessWidget {
  const companyIFUNumberText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextCustom(
          TheText: "companyIFUNumber".tr,
          TheTextSize: 14,
          TheTextFontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

class companyOwnerNameText extends StatelessWidget {
  const companyOwnerNameText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextCustom(
          TheText: "companyOwnerName".tr,
          TheTextSize: 14,
          TheTextFontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

class companyNameText extends StatelessWidget {
  const companyNameText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextCustom(
          TheText: "companyName".tr,
          TheTextSize: 14,
          TheTextFontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

class companyRegisteSellField extends StatelessWidget {
  const companyRegisteSellField({
    super.key,
    required this.companyRegisteSellController,
  });

  final TextEditingController companyRegisteSellController;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldSimpleCustom(
      keyboardType: TextInputType.text,
      obscureText: false,
      borderRadiusBorder: 10,
      cursorColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      borderSideRadiusBorder: THelperFunctions.isDarkMode(context)
          ? ColorApp.tsecondaryColor
          : ColorApp.tSombreColor,
      borderRadiusFocusedBorder: 10,
      borderSideRadiusFocusedBorder: THelperFunctions.isDarkMode(context)
          ? ColorApp.tsecondaryColor
          : ColorApp.tSombreColor,
      controller: companyRegisteSellController,
      labelText: "companyRegisteSell".tr,
      labelStyleColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      hintText: "companyRegisteSell".tr,
      hintStyleColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      prefixIcon: Icon(
        Icons.file_open,
        color: THelperFunctions.isDarkMode(context)
            ? ColorApp.tWhiteColor
            : ColorApp.tBlackColor,
      ),
      validator: (value) =>
          TValidator.validationEmptyText("companyRegisteSell".tr, value),
    );
  }
}

class companyNumberField extends StatelessWidget {
  const companyNumberField({super.key, required this.companyNumberController});

  final TextEditingController companyNumberController;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldSimpleCustom(
      keyboardType: TextInputType.number,
      obscureText: false,
      borderRadiusBorder: 10,
      cursorColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      borderSideRadiusBorder: THelperFunctions.isDarkMode(context)
          ? ColorApp.tsecondaryColor
          : ColorApp.tSombreColor,
      borderRadiusFocusedBorder: 10,
      borderSideRadiusFocusedBorder: THelperFunctions.isDarkMode(context)
          ? ColorApp.tsecondaryColor
          : ColorApp.tSombreColor,
      controller: companyNumberController,
      labelText: "companyNumber".tr,
      labelStyleColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      hintText: "companyNumber".tr,
      hintStyleColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      prefixIcon: Icon(
        Icons.phone_android,
        color: THelperFunctions.isDarkMode(context)
            ? ColorApp.tWhiteColor
            : ColorApp.tBlackColor,
      ),
      validator: (value) => TValidator.validationPhoneNumber(value),
    );
  }
}

class companyIFUNumberField extends StatelessWidget {
  const companyIFUNumberField({
    super.key,
    required this.companyIFUNumberController,
  });

  final TextEditingController companyIFUNumberController;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldSimpleCustom(
      keyboardType: TextInputType.number,
      obscureText: false,
      borderRadiusBorder: 10,
      cursorColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      borderSideRadiusBorder: THelperFunctions.isDarkMode(context)
          ? ColorApp.tsecondaryColor
          : ColorApp.tSombreColor,
      borderRadiusFocusedBorder: 10,
      borderSideRadiusFocusedBorder: THelperFunctions.isDarkMode(context)
          ? ColorApp.tsecondaryColor
          : ColorApp.tSombreColor,
      controller: companyIFUNumberController,
      labelText: "companyIFUNumber".tr,
      labelStyleColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      hintText: "companyIFUNumber".tr,
      hintStyleColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      prefixIcon: Icon(
        Icons.numbers,
        color: THelperFunctions.isDarkMode(context)
            ? ColorApp.tWhiteColor
            : ColorApp.tBlackColor,
      ),
      validator: (value) => TValidator.validationIFUNumber(value),
    );
  }
}

class companyOwnerNameField extends StatelessWidget {
  const companyOwnerNameField({
    super.key,
    required this.companyOwnerNameController,
  });

  final TextEditingController companyOwnerNameController;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldSimpleCustom(
      keyboardType: TextInputType.text,
      obscureText: false,
      borderRadiusBorder: 10,
      cursorColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      borderSideRadiusBorder: THelperFunctions.isDarkMode(context)
          ? ColorApp.tsecondaryColor
          : ColorApp.tSombreColor,
      borderRadiusFocusedBorder: 10,
      borderSideRadiusFocusedBorder: THelperFunctions.isDarkMode(context)
          ? ColorApp.tsecondaryColor
          : ColorApp.tSombreColor,
      controller: companyOwnerNameController,
      labelText: "companyOwnerName".tr,
      labelStyleColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      hintText: "companyOwnerName".tr,
      hintStyleColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      prefixIcon: Icon(
        Icons.person_2_outlined,
        color: THelperFunctions.isDarkMode(context)
            ? ColorApp.tWhiteColor
            : ColorApp.tBlackColor,
      ),
      validator: (value) =>
          TValidator.validationEmptyText("companyOwnerName".tr, value),
    );
  }
}

class companyNameField extends StatelessWidget {
  const companyNameField({super.key, required this.companyNameController});

  final TextEditingController companyNameController;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldSimpleCustom(
      keyboardType: TextInputType.text,
      obscureText: false,
      borderRadiusBorder: 10,
      cursorColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      borderSideRadiusBorder: THelperFunctions.isDarkMode(context)
          ? ColorApp.tsecondaryColor
          : ColorApp.tSombreColor,
      borderRadiusFocusedBorder: 10,
      borderSideRadiusFocusedBorder: THelperFunctions.isDarkMode(context)
          ? ColorApp.tsecondaryColor
          : ColorApp.tSombreColor,
      controller: companyNameController,
      labelText: "companyName".tr,
      labelStyleColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      hintText: "companyName".tr,
      hintStyleColor: THelperFunctions.isDarkMode(context)
          ? ColorApp.tWhiteColor
          : ColorApp.tBlackColor,
      prefixIcon: Icon(
        Icons.work,
        color: THelperFunctions.isDarkMode(context)
            ? ColorApp.tWhiteColor
            : ColorApp.tBlackColor,
      ),
      validator: (value) =>
          TValidator.validationEmptyText("companyName".tr, value),
    );
  }
}
 */
