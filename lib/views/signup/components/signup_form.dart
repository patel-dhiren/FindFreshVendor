import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fresh_find_vendor/constants/constants.dart';
import 'package:image_picker/image_picker.dart';

import '../../../firebase/firebase_service.dart';
import '../../../model/app_user.dart';
import '../../../model/category.dart';
import '../../../utils/app_util.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _vendorName = '';
  String _businessName = '';
  String _contactNumber = '';
  String _address = '';
  String _selectedState = 'Select State';
  String _selectedCity = 'Select City';
  bool _isLoading = false;
  bool _isHidden = true;

  // Simplified example, expand this according to your needs
  Map<String, List<String>> stateCityMap = {
    'Select State': ['Select City'],
    'Andhra Pradesh': [
      'Visakhapatnam',
      'Vijayawada',
      'Guntur',
      'Nellore',
      'Kurnool'
    ],
    'Arunachal Pradesh': ['Itanagar', 'Tawang', 'Pasighat', 'Ziro', 'Bomdila'],
    'Assam': ['Guwahati', 'Silchar', 'Dibrugarh', 'Jorhat', 'Nagaon'],
    'Bihar': ['Patna', 'Gaya', 'Bhagalpur', 'Muzaffarpur', 'Purnia'],
    'Chhattisgarh': ['Raipur', 'Bhilai', 'Bilaspur', 'Korba', 'Raigarh'],
    'Goa': ['Panaji', 'Margao', 'Vasco da Gama', 'Mapusa', 'Ponda'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Jamnagar'],
    'Haryana': ['Gurugram', 'Faridabad', 'Panipat', 'Ambala', 'Rohtak'],
    'Himachal Pradesh': ['Shimla', 'Dharamshala', 'Manali', 'Solan', 'Mandi'],
    'Jharkhand': ['Ranchi', 'Jamshedpur', 'Dhanbad', 'Bokaro', 'Deoghar'],
    'Karnataka': ['Bengaluru', 'Mysuru', 'Mangaluru', 'Hubballi', 'Belagavi'],
    'Kerala': [
      'Thiruvananthapuram',
      'Kochi',
      'Kozhikode',
      'Thrissur',
      'Kannur'
    ],
    'Madhya Pradesh': ['Bhopal', 'Indore', 'Gwalior', 'Jabalpur', 'Ujjain'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad'],
    'Manipur': ['Imphal', 'Churachandpur', 'Thoubal', 'Bishnupur', 'Ukhrul'],
    'Meghalaya': ['Shillong', 'Tura', 'Jowai', 'Nongstoin', 'Baghmara'],
    'Mizoram': ['Aizawl', 'Lunglei', 'Saiha', 'Champhai', 'Kolasib'],
    'Nagaland': ['Kohima', 'Dimapur', 'Mokokchung', 'Wokha', 'Tuensang'],
    'Odisha': ['Bhubaneswar', 'Cuttack', 'Rourkela', 'Berhampur', 'Sambalpur'],
    'Punjab': ['Chandigarh', 'Ludhiana', 'Amritsar', 'Jalandhar', 'Patiala'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur', 'Kota', 'Ajmer'],
    'Sikkim': ['Gangtok', 'Pelling', 'Namchi', 'Lachung', 'Ravangla'],
    'Tamil Nadu': [
      'Chennai',
      'Coimbatore',
      'Madurai',
      'Tiruchirappalli',
      'Salem'
    ],
    'Telangana': [
      'Hyderabad',
      'Warangal',
      'Nizamabad',
      'Khammam',
      'Karimnagar'
    ],
    'Tripura': [
      'Agartala',
      'Udaipur',
      'Dharmanagar',
      'Pratapgarh',
      'Kailashahar'
    ],
    'Uttar Pradesh': ['Lucknow', 'Varanasi', 'Agra', 'Kanpur', 'Allahabad'],
    'Uttarakhand': ['Dehradun', 'Haridwar', 'Roorkee', 'Haldwani', 'Rudrapur'],
    'West Bengal': ['Kolkata', 'Darjeeling', 'Siliguri', 'Howrah', 'Durgapur'],
    // Union Territories
    'Andaman and Nicobar Islands': [
      'Port Blair',
      'Havelock Island',
      'Neil Island'
    ],
    'Chandigarh': ['Chandigarh'],
    'Dadra and Nagar Haveli and Daman and Diu': ['Daman', 'Silvassa'],
    'Delhi': ['New Delhi', 'Delhi', 'Rohini', 'Dwarka', 'Saket'],
    'Lakshadweep': ['Kavaratti', 'Agatti', 'Minicoy'],
    'Puducherry': ['Puducherry', 'Karaikal', 'Yanam', 'Mahe'],
    'Ladakh': ['Leh', 'Kargil'],
  };

  List<String> _cities = ['Select City'];
  XFile? _newImage;
  List<Category> _categories = [];
  String? _categoryId;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _updateCities(String state) {
    setState(() {
      _selectedState = state;
      _cities = stateCityMap[state]!;
      _selectedCity = _cities.first;
    });
  }

  String? _validateRequiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    String pattern = r'\w+@\w+\.\w+';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      final appUser = AppUser(
        email: _email,
        password: _password,
        vendorName: _vendorName,
        businessName: _businessName,
        contactNumber: _contactNumber,
        address: _address,
        state: _selectedState,
        city: _selectedCity,
        categoryId: _categoryId!
      );

      String? errorMessage = await FirebaseService()
          .createUserWithEmailAndPassword(appUser, _newImage);

      if (errorMessage != null) {
        // Show error message
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      } else {
        setState(() => _isLoading = false);
        // Navigate to home or any other page
        Navigator.pushNamedAndRemoveUntil(
            context, AppConstant.homeView, (route) => false);
      }
    }
  }

  Future<void> pickImage() async {
    var image = await AppUtil.pickImageFromGallery();

    if (image != null) {
      setState(() {
        _newImage = image;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    List<Category> categories = await FirebaseService().loadCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              pickImage();
            },
            child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white.withOpacity(.7),
                child: _newImage != null
                    ? CircleAvatar(
                        radius: 60,
                        foregroundImage: FileImage(
                          File(_newImage!.path),
                        ),
                      )
                    : CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.orange.shade100,
                        child: Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.grey,
                        ),
                      )),
          ),
          SizedBox(height: 24),
          TextFormField(
            decoration: InputDecoration(labelText: 'Vendor Name'),
            validator: (value) => _validateRequiredField(value, 'Vendor Name'),
            onSaved: (value) => _vendorName = value ?? '',
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Business Name'),
            validator: (value) =>
                _validateRequiredField(value, 'Business Name'),
            onSaved: (value) => _businessName = value ?? '',
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email Address'),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            onSaved: (value) => _email = value ?? '',
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Contact Number'),
            keyboardType: TextInputType.phone,
            validator: (value) =>
                _validateRequiredField(value, 'Contact Number'),
            onSaved: (value) => _contactNumber = value ?? '',
          ),
          DropdownButtonFormField<String>(
            value: _categoryId,
            decoration: InputDecoration(labelText: 'Select Category'),
            items: _categories
                .map<DropdownMenuItem<String>>((Category category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _categoryId = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            value: _selectedState,
            items: stateCityMap.keys.map((String state) {
              return DropdownMenuItem(value: state, child: Text(state));
            }).toList(),
            onChanged: (value) => _updateCities(value.toString()),
            decoration: InputDecoration(labelText: 'State'),
          ),
          DropdownButtonFormField(
            value: _selectedCity,
            items: _cities.map((String city) {
              return DropdownMenuItem(value: city, child: Text(city));
            }).toList(),
            onChanged: (value) =>
                setState(() => _selectedCity = value.toString()),
            decoration: InputDecoration(labelText: 'City'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Address'),
            validator: (value) => _validateRequiredField(value, 'Address'),
            onSaved: (value) => _address = value ?? '',
          ),
          TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: _isHidden
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: _toggleVisibility,
                ),
              ),
              obscureText: _isHidden,
              onSaved: (value) {
                _password = value ?? '';
              },
              validator: _validatePassword),
          SizedBox(height: 24),
          _isLoading
              ? CircularProgressIndicator(
                  color: Colors.orange,
                )
              : Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white),
                    onPressed: _signUp,
                    child: Text('SIGN UP'),
                  ),
                ),
        ],
      ),
    );
  }
}
