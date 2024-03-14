import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fresh_find_vendor/utils/app_util.dart';

import '../../constants/constants.dart';
import '../../firebase/firebase_service.dart';
import '../../model/app_user.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      final appUser = AppUser(
        email: _email,
        password: user.password,
        vendorName: _vendorName,
        businessName: _businessName,
        contactNumber: _contactNumber,
        address: _address,
        state: _selectedState,
        city: _selectedCity,
      );
      appUser.createdAt = user.createdAt;

      try {
        await FirebaseService().updateVendorProfile(appUser);
        setState(() => _isLoading = false);
        AppUtil.showToast("Profile updated successfully");
      } on FirebaseAuthException catch (e) {
        setState(() => _isLoading = false);
      }
    }
  }

  final _emailController = TextEditingController();
  final _businessController = TextEditingController();
  final _vendorController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVendorProfile();
  }

  late AppUser user;

  Future<void> _loadVendorProfile() async {
    try {
      user = await FirebaseService().fetchVendorById();
      setState(() {
        _emailController.text = user.email;
        _vendorController.text = user.vendorName;
        _businessController.text = user.businessName;
        _contactController.text = user.contactNumber;
        _addressController.text = user.address;
        _selectedState = user.state;
        _selectedCity = user.city;
        _cities = stateCityMap[_selectedState]!;
        _selectedCity = user.city;
      });
    } catch (e) {
      print("Error fetching profile: $e");
      // Handle error, possibly by showing an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _vendorController,
                        decoration: InputDecoration(labelText: 'Vendor Name'),
                        validator: (value) =>
                            _validateRequiredField(value, 'Vendor Name'),
                        onSaved: (value) => _vendorName = value ?? '',
                      ),
                      TextFormField(
                        controller: _businessController,
                        decoration: InputDecoration(labelText: 'Business Name'),
                        validator: (value) =>
                            _validateRequiredField(value, 'Business Name'),
                        onSaved: (value) => _businessName = value ?? '',
                      ),
                      TextFormField(
                        controller: _emailController,
                        enabled: false,
                        decoration: InputDecoration(labelText: 'Email Address'),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        onSaved: (value) => _email = value ?? '',
                      ),
                      TextFormField(
                        controller: _contactController,
                        decoration:
                            InputDecoration(labelText: 'Contact Number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            _validateRequiredField(value, 'Contact Number'),
                        onSaved: (value) => _contactNumber = value ?? '',
                      ),
                      DropdownButtonFormField(
                        value: _selectedState,
                        items: stateCityMap.keys.map((String state) {
                          return DropdownMenuItem(
                              value: state, child: Text(state));
                        }).toList(),
                        onChanged: (value) => _updateCities(value.toString()),
                        decoration: InputDecoration(labelText: 'State'),
                      ),
                      DropdownButtonFormField(
                        value: _selectedCity,
                        items: _cities.map((String city) {
                          return DropdownMenuItem(
                              value: city, child: Text(city));
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedCity = value.toString()),
                        decoration: InputDecoration(labelText: 'City'),
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(labelText: 'Address'),
                        validator: (value) =>
                            _validateRequiredField(value, 'Address'),
                        onSaved: (value) => _address = value ?? '',
                      ),
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
                                onPressed: _updateProfile,
                                child: Text('UPDATE PROFILE'),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
