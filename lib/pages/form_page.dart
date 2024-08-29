import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vcard1/models/contact_model.dart';
import 'package:vcard1/pages/homepage.dart';
import 'package:vcard1/provider/contact_provider.dart';
import 'package:vcard1/utils/constants.dart';
import 'package:vcard1/utils/helper_function.dart';

class FormPage extends StatefulWidget {
  static const String routeName = 'form';
  final ContactModel contactModel;
  const FormPage({super.key, required this.contactModel});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final companyController = TextEditingController();
  final designationController = TextEditingController();
  final webController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    nameController.text = widget.contactModel.name;
    mobileController.text = widget.contactModel.mobile;
    emailController.text = widget.contactModel.email;
    addressController.text = widget.contactModel.address;
    companyController.text = widget.contactModel.company;
    designationController.text = widget.contactModel.designation;
    webController.text = widget.contactModel.website;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Form Page'),
        actions: [
          IconButton(
            onPressed: saveContact, 
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Contact Name'
              ),
            validator: (value) {
              if(value == null || value.isEmpty){
                return emptyFieldErrMsg;
              }
              return null;
            }
            ),
            TextFormField(
              controller: mobileController,
              decoration: InputDecoration(
                labelText: 'Contact Mobile'
              ),
            validator: (value) {
              if(value == null || value.isEmpty){
                return emptyFieldErrMsg;
              }
              return null;
            }
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email'
              ),
            validator: (value) {
              return null;
            }
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address'
              ),
            validator: (value) {
              return null;
            }
            ),
            TextFormField(
              controller: companyController,
              decoration: InputDecoration(
                labelText: 'Company'
              ),
            validator: (value) {
              return null;
            }
            ),
            TextFormField(
              controller: designationController,
              decoration: InputDecoration(
                labelText: 'Designation'
              ),
            validator: (value) {
              return null;
            }
            ),
            TextFormField(
              controller: webController,
              decoration: InputDecoration(
                labelText: 'Website'
              ),
            validator: (value) {
              return null;
            }
            ),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    companyController.dispose();
    designationController.dispose();
    webController.dispose();
    super.dispose();
  }

  void saveContact() async{
    if(_formkey.currentState!.validate()){
      widget.contactModel.name = nameController.text;
      widget.contactModel.mobile = mobileController.text;
      widget.contactModel.email = emailController.text;
      widget.contactModel.address = addressController.text;
      widget.contactModel.company = companyController.text;
      widget.contactModel.designation = designationController.text;
      widget.contactModel.website = webController.text;
    }
    Provider.of<ContactProvider>(context, listen: false)
    .insertContact(widget.contactModel)
    .then((value) {
      if(value > 0){
        showMsg(context, 'Saved');
        context.goNamed(HomePage.routeName);
      }

    }).catchError((error){
      showMsg(context, 'Failed to save');
    });

  }
}